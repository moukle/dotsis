return {
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
		enabled = false, -- let kitty do it: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.cursor_trail
	},
	{
		{
			"karb94/neoscroll.nvim",
			config = function()
				require("neoscroll").setup({})
			end,
		},
	},
}
