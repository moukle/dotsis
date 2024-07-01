return { -- Highlight todo, notes, etc in comments
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = true,
		keywords = {
			CITE = { icon = "", color = "cite" },
		},
		colors = {
			cite = { "Comment" },
		},
	},
}
