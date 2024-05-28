vim.cmd([[
  















































]])
require("catppuccin").setup({
    ["flavour"] = "frappe",
    ["integrations"] = {
        ["cmp"] = true,
        ["hop"] = true,
        ["indent_blankline"] = { ["enabled"] = true },
        ["neogit"] = true,
        ["notify"] = true,
        ["nvimtree"] = true,
        ["telescope"] = { ["enabled"] = true },
        ["which_key"] = true,
    },
})

-- Set up globals {{{
do
    local nixvim_globals = { ["mapleader"] = " ", ["maplocalleader"] = " " }

    for k, v in pairs(nixvim_globals) do
        vim.g[k] = v
    end
end
-- }}}

-- Set up options {{{
do
    local nixvim_options = {
        ["clipboard"] = "unnamedplus",
        ["completeopt"] = { "menu", "menuone", "noselect" },
        ["cursorline"] = true,
        ["expandtab"] = true,
        ["foldlevel"] = 99,
        ["ignorecase"] = true,
        ["incsearch"] = true,
        ["list"] = true,
        ["listchars"] = "tab:⇥ ,trail:░",
        ["number"] = true,
        ["relativenumber"] = true,
        ["shiftwidth"] = 4,
        ["showmatch"] = true,
        ["smartcase"] = true,
        ["smartindent"] = true,
        ["softtabstop"] = 4,
        ["splitbelow"] = true,
        ["splitright"] = true,
        ["swapfile"] = false,
        ["tabstop"] = 4,
        ["termguicolors"] = true,
        ["undofile"] = true,
        ["updatetime"] = 100,
    }

    for k, v in pairs(nixvim_options) do
        vim.opt[k] = v
    end
end
-- }}}

vim.loader.disable()

vim.cmd([[
  let $BAT_THEME = 'catppuccin'

colorscheme catppuccin

]])
wilder = require("wilder")
wilder.setup({ ["modes"] = { ":", "/", "?" } })

local __wilderOptions = {}
for key, value in pairs(__wilderOptions) do
    wilder.set_option(key, value)
end

require("which-key").setup({ ["icons"] = { ["breadcrumb"] = "»", ["group"] = "+", ["separator"] = "" } })
require("which-key").register({
    ["<leader>f"] = "Telescope",
    ["<leader>fb"] = "Find Buffer",
    ["<leader>ff"] = "Find File",
    ["<leader>fg"] = "Find String",
    ["<leader>fp"] = "Find Project",
    ["<leader>fr"] = "Recently Opened",
    ["<leader>l"] = "LSP",
    ["<leader>lD"] = "References",
    ["<leader>la"] = "Code Action",
    ["<leader>ld"] = "Definition",
    ["<leader>lf"] = "Format",
    ["<leader>lh"] = "Previous Diagnostic",
    ["<leader>li"] = "Implementation",
    ["<leader>lk"] = "Hover",
    ["<leader>ll"] = "Next Diagnostic",
    ["<leader>lr"] = "Rename",
})

require("todo-comments").setup({})

require("project_nvim").setup({})

require("ufo").setup({ ["open_fold_hl_timeout"] = 0 })

require("colorizer").setup({
    filetypes = nil,
    user_default_options = { ["RGB"] = true, ["RRGGBB"] = true, ["names"] = false },
    buftypes = nil,
})

require("nvim-autopairs").setup({})

vim.notify = require("notify")
require("notify").setup({})

require("ibl").setup({ ["scope"] = { ["enabled"] = false } })

require("Comment").setup({})

require("auto-session").setup({
    ["auto_restore_enabled"] = true,
    ["auto_save_enabled"] = true,
    ["auto_session_enable_last_session"] = true,
    ["auto_session_enabled"] = true,
})

require("telescope").setup({
    ["mappings"] = {
        ["i"] = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
        },
    },
})

local __telescopeExtensions = { "fzf", "projects" }
for i, extension in ipairs(__telescopeExtensions) do
    require("telescope").load_extension(extension)
end

require("lualine").setup({
    ["options"] = {
        ["component_separators"] = { ["left"] = " ", ["right"] = " " },
        ["globalstatus"] = true,
        ["icons_enabled"] = true,
        ["section_separators"] = { ["left"] = "", ["right"] = "" },
        ["theme"] = "catppuccin",
    },
    ["sections"] = {
        ["lualine_a"] = { "mode" },
        ["lualine_b"] = { "" },
        ["lualine_c"] = { "branch" },
        ["lualine_x"] = { "filename" },
        ["lualine_y"] = { "" },
        ["lualine_z"] = { "progress" },
    },
})
require("trouble").setup({})

require("conform").setup({ ["formatters_by_ft"] = { ["nix"] = { "alejandra" } } })

-- LSP {{{
do
    local __lspServers = {
        { ["name"] = "tsserver" },
        { ["name"] = "pyright" },
        { ["name"] = "nil_ls" },
        { ["name"] = "julials" },
        {
            ["extraOptions"] = {
                ["cmd"] = {
                    "/nix/store/c1k19pbnplsnzh9ljcgkyj1p08wb0rdc-vscode-langservers-extracted-4.10.0/bin/vscode-html-language-server",
                    "--stdio",
                },
            },
            ["name"] = "html",
        },
        {
            ["extraOptions"] = {
                ["cmd"] = {
                    "/nix/store/c1k19pbnplsnzh9ljcgkyj1p08wb0rdc-vscode-langservers-extracted-4.10.0/bin/vscode-css-language-server",
                    "--stdio",
                },
            },
            ["name"] = "cssls",
        },
    }
    local __lspOnAttach = function(client, bufnr) end
    local __lspCapabilities = function()
        capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        return capabilities
    end

    local __setup = {
        on_attach = __lspOnAttach,
        capabilities = __lspCapabilities(),
    }

    for i, server in ipairs(__lspServers) do
        if type(server) == "string" then
            require("lspconfig")[server].setup(__setup)
        else
            local options = server.extraOptions

            if options == nil then
                options = __setup
            else
                options = vim.tbl_extend("keep", options, __setup)
            end

            require("lspconfig")[server.name].setup(options)
        end
    end
end
-- }}}

require("nvim-treesitter.configs").setup({ ["highlight"] = { ["enable"] = true } })

require("neogit").setup({
    ["disable_hint"] = true,
    ["sections"] = {
        ["rebase"] = { ["folded"] = true, ["hidden"] = false },
        ["recent"] = { ["folded"] = true, ["hidden"] = false },
        ["sequencer"] = { ["folded"] = false, ["hidden"] = false },
        ["staged"] = { ["folded"] = false, ["hidden"] = false },
        ["stashes"] = { ["folded"] = true, ["hidden"] = false },
        ["unmerged_pushRemote"] = { ["folded"] = false, ["hidden"] = false },
        ["unmerged_upstream"] = { ["folded"] = false, ["hidden"] = false },
        ["unpulled_pushRemote"] = { ["folded"] = true, ["hidden"] = false },
        ["unpulled_upstream"] = { ["folded"] = true, ["hidden"] = false },
        ["unstaged"] = { ["folded"] = false, ["hidden"] = false },
        ["untracked"] = { ["folded"] = false, ["hidden"] = false },
    },
})

require("gitsigns").setup({})

require("nvim-tree").setup({
    ["git"] = { ["enable"] = false },
    ["hijack_directories"] = { ["auto_open"] = false },
    ["renderer"] = {
        ["icons"] = { ["glyphs"] = { ["folder"] = { ["arrow_closed"] = "", ["arrow_open"] = "" } } },
        ["root_folder_label"] = false,
    },
    ["update_focused_file"] = { ["enable"] = true, ["update_root"] = true },
})

local cmp = require("cmp")
cmp.setup({
    ["formatting"] = {
        ["format"] = function(_, vim_item)
            symbol_map = {
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
            }

            vim_item.kind = symbol_map[vim_item.kind] .. "  " .. vim_item.kind
            -- vim_item.menu = menu_abbr[entry.source.name]
            vim_item.abbr = vim_item.abbr:gsub("%(.*%)", "(…)")
            return vim_item
        end,
    },
    ["mapping"] = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
    },
    ["sources"] = {
        { ["name"] = "nvim_lsp_signature_help" },
        { ["name"] = "path" },
        { ["name"] = "nvim_lsp" },
        { ["keywordLength"] = 3, ["name"] = "buffer", ["option"] = { ["get_bufnrs"] = vim.api.nvim_list_bufs } },
    },
})

require("barbar").setup({ ["icons"] = { ["button"] = false } })

-- Set up keybinds {{{
do
    local __nixvim_binds = {
        { ["action"] = "<NOP>", ["key"] = "<Space>", ["mode"] = "n", ["options"] = { ["silent"] = true } },
        { ["action"] = ":noh<CR>", ["key"] = "<esc>", ["mode"] = "n", ["options"] = { ["silent"] = true } },
        {
            ["action"] = "<cmd>Telescope buffers<CR>",
            ["key"] = "<leader>fb",
            ["mode"] = "n",
            ["options"] = { ["silent"] = true },
        },
        {
            ["action"] = "<cmd>Telescope find_files<CR>",
            ["key"] = "<leader>ff",
            ["mode"] = "n",
            ["options"] = { ["silent"] = true },
        },
        {
            ["action"] = "<cmd>Telescope live_grep<CR>",
            ["key"] = "<leader>fg",
            ["mode"] = "n",
            ["options"] = { ["silent"] = true },
        },
        {
            ["action"] = "<cmd>Telescope projects<CR>",
            ["key"] = "<leader>fp",
            ["mode"] = "n",
            ["options"] = { ["silent"] = true },
        },
        {
            ["action"] = "<cmd>Telescope oldfiles<CR>",
            ["key"] = "<leader>fr",
            ["mode"] = "n",
            ["options"] = { ["silent"] = true },
        },
        {
            ["action"] = "<cmd>TodoTelescope<CR>",
            ["key"] = "<leader>ft",
            ["mode"] = "n",
            ["options"] = { ["silent"] = true },
        },
        { ["action"] = "<cmd>Neogit<CR>", ["key"] = "<leader>g", ["mode"] = "n", ["options"] = { ["silent"] = true } },
        {
            ["action"] = "<cmd>NvimTreeToggle<CR>",
            ["key"] = "<leader>t",
            ["mode"] = "n",
            ["options"] = { ["silent"] = true },
        },
        { ["action"] = "^", ["key"] = "H", ["mode"] = "n", ["options"] = { ["silent"] = true } },
        { ["action"] = "$", ["key"] = "L", ["mode"] = "n", ["options"] = { ["silent"] = true } },
        { ["action"] = "y$", ["key"] = "Y", ["mode"] = "n", ["options"] = { ["silent"] = true } },
    }
    for i, map in ipairs(__nixvim_binds) do
        vim.keymap.set(map.mode, map.key, map.action, map.options)
    end
end
-- }}}

vim.filetype.add({ ["extension"] = { ["v"] = "vlang" } })

-- require'lsp_signature'.setup({
--   floating_window = true,
--   hint_inline = 'inline'
--   handler_opts = { border = "single" },
--   max_width = 80,
-- })
-- require'lsp-inlayhints'.setup()

require("textcase").setup({})
require("telescope").load_extension("textcase")
vim.keymap.set("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
vim.keymap.set("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })

vim.keymap.set("n", "ga", [[<Plug>(EasyAlign)]], {})
vim.keymap.set("x", "ga", [[<Plug>(EasyAlign)]], {})

require("highlight-undo").setup({})

require("spider").setup({
    skipInsignificantPunctuation = false,
})
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

-- Set up autogroups {{
do
    local __nixvim_autogroups = { ["nixvim_binds_LspAttach"] = { ["clear"] = true } }

    for group_name, options in pairs(__nixvim_autogroups) do
        vim.api.nvim_create_augroup(group_name, options)
    end
end
-- }}
-- Set up autocommands {{
do
    local __nixvim_autocommands = {
        {
            ["command"] = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
            ["event"] = "BufEnter",
            ["nested"] = true,
        },
        {
            ["callback"] = function()
                do
                    local __nixvim_binds = {
                        {
                            ["action"] = vim.diagnostic.goto_prev,
                            ["key"] = "<leader>lh",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.diagnostic.goto_next,
                            ["key"] = "<leader>ll",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.lsp.buf.references,
                            ["key"] = "<leader>lD",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.lsp.buf.code_action,
                            ["key"] = "<leader>la",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.lsp.buf.definition,
                            ["key"] = "<leader>ld",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.lsp.buf.format,
                            ["key"] = "<leader>lf",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.lsp.buf.implementation,
                            ["key"] = "<leader>li",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.lsp.buf.hover,
                            ["key"] = "<leader>lk",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                        {
                            ["action"] = vim.lsp.buf.rename,
                            ["key"] = "<leader>lr",
                            ["mode"] = "n",
                            ["options"] = { ["silent"] = true },
                        },
                    }
                    for i, map in ipairs(__nixvim_binds) do
                        vim.keymap.set(map.mode, map.key, map.action, map.options)
                    end
                end
            end,
            ["desc"] = "Load keymaps for LspAttach",
            ["event"] = "LspAttach",
            ["group"] = "nixvim_binds_LspAttach",
        },
        { ["command"] = "norm zz", ["event"] = "InsertEnter" },
        { ["command"] = "%s/\\s\\+$//e", ["event"] = "BufWrite" },
        { ["command"] = "wincmd L", ["event"] = "FileType", ["pattern"] = "help" },
        {
            ["command"] = "setlocal spell spelllang=en,fr",
            ["event"] = "FileType",
            ["pattern"] = { "tex", "latex", "markdown" },
        },
        { ["command"] = "silent !kitty @ set-spacing padding=default", ["event"] = "VimLeave" },
        { ["command"] = "silent !kitty @ set-spacing padding=0", ["event"] = "VimEnter" },
    }

    for _, autocmd in ipairs(__nixvim_autocommands) do
        vim.api.nvim_create_autocmd(autocmd.event, {
            group = autocmd.group,
            pattern = autocmd.pattern,
            buffer = autocmd.buffer,
            desc = autocmd.desc,
            callback = autocmd.callback,
            command = autocmd.command,
            once = autocmd.once,
            nested = autocmd.nested,
        })
    end
end
-- }}
