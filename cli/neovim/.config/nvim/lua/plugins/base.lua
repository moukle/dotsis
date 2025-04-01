-- Since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
return {
    -- disable bufferline
    { "akinsho/bufferline.nvim", enabled = false },

    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.diagnostics.virtual_text = false;
            -- opts.diagnostics.virtual_lines = {current_line = true};
            opts.inlay_hints.enabled = false;
        end
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000, -- Needs to be loaded in first
        config = function()
            require('tiny-inline-diagnostic').setup({
                hi = { background = "none"}
            })
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end
    },

    { -- Highlight to-do, notes, etc in comments
        "folke/todo-comments.nvim",
        opts = {
            signs = true,
            keywords = {
                CITE = { icon = "", color = "cite" },
            },
            colors = {
                cite = { "Comment" },
            },
        },
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = function (_, opts)
            opts.close_if_last_window = true;
            opts.filesystem.filtered_items = {
                show_hidden_count = false,
                hide_dotfiles = false,
                hide_by_name = {".git"}
            };
            opts.commands = {
                change_dir = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    vim.fn.chdir(path)
                end
            };
            opts.filesystem.window = {
                mappings = {
                    [","] = "change_dir"
                }};

        end
    },

    -- Add more treesitter parsers
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "vim",
                "yaml",
                "julia",
            },
        },
    },

    -- Add any tools I want to have installed
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "julia-lsp"
            },
        },
    },
}
