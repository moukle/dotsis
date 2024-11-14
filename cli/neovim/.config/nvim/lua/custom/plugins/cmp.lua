return {
	{
		-- "iguanacucumber/magazine.nvim",
		-- name = "nvim-cmp", -- Otherwise highlighting gets messed up
		"hrsh7th/nvim-cmp",
		enabled = true,
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			{ "onsails/lspkind-nvim", lazy = true },
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"f3fora/cmp-spell",

			-- { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
			-- { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
			-- { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
			-- { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
			-- "https://codeberg.org/FelipeLema/cmp-async-path",
			-- "chrisgrieser/cmp_yanky",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-l>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- <c-n> will move you to the right of each of the expansion locations.
					-- <c-p> is similar, except moving you backwards.
					["<C-n>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-p>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				window = {
					completion = {
						col_offset = -3,
						side_padding = 0,
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					},
					-- documentation = {
					-- 	winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					-- },
					documentation = {
						border = "single",
						winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind =
							require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},

				experimental = {
					ghost_text = true,
				},
				-- diagnostics = { virtual_text = { prefix = "icons" } },

				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "calc" },
					{ name = "emoji" },
					{ name = "spell" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
					-- { name = "cmp_yanky" },
				},
			})

			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline({
					["<C-l>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm()
							else
								fallback()
							end
						end,
					},
					["<C-j>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							else
								fallback()
							end
						end,
					},
					["<C-k>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							else
								fallback()
							end
						end,
					},
				}),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline({
					["<C-l>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm()
							else
								fallback()
							end
						end,
					},
					["<C-j>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							else
								fallback()
							end
						end,
					},
					["<C-k>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							else
								fallback()
							end
						end,
					},
				}),
				sources = {
					{ name = "cmdline" },
					{ name = "cmdline_history" },
					{ name = "path" },
				},
			})
		end,
	},
}
