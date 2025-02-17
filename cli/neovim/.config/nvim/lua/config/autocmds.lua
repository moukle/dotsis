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
