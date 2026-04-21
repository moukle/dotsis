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

            -- vim.lsp.enable("julials")
            -- vim.lsp.config("jetls", {
            --     cmd = {
            --         "julia",
            --         "--startup-file=no",
            --         "--history-file=no",
            --         "--project=/home/mori/dev/JETLS.jl",
            --         "/home/mori/dev/JETLS.jl/runserver.jl",
            --     },
            --     filetypes = {"julia"},
            -- })
            -- vim.lsp.enable("jetls")
            -- julia -e 'using Pkg; Pkg.Apps.add(; url="https://github.com/aviatesk/JETLS.jl", rev="release")'
            vim.lsp.config("jetls", {
                cmd = {
                    "jetls",
                    "serve",
                },
                filetypes = { "julia" },
                root_markers = { "Project.toml" }
            })
            -- vim.lsp.enable("jetls")
            -- vim.lsp.config("jetls", {
            --     cmd = {
            --         "jetls",
            --         "--threads=auto",
            --         "--",
            --     },
            --     filetypes = {"julia"},
            -- })
            vim.lsp.enable("jetls")
        end,
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

        end,
        keys = {
            {
                "<leader>ee",
                function()
                    require("neo-tree.command").execute({ reveal = true, dir = LazyVim.root() })
                end,
                desc = "NeoTree reveal",
            }
        }
    },

    -- Add more treesitter parsers
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "lua",
                "markdown",
                -- "markdown_inline",
                "python",
                -- "query",
                -- "regex",
                -- "vim",
                -- "yaml",
                "julia",
                -- "zig",
            },
        },
    },

    -- Add any tools I want to have installed
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                -- "julia-lsp"
            },
        },
    },

    {
        'stevearc/conform.nvim',
        opts = {
            -- Prefer to format git hunks instead of the entire file
            format_on_save = function()
                local hunks = require("gitsigns").get_hunks()
                local format = require("conform").format
                for i = #hunks, 1, -1 do
                    local hunk = hunks[i]
                    if hunk ~= nil and hunk.type ~= "delete" then
                    local start = hunk.added.start
                    local last = start + hunk.added.count
                    -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
                    local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
                    local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
                    format({ range = range })
                    end
                end
            end,

            formatters_by_ft = {
                julia = {"runic"},
            },
            default_format_opts = {
                -- Increase the timeout in case Runic needs to precompile
                -- (e.g. after upgrading Julia and/or Runic).
                timeout_ms = 10000,
            },
        },
    }
}
