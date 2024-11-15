return {
	enabled = false,
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.opt.laststatus = 3

		-- local custom_catppuccin = require("lualine.themes.catppuccin")
		-- custom_catppuccin.normal.c.bg = "NONE"
		-- custom_catppuccin.inactive.c.bg = "NONE"

		require("lualine").setup({
			globalstatus = true,
			options = {
				disabled_filetypes = { winbar = {}, statusline = { "neo-tree" } },
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end,
						separator = { left = "", right = "" },
						right_padding = 2,
					},
				},
				lualine_b = { "branch" },
				-- lualine_c = { "%=", "filename" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { "filetype", "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					"%=",
					"filename",
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
