return {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        signature = { enabled = true },

        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },

        completion = {
            accept = {
                -- experimental auto-brackets support
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                draw = {
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 300,
            },
            ghost_text = {
                enabled = true,
            },
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        keymap = {
            preset = "default",
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-l>"] = { "accept", "fallback" },

            ["<Tab>"] = { "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },

            ["<C-e>"] = { "hide" },
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        },
    },
    opts_extend = { "sources.default" },
}
