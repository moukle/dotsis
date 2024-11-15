vim.opt.laststatus = 3
local options = {

	base46 = {
		theme = "chocolate", -- default theme
		hl_add = {},
		hl_override = {},
		integrations = {},
		changed_themes = {},
		transparency = false,
		theme_toggle = { "onedark", "one_light" },
	},

	ui = {
		cmp = {
			icons_left = true, -- only for non-atom styles!
			lspkind_text = true,
			style = "default", -- default/flat_light/flat_dark/atom/atom_colored
			format_colors = {
				tailwind = false, -- will work for css lsp too
				icon = "󱓻",
			},
		},

		telescope = { style = "borderless" }, -- borderless / bordered

		statusline = {
			enabled = true,
			theme = "vscode", -- default/vscode/vscode_colored/minimal
			-- default/round/block/arrow separators work only for default statusline theme
			-- round and block will work for minimal theme only
			separator_style = "default",
			order = { "mode", "git", "%=", "lsp_msg", "%=", "diagnostics", "cwd" },
			modules = nil,
		},

		-- lazyload it when there are 1+ buffers
		tabufline = {
			enabled = false,
			lazyload = true,
			order = { "treeOffset", "buffers", "tabs" },
			modules = nil,
		},
	},

	nvdash = {
		load_on_startup = true,
		header = {
			"     █  █     ",
			"     ███ ██     ",
			"     █████     ",
			"     ██ ███     ",
			"     █  █     ",
			"",
		},

		buttons = {
			{ txt = "  New File", keys = "e", cmd = "buffer" },
			{ txt = "  Find File", keys = "<leader>ff", cmd = "Telescope find_files" },
			{ txt = "  Projects", keys = "<leader>fp", cmd = "Telescope projects" },
			{ txt = "  Recent Files", keys = "<leader>fr", cmd = "Telescope oldfiles" },
			{ txt = "󱥚  Themes", keys = "<leader>th", cmd = ":lua require('nvchad.themes').open()" },
			{ txt = "  Quit", keys = "q", cmd = "qall!" },

			{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

			{
				txt = function()
					local stats = require("lazy").stats()
					local ms = math.floor(stats.startuptime) .. " ms"
					return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
				end,
				hl = "NvDashFooter",
				no_gap = true,
			},

			{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
		},
	},

	term = {
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},

	lsp = { signature = true },

	cheatsheet = {
		theme = "grid", -- simple/grid
		excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
	},

	mason = { pkgs = {}, skip = {} },

	colorify = {
		enabled = true,
		mode = "virtual", -- fg, bg, virtual
		virt_text = "󱓻 ",
		highlight = { hex = true, lspvars = true },
	},
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
