return {
	"nvim-tree/nvim-tree.lua",

	keys = {
		{ "\\", ":NvimTreeToggle<CR>", { desc = "NeoTree reveal" } },
	},
	init = function()
		-- close if last window
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
			pattern = "NvimTree_*",
			callback = function()
				local layout = vim.api.nvim_call_function("winlayout", {})
				if
					layout[1] == "leaf"
					and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
					and layout[3] == nil
				then
					vim.cmd("confirm quit")
				end
			end,
		})
	end,
	opts = {
		filters = { dotfiles = false, exclude = { ".git/" } },
		disable_netrw = true,
		hijack_cursor = true,
		sync_root_with_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		view = {
			-- width = 30,
			preserve_window_proportions = true,
		},
		git = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = false,
		},
		renderer = {
			root_folder_label = false,
			indent_markers = { enable = false },
			icons = {
				git_placement = "after",
				show = {
					folder_arrow = false,
					git = true,
				},
				glyphs = {
					folder = {
						default = "",
						empty = "",
						empty_open = "",
						open = "",
					},
				},
			},
		},
	},
}
