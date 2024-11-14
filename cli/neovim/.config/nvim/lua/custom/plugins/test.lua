return {
	{
		"hrsh7th/nvim-insx",
		dependencies = { "andymass/vim-matchup" },
		init = function()
			require("insx.preset.standard").setup()
		end,
	},
	{
		"hrsh7th/nvim-pasta",
		init = function()
			vim.keymap.set({ "n", "x" }, "p", require("pasta.mapping").p)
			vim.keymap.set({ "n", "x" }, "P", require("pasta.mapping").P)

			-- This is the default. You can omit `setup` call if you don't want to change this.
			require("pasta").config.next_key = vim.keycode("<C-j>")
			require("pasta").config.prev_key = vim.keycode("<C-k>")
			require("pasta").config.indent_key = vim.keycode(",")
			require("pasta").config.indent_fix = true
		end,
	},
}
