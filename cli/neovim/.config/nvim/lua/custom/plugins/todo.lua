return { -- Highlight todo, notes, etc in comments
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>st",
			function()
				require("todo-comments.fzf").todo()
			end,
			desc = "Todo",
		},
		{
			"<leader>sT",
			function()
				require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
			end,
			desc = "Todo/Fix/Fixme",
		},
	},
	opts = {
		signs = true,
		keywords = {
			CITE = { icon = "", color = "cite" },
		},
		colors = {
			cite = { "DiagnosticInfo", "Comment" },
		},
	},
}
