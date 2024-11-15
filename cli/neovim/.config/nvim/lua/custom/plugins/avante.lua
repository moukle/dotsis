return {
	"yetone/avante.nvim",
	enabled = false,
	event = "VeryLazy",
	version = false, -- set this if you want to always pull the latest change
	build = "make", -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
	opts = {
		-- add any opts here
		provider = "copilot",
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		--- The below is optional, make sure to setup it properly if you have lazy=true
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
