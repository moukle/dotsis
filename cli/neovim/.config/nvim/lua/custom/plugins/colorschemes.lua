return {
	{ "folke/tokyonight.nvim" },
	{ "neanias/everforest-nvim" },
	{ "navarasu/onedark.nvim" },
	{ "comfysage/evergarden" },
	{ "rose-pine/neovim", as = "rose-pine" },
	{ "nyoom-engineering/oxocarbon.nvim" },
	{
		"catppuccin/nvim",
		enabled = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			require("catppuccin").setup({
				background = {
					light = "latte",
					dark = "macchiato",
				},
				integrations = {
					telescope = { enabled = true, style = "nvchad" },
					barbar = true,
				},
				custom_highlights = function(C)
					return {
						-- BufferDefaultTabpageFill = { bg = C.none },

						FloatBorder = { fg = C.red },

						CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
						CmpItemKindKeyword = { fg = C.base, bg = C.red },
						CmpItemKindText = { fg = C.base, bg = C.teal },
						CmpItemKindMethod = { fg = C.base, bg = C.blue },
						CmpItemKindConstructor = { fg = C.base, bg = C.blue },
						CmpItemKindFunction = { fg = C.base, bg = C.blue },
						CmpItemKindFolder = { fg = C.base, bg = C.blue },
						CmpItemKindModule = { fg = C.base, bg = C.blue },
						CmpItemKindConstant = { fg = C.base, bg = C.peach },
						CmpItemKindField = { fg = C.base, bg = C.green },
						CmpItemKindProperty = { fg = C.base, bg = C.green },
						CmpItemKindEnum = { fg = C.base, bg = C.green },
						CmpItemKindUnit = { fg = C.base, bg = C.green },
						CmpItemKindClass = { fg = C.base, bg = C.yellow },
						CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
						CmpItemKindFile = { fg = C.base, bg = C.blue },
						CmpItemKindInterface = { fg = C.base, bg = C.yellow },
						CmpItemKindColor = { fg = C.base, bg = C.red },
						CmpItemKindReference = { fg = C.base, bg = C.red },
						CmpItemKindEnumMember = { fg = C.base, bg = C.red },
						CmpItemKindStruct = { fg = C.base, bg = C.blue },
						CmpItemKindValue = { fg = C.base, bg = C.peach },
						CmpItemKindEvent = { fg = C.base, bg = C.blue },
						CmpItemKindOperator = { fg = C.base, bg = C.blue },
						CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
						CmpItemKindCopilot = { fg = C.base, bg = C.teal },
					}
				end,
				color_overrides = {
					macchiato = {
						text = "#f5f5f5",
						subtext1 = "#ebebeb",
						subtext0 = "#e0e0e0",
						overlay2 = "#cccccc",
						overlay1 = "#b3b3b3",
						overlay0 = "#999999",
						surface2 = "#424242",
						surface1 = "#3d3d3d",
						surface0 = "#383838",
						base = "#202020",
						mantle = "#262626",
						crust = "#2b2b2b",
					},
					latte = {
						text = "#4f4f4f",
						subtext1 = "#5f5f5f",
						subtext0 = "#6f6f6f",
						overlay2 = "#7f7f7f",
						overlay1 = "#8f8f8f",
						overlay0 = "#a0a0a0",
						surface2 = "#b5b5b5",
						surface1 = "#c4c4c4",
						surface0 = "#d4d4d4",
						base = "#fafafa",
						mantle = "#ebebeb",
						crust = "#e3e3e3",
					},
				},
			})
			-- require("custom.colors-catppuccin")
			-- vim.cmd.colorscheme("catppuccin")

			-- You can configure highlights by doing something like:
			-- vim.cmd.hi 'Comment gui=none'
		end,
	},
}
