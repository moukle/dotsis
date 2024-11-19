return {
	"NeogitOrg/neogit",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		require("neogit").setup({
			disable_hint = true,
			integrations = {
				telescope = true,
				diffview = true,
			},
		})
		vim.keymap.set("n", "<leader>g", ":Neogit kind=floating<cr>", { desc = "Neo[G]it" })
	end,
}
