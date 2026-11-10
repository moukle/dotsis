return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  enabled = true,
  init = function()
    vim.opt.foldcolumn = "1" -- fold icons in the gutter; clicking one toggles the fold (plugins/statuscol.lua)
    vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.opt.foldlevelstart = 99
    vim.opt.fillchars = [[eob: ,diff:╱,fold: ,foldopen:,foldsep: ,foldclose:]]

    -- Set fold settings
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
  config = function()
    local ufo = require("ufo")

    -- Folds stop before a line that only closes the block (`}`, `};`, `})`, `],`); take it in, so the closed fold
    -- reads `struct x { … };` instead of leaving `};` on its own line. Treesitter falls back to indent when ufo has
    -- no treesitter folds for the filetype (C++ on nvim 0.12).
    local function is_closing_line(line)
      return line ~= nil and line:match("^%s*[%]%)}][%]%)};,%s]*$") ~= nil
    end

    local function is_include(line)
      return line:match("^%s*#%s*include") ~= nil
    end

    --- First and last line (0-based) of the include block, across the blank lines between its groups; nil
    --- without two includes.
    local function include_block(lines)
      local first, last
      for i, line in ipairs(lines) do
        if is_include(line) then
          first = first or i
          last = i
        elseif first and not line:match("^%s*$") then
          break
        end
      end
      if not first or last == first then
        return nil
      end
      return first - 1, last - 1
    end

    -- Treesitter folds carry their node type as kind (`function_definition`, `if_statement`); indent folds carry none.
    local function kind_has(kind, words)
      return kind ~= nil and vim.iter(words):any(function(word) return kind:find(word) ~= nil end)
    end

    local FUNCTION_KINDS = { "function", "method", "lambda" }

    --- Whether a brace initializer like `constexpr face_layout FACE{ ... };` sits outside every function body.
    local function is_top_level_initializer(range, ranges)
      if range.kind ~= "initializer_list" then
        return false
      end
      return not vim.iter(ranges):any(function(outer)
        return kind_has(outer.kind, FUNCTION_KINDS)
          and outer.startLine <= range.startLine
          and range.endLine <= outer.endLine
      end)
    end

    local function is_closed_on_open(range, ranges)
      return (kind_has(range.kind, { "function", "method", "struct", "class" }) and range.kind ~= "lambda_expression")
        or is_top_level_initializer(range, ranges)
    end

    local function folds_with_closing_line(bufnr)
      -- Only files: the dashboard and other scratch buffers would otherwise get indent folds, closed on open.
      if vim.bo[bufnr].buftype ~= "" then
        return {}
      end
      local ok, ranges = pcall(ufo.getFolds, bufnr, "treesitter")
      if not ok or not ranges then
        ranges = ufo.getFolds(bufnr, "indent")
      end
      if not ranges then
        return nil
      end
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local closed_on_open = vim.tbl_map(function(range) return is_closed_on_open(range, ranges) end, ranges)
      for i, range in ipairs(ranges) do
        -- endLine is 0-based, so the fold's last line is lines[endLine + 1]. A fold that already ends on its own
        -- closing line keeps it; otherwise an inner `if { }` would swallow the function's `}`.
        if not is_closing_line(lines[range.endLine + 1]) and is_closing_line(lines[range.endLine + 2]) then
          range.endLine = range.endLine + 1
        end
        -- Only these folds are "region", which close_fold_kinds_for_ft closes when a buffer first opens.
        range.kind = closed_on_open[i] and "region" or nil
      end

      -- One fold over all includes, of the "imports" kind (also closed on open).
      local first, last = include_block(lines)
      if first then
        table.insert(ranges, require("ufo.model.foldingrange").new(first, last, nil, nil, "imports"))
      end
      return ranges
    end

    -- Three center dots in ufo's ellipsis box, a space on each side.
    local ELLIPSIS = { { " " }, { " ··· ", "UfoFoldedEllipsis" }, { " " } }

    -- First line, ellipsis, then the closing line when the fold took one in. An include block reads `#include … 28`.
    local function fold_chunks(virt_text, lnum, end_lnum, ctx)
      local folded = vim.api.nvim_buf_get_lines(ctx.bufnr, lnum - 1, end_lnum, false)
      if is_include(folded[1]) then
        local count = #vim.tbl_filter(is_include, folded)
        local out = vim.list_extend({ { "#include", "PreProc" } }, ELLIPSIS)
        table.insert(out, { tostring(count), "Comment" })
        return out
      end

      local out = vim.list_extend(vim.list_extend({}, virt_text), ELLIPSIS)

      if not is_closing_line(vim.api.nvim_buf_get_lines(ctx.bufnr, end_lnum - 1, end_lnum, false)[1]) then
        return out
      end
      for i, chunk in ipairs(ctx.get_fold_virt_text(end_lnum)) do
        local text = i == 1 and chunk[1]:gsub("^%s+", "") or chunk[1]
        table.insert(out, { text, chunk[2] })
      end
      return out
    end

    local LEFT_CAP = "\u{E0B6}" -- Nerd Font rounded left half-circle
    local RIGHT_CAP = "\u{E0B4}" -- Nerd Font rounded right half-circle

    -- Only the folded text sits on the FoldedText background, not its indentation or the empty rest of the row:
    -- each chunk combines FoldedText under its own highlight (a list of groups, later ones win). Rounded caps close
    -- both ends. The left cap takes the last indentation cell, so the text keeps its column; an unindented fold gets
    -- it in the gutter instead (plugins/statuscol.lua).
    -- Also records each fold's ellipsis cells (0-based, end exclusive) per buffer and start line, for the click map.
    local ellipsis_cols = {}
    vim.api.nvim_create_autocmd("BufWipeout", { callback = function(ev) ellipsis_cols[ev.buf] = nil end })
    local function fold_text(virt_text, lnum, end_lnum, _, _, ctx)
      local out = {}
      local width = 0
      for i, chunk in ipairs(fold_chunks(virt_text, lnum, end_lnum, ctx)) do
        if chunk[2] == "UfoFoldedEllipsis" then
          ellipsis_cols[ctx.bufnr] = ellipsis_cols[ctx.bufnr] or {}
          ellipsis_cols[ctx.bufnr][lnum] = { width, width + vim.fn.strdisplaywidth(chunk[1]) }
        end
        width = width + vim.fn.strdisplaywidth(chunk[1])
        local text, hl = chunk[1], chunk[2]
        if i == 1 then
          local indent = text:match("^%s*")
          if #indent > 0 then
            table.insert(out, { indent:sub(2) })
            table.insert(out, { LEFT_CAP, "FoldedTextCap" })
            text = text:sub(#indent + 1)
          end
        end
        local groups = { "FoldedText" }
        if type(hl) == "table" then
          vim.list_extend(groups, hl)
        elseif hl then
          table.insert(groups, hl)
        end
        table.insert(out, { text, groups })
      end
      table.insert(out, { RIGHT_CAP, "FoldedTextCap" })
      return out
    end

    ufo.setup({
      provider_selector = function()
        return folds_with_closing_line
      end,
      -- Files open with functions, structs, classes and includes folded; zR or zo opens them.
      close_fold_kinds_for_ft = {
        default = { "imports", "region" },
      },
      fold_virt_text_handler = fold_text,
      -- fold_text draws the closing line through ctx.get_fold_virt_text.
      enable_get_fold_virt_text = true,
    })

    -- A closed fold's text sits on catppuccin's Mantle (FoldedText, see fold_text); other themes get none. The row
    -- itself (Folded, UfoFoldedBg) keeps the normal background. Set after ufo.setup, which defines UfoFoldedBg, and
    -- registered after ufo's ColorScheme handler, so it also wins after a theme switch.
    local function set_folded_bg()
      local ok, palettes = pcall(require, "catppuccin.palettes")
      local bg = "NONE"
      if ok and vim.g.colors_name and vim.g.colors_name:match("^catppuccin") then
        bg = palettes.get_palette().mantle
      end
      vim.api.nvim_set_hl(0, "Folded", {})
      vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FoldedText", { bg = bg })
      vim.api.nvim_set_hl(0, "FoldedTextCap", { fg = bg })
    end
    set_folded_bg()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_folded_bg })

    -- A click on a closed fold's ellipsis opens it.
    vim.keymap.set("n", "<LeftMouse>", function()
      local mouse = vim.fn.getmousepos()
      if mouse.winid == 0 then
        return "<LeftMouse>"
      end
      local start = vim.api.nvim_win_call(mouse.winid, function() return vim.fn.foldclosed(mouse.line) end)
      local cols = ellipsis_cols[vim.api.nvim_win_get_buf(mouse.winid)]
      local hit = start ~= -1 and cols and cols[start]
      local col = mouse.wincol - 1 - vim.fn.getwininfo(mouse.winid)[1].textoff
      return (hit and hit[1] <= col and col < hit[2]) and "<LeftMouse>zo" or "<LeftMouse>"
    end, { expr = true })

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    -- h at or before the first non-blank closes the fold (like nvim-origami); l on a closed fold opens it natively.
    vim.keymap.set("n", "h", function()
      local before_text = vim.fn.col(".") <= vim.fn.indent(".") + 1
      return (before_text and vim.fn.foldlevel(".") > 0) and "zc" or "h"
    end, { expr = true })
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.fn.CocActionAsync("definitionHover") -- coc.nvim
        vim.lsp.buf.hover()
      end
    end)

    -- disable ufo and fold column for Neogit and etc
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "Neogit*" },
      callback = function()
        require("ufo").detach()
        vim.opt_local.foldenable = false
        vim.opt_local.foldcolumn = "0"
      end,
    })
  end,
}
