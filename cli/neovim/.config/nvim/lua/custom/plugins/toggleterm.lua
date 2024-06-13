return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-`>]],
			shade_terminals = false,
			highlights = {
				normal = {
					link = "StatusLine",
				},
			},
		})
		vim.opt.hidden = true
	end,
}
