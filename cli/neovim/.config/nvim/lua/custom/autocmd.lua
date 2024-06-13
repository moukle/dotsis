-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[Theming]]
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
