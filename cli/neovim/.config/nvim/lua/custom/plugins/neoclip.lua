return {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		{ "kkharji/sqlite.lua", module = "sqlite" },
		{ "nvim-telescope/telescope.nvim" },
	},
	config = function()
		require("neoclip").setup()

		vim.keymap.set("n", "<leader>sc", ":Telescope neoclip<CR>", { desc = "[S]earch Recent [C]opys" })
	end,
}
