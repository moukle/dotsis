return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	config = function()
		require("persistence").setup({
			options = { "globals" },
			pre_save = function()
				vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
			end,
		})
	end,
	keys = {
		{
			"<leader>ql",
			[[<cmd>lua require("persistence").load({ last = true })<cr>]],
			{ desc = "Restore [l]ast session" },
		},
		{
			"<leader>qd",
			[[<cmd>lua require("persistence").load()<cr>]],
			{ desc = "Restore [d]ir session" },
		},
		{
			"<leader>qs",
			[[<cmd>lua require("persistence").stop()<cr>]],
			{ desc = "[S]op session persistence" },
		},
	},
}
