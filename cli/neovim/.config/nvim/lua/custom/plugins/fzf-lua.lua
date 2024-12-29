return {
	"ibhagwan/fzf-lua",
	lazy = false,
	-- optional for icon support
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "junegunn/fzf", build = "./install --bin" },
		{
			"ahmedkhalf/project.nvim",
			config = function()
				require("project_nvim").setup({
					show_hidden = true,
					detection_methods = {
						-- "lsp",
						"pattern",
					},
					patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
				})
			end,
		},
	},
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
		{ "<leader>f.", "<cmd>FzfLua oldfiles<cr>", desc = "Find recent files" },
		{ "<leader> ", "<cmd>FzfLua buffers<cr>", desc = "Find Files (Root Dir)" },
		{ "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
		{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
		{
			"<leader>fp",
			function()
				local fzf_lua = require("fzf-lua")
				local dirs = require("project_nvim").get_recent_projects()

				fzf_lua.fzf_exec(dirs, {
					actions = {
						["default"] = function(selected)
							local project_dir = selected[1]
							if project_dir then
								vim.cmd("cd " .. vim.fn.fnameescape(project_dir))
								fzf_lua.files({ cwd = project_dir })
							else
								vim.notify("No project selected", vim.log.levels.WARN)
							end
						end,
					},
				})
			end,
		},
		desc = "Projects",
	},

	config = function()
		-- calling `setup` is optional for customization
		require("fzf-lua").setup({
			prompt = " ",
			files = {
				prompt = " ",
				cwd_prompt = false,
			},

			defaults = {
				keymap = {
					fzf = {
						["ctrl-u"] = "half-page-up",
						["ctrl-d"] = "half-page-down",
						["ctrl-x"] = "jump",
						["ctrl-q"] = "select-all+accept",
						["ctrl-f"] = "preview-page-down",
						["ctrl-b"] = "preview-page-up",
					},
					builtin = {
						["<c-f>"] = "preview-page-down",
						["<c-b>"] = "preview-page-up",
					},
				},
			},
		})
	end,
}
