-- https://github.com/mcauley-penney/nvim/blob/main/lua/plugins/statuscol.lua
-- https://github.com/mcauley-penney/nvim/blob/main/lua/globals.lua
_G.tools = {}

-- files and directories -----------------------------
local branch_cache = setmetatable({}, { __mode = "k" })
local remote_cache = setmetatable({}, { __mode = "k" })

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
tools.get_path_root = function(path)
  if path == "" then return end

  local root = vim.b.path_root
  if root then return root end

  local root_items = {
    ".git",
  }

  root = vim.fs.root(path, root_items)
  if root == nil then return nil end
  if root then vim.b.path_root = root end
  return root
end

local function git_cmd(root, ...)
  local job = vim.system({ "git", "-C", root, ... }, { text = true }):wait()

  if job.code ~= 0 then return nil, job.stderr end
  return vim.trim(job.stdout)
end

-- get the name of the remote repository
tools.get_git_remote_name = function(root)
  if not root then return nil end
  if remote_cache[root] then return remote_cache[root] end

  local out = git_cmd(root, "config", "--get", "remote.origin.url")
  if not out then return nil end

  -- normalise to short repo name
  out = out:gsub(":", "/"):gsub("%.git$", ""):match("([^/]+/[^/]+)$")

  remote_cache[root] = out
  return out
end

function tools.get_git_branch(root)
  if not root then return nil end
  if branch_cache[root] then return branch_cache[root] end

  local out = git_cmd(root, "rev-parse", "--abbrev-ref", "HEAD")
  if out == "HEAD" then
    local commit = git_cmd(root, "rev-parse", "--short", "HEAD")
    commit = tools.hl_str("Comment", "(" .. commit .. ")")
    out = string.format("%s %s", out, commit)
  end

  branch_cache[root] = out

  return out
end


-- LSP -----------------------------
tools.diagnostics_available = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

  for _, cfg in pairs(clients) do
    if cfg:supports_method(diagnostics) then return true end
  end

  return false
end

-- highlighting -----------------------------
tools.hl_str = function(hl, str) return "%#" .. hl .. "#" .. str .. "%*" end

return {
  "luukvbaal/statuscol.nvim",
  config = function()
    require("statuscol").setup({
      relculright = true,
      thousands = ",",
      ft_ignore = {
        "aerial",
        "help",
        "neo-tree",
        "toggleterm",
      },
      segments = {
        {
          sign = {
            namespace = { "diagnostic" },
          },
          condition = {
            function()
              return tools.diagnostics_available() or " "
            end,
          },
        },
        {
          text = { " " },
        },
        {
          text = {
            "%=",
            function(args)
              local mode = vim.fn.mode()
              local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")

              -- case 1
              if normalized_mode ~= "v" and vim.v.virtnum == 0 then
                return require("statuscol.builtin").lnumfunc(args)
              end

              if vim.v.virtnum < 0 then
                return "-"
              end

              local line = require("statuscol.builtin").lnumfunc(args)

              if vim.v.virtnum > 0 then
                local num_wraps = vim.api.nvim_win_text_height(args.win, {
                  start_row = args.lnum - 1,
                  end_row = args.lnum - 1,
                })["all"] - 1

                if vim.v.virtnum == num_wraps then
                  line = "┗"
                  -- line = "╰"
                  -- line = "˙"
                  -- line = "🯨"
                else
                  line = "┣"
                  -- line = "┃"
                  -- line = "╏"
                  -- line = "█"
                end
              end

              -- Highlight cases
              if normalized_mode == "v" then
                local pos_list =
                  vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode, eol = true })
                local s_row, e_row = pos_list[1][1][2], pos_list[#pos_list][2][2]

                if vim.v.lnum >= s_row and vim.v.lnum <= e_row then
                  return tools.hl_str("CursorLineNr", line)
                end
              end

              return vim.fn.line(".") == vim.v.lnum and tools.hl_str("CursorLineNr", line)
                or tools.hl_str("LineNr", line)
            end,
            " ",
          },
          condition = {
            function()
              return vim.wo.number or vim.wo.relativenumber
            end,
          },
        },
        {
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 1,
          },
          condition = {
            function()
              local root = tools.get_path_root(vim.api.nvim_buf_get_name(0))
              return tools.get_git_remote_name(root) or " "
            end,
          },
        },
        {
          text = { " " },
        },
        {
          text = { require("statuscol.builtin").foldfunc },
          condition = {
            function()
              return vim.api.nvim_get_option_value("modifiable", { buf = 0 }) or " "
            end,
          },
        },
        {
          text = { " " },
        },
      },
    })
  end,
}
