return {
	"romgrk/barbar.nvim",
	enabled = false,
	config = function()
		require("barbar").setup({
			auto_hide = true,
			tabpages = true,
			pinned = { button = "", filename = false },
			separator = { left = "▎", right = "" },
			separator_at_end = false,
			sidebar_filetypes = { ["neo-tree"] = { event = "BufWipeout" } },
			icons = {
				gitsigns = {
					added = { enabled = true, icon = "+" },
					changed = { enabled = true, icon = "~" },
					deleted = { enabled = true, icon = "-" },
				},
			},
		})

		vim.cmd.hi("BufferDefaultTabpageFill guibg=none")

		local map = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		-- Goto buffer in position...
		map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
		map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
		map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
		map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
		map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
		map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
		map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
		map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
		map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
		map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)

		-- Pin/unpin buffer
		map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)

		-- Magic buffer-picking mode
		map("n", "<leader>bb", "<Cmd>BufferPick<CR>", opts)
		-- Close commands
		--
		map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
		map("n", "<leader>bcc", "<Cmd>BufferCloseAllButCurrentOrPinned<CR>", opts)
		map("n", "<leader>bch", "<Cmd>BufferCloseBuffersLeft<CR>", opts)
		map("n", "<leader>bcl", "<Cmd>BufferCloseBuffersRight<CR>", opts)
	end,
}
