return {
	"b0o/incline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local helpers = require("incline.helpers")
		local devicons = require("nvim-web-devicons")
		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0 },
			},

			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				local colors = require("catppuccin.palettes").get_palette()
				if filename == "" then
					filename = "[No Name]"
				end
				local ft_icon, ft_color = devicons.get_icon_color(filename)
				local modified = vim.bo[props.buf].modified
				return {
					ft_icon and { " ", guifg = colors.crust },
					ft_icon
							and {
								"",
								ft_icon,
								" ",
								guifg = ft_color,
								-- guifg = colors.overlay0,
								guibg = colors.surface0,
							}
						or "",
					{
						filename,
						guifg = colors.overlay0,
						guibg = colors.surface0,
					},
					{ " ", guibg = colors.base, guifg = colors.crust },
				}
			end,
		})
	end,
	-- Optional: Lazy load Incline
	event = "VeryLazy",
}
