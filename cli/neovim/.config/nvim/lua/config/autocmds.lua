-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- [[ Theming ]]
-- Colorscheme
-- change color of terminal to match vim theme
-- https://www.reddit.com/r/neovim/comments/1b66s2c/sync_terminal_background_with_neovim_background/
vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter", "VimResume" }, {
  callback = function()
    local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    io.stdout:write(("\027]11;#%06x\027\\"):format(bg))
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  callback = function()
    io.stdout:write("\027]111;;\027\\")
  end,
})

-- Kitty
-- change padding
vim.cmd([[
augroup kitty_mp
    autocmd!
    au VimLeave * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=10
    au VimSuspend * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=10

    au VimEnter * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=0
    au VimResume * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=0
augroup END
]])

-- Typst: Pin main file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(event)
    -- Ensure vim.g.typst_pinned is initialized as a table
    if vim.g.typst_pinned == nil then
      vim.g.typst_pinned = {}
    end

    -- Function to check if main.typ exists in the project root
    local function find_main_typ()
      local root = vim.fn.getcwd() -- Get the current working directory
      local main_file = root .. "/main.typ"
      return vim.fn.filereadable(main_file) == 1 and main_file or nil
    end

    local main_file = find_main_typ()
    if main_file and not vim.g.typst_pinned[main_file] then
      vim.g.typst_pinned[main_file] = true -- Mark as pinned
      vim.cmd.TypstPin(main_file)
    end
  end,
})
