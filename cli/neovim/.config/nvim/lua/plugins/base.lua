-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },

    -- disable bufferline
    { "akinsho/bufferline.nvim", enabled = false },

    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.diagnostics.virtual_text = false;
            opts.diagnostics.virtual_lines = {current_line = true};
            opts.inlay_hints.enabled = false;
        end
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

    -- add more treesitter parsers
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

    -- add any tools you want to have installed below
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
