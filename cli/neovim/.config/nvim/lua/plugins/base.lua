-- Since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
return {
    -- disable bufferline
    { "akinsho/bufferline.nvim", enabled = false },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = function(_, opts)
            opts.scope.enabled = false;
        end
    },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.diagnostics.virtual_text = false;
            -- opts.diagnostics.virtual_lines = {current_line = true};
            opts.inlay_hints.enabled = false;

            opts.diagnostics.signs = {
                text = {
                [vim.diagnostic.severity.ERROR] = "●",
                [vim.diagnostic.severity.WARN] = "●",
                [vim.diagnostic.severity.HINT] = "●",
                [vim.diagnostic.severity.INFO] = "●",
                }
            };
        end,
        -- config = function()
            -- require('lspconfig')['zls'].setup {
            --     settings = {
            --         zls = {
            --             path = "/home/mori/.local/bin/zig-x86_64-linux-0.15.0-dev.847+850655f06",
            --             -- path = "$HOME/.local/bin/zig-x86_64-linux-0.15.0-dev.847+850655f06"
            --             Zls = {
            --                 path = "/home/mori/.local/bin/zls-linux-x86_64-0.15.0-dev.202+56e25ab5",
            --                 enableAutofix = true,
            --                 enable_snippets = true,
            --                 enable_ast_check_diagnostics = true,
            --                 enable_autofix = true,
            --                 enable_import_embedfile_argument_completions = true,
            --                 warn_style = true,
            --                 enable_semantic_tokens = true,
            --                 enable_inlay_hints = true,
            --                 inlay_hints_hide_redundant_param_names = true,
            --                 inlay_hints_hide_redundant_param_names_last_token = true,
            --                 operator_completions = true,
            --                 include_at_in_builtins = true,
            --                 max_detail_length = 1048576,
            --             },
            --         }
            --     }
            -- }
        -- end
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
                "zig",
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
