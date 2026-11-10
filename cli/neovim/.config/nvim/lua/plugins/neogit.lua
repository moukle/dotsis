return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    require("neogit").setup({
      disable_hint = true,
      kind = "replace",
      treesitter_diff_highlight = true,
      commit_view = { kind = "tab" },
      integrations = {
        telescope = true,
        diffview = true,
      },
    })

    -- File headers (`modified src/x.cpp`) as full-width bars in the `//>` section-heading colors
    -- (config/section_headings.lua), with a blank line above. Neogit marks them with a NeogitDiffHeader
    -- line highlight.
    local headings = require("config.section_headings")
    local ns = vim.api.nvim_create_namespace("neogit_file_pills")
    local spacer_ns = vim.api.nvim_create_namespace("neogit_file_spacers")
    local header_rows = {} -- buf -> { [row] = true, first = row, stats = row }

    -- ponytail: scans every highlight extmark of the buffer per redraw; cache by changedtick if large diffs lag.
    local function find_header_rows(buf)
      local rows = {}
      local marks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "highlight" })
      for _, m in ipairs(marks) do
        if m[4].hl_group == "NeogitDiffHeader" then
          rows[m[2]] = true
          rows.first = math.min(rows.first or m[2], m[2])
        end
      end
      -- `26 files changed, ...` starts the file list; with the blank line before it, it goes on Mantle.
      if rows.first then
        local lines = vim.api.nvim_buf_get_lines(buf, 0, rows.first, false)
        for i, line in ipairs(lines) do
          if line:match("^%d+ files? changed") then
            rows.stats = (lines[i - 1] == "") and i - 2 or i - 1
            break
          end
        end
      end
      return rows
    end

    -- Virtual lines can't be ephemeral, so spacers are real extmarks, redone when the header rows change.
    local function place_spacers(buf, rows)
      vim.api.nvim_buf_clear_namespace(buf, spacer_ns, 0, -1)
      for row in pairs(rows) do
        local above = type(row) == "number" and row > 0 and vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
        if above and above ~= "" then
          vim.api.nvim_buf_set_extmark(buf, spacer_ns, row, 0, { virt_lines = { { { "" } } }, virt_lines_above = true })
        end
      end
    end

    -- Rows Neogit paints with these line highlights (or their Highlight/Cursor variants) get rounded ends.
    local ROUNDED = { "NeogitHunkHeader", "NeogitCommitViewHeader" }
    local LEFT_CAP, RIGHT_CAP = "\u{E0B6}", "\u{E0B4}"

    --- Highlight group for a cap of Group's background over Under's background.
    local function cap_name(group, under) return group .. "Cap" .. under end

    -- Commit info and file list on catppuccin's Crust; caps for every rounded row over Normal and Crust.
    local function set_hl()
      local ok, palettes = pcall(require, "catppuccin.palettes")
      local themed = ok and (vim.g.colors_name or ""):match("^catppuccin")
      local palette = themed and palettes.get_palette() or {}
      vim.api.nvim_set_hl(0, "NeogitOverviewBg", { bg = palette.crust or "NONE" })
      vim.api.nvim_set_hl(0, "NeogitOverviewStatsBg", { bg = palette.mantle or "NONE" })
      for _, base in ipairs(ROUNDED) do
        for _, group in ipairs({ base, base .. "Highlight", base .. "Cursor" }) do
          for _, under in ipairs({ "Normal", "NeogitOverviewBg", "NeogitOverviewStatsBg" }) do
            local fg = vim.api.nvim_get_hl(0, { name = group, link = false }).bg
            local bg = vim.api.nvim_get_hl(0, { name = under, link = false }).bg
            vim.api.nvim_set_hl(0, cap_name(group, under), { fg = fg, bg = bg or "NONE" })
          end
        end
      end
    end
    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

    --- The rounded line highlight Neogit shows on Row (the highest-priority one), or nil.
    local function rounded_group(buf, row)
      local best, best_priority
      for _, m in ipairs(vim.api.nvim_buf_get_extmarks(buf, -1, { row, 0 }, { row, 0 }, { details = true })) do
        local group, priority = m[4].hl_group or "", m[4].priority or 0
        for _, base in ipairs(ROUNDED) do
          if group:sub(1, #base) == base and (not best_priority or priority > best_priority) then
            best, best_priority = group, priority
          end
        end
      end
      return best
    end

    vim.api.nvim_set_decoration_provider(ns, {
      on_win = function(_, _, buf)
        if not vim.bo[buf].filetype:match("^Neogit") then return false end
        local rows = find_header_rows(buf)
        if not vim.deep_equal(rows, header_rows[buf]) then
          header_rows[buf] = rows
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then place_spacers(buf, rows) end
          end)
        end
      end,
      on_line = function(_, win, buf, row)
        local rows = header_rows[buf] or {}
        local width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff - 1
        -- Commit info on Crust, then the file list on Mantle, both above the first file.
        local first = rows.first
        -- The blank line before the first file stays outside the panel.
        local panel_end = first and (vim.api.nvim_buf_get_lines(buf, first - 1, first, false)[1] == "" and first - 1 or first)
        local in_panel = first and row < panel_end and vim.bo[buf].filetype:match("^Neogit%a*View$")
        local panel_bg = in_panel and (rows.stats and row >= rows.stats and "NeogitOverviewStatsBg" or "NeogitOverviewBg")
        if in_panel then
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row + 1,
            hl_group = panel_bg,
            hl_eol = true,
            priority = 100,
            ephemeral = true,
          })
        end

        local group = rounded_group(buf, row)
        if group then
          local under = panel_bg or "Normal"
          local cap = cap_name(group, under)
          -- Inline virtual text can't be ephemeral, so the cap overlays the line redrawn one cell to the right.
          local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            virt_text = { { LEFT_CAP, cap }, { line, group } },
            virt_text_pos = "overlay",
            ephemeral = true,
          })
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            virt_text = { { RIGHT_CAP, cap }, { " ", under } },
            virt_text_win_col = width - 1,
            ephemeral = true,
          })
        end

        if not rows[row] then return end
        local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          virt_text = headings.bar(" " .. line .. " ", width),
          virt_text_pos = "overlay",
          ephemeral = true,
        })
      end,
    })
  end,
}
