return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    require("mini.comment").setup({
      mappings = {
        comment = "gc",
        comment_line = "<c-c>",
        comment_visual = "<c-c>",
        textobject = "c-c>",
      },
    })

    -- require("mini.notify").setup()

    require("mini.align").setup({ mappings = { start = "ga", start_with_preview = "gA" } })

    require("mini.splitjoin").setup({ mappings = { toggle = "gS", split = "", join = "" } })

    require("mini.basics").setup({
      -- Extra UI features ('winblend', 'cmdheight=0', ...)
      options = { extra_ui = true },

      -- Window navigation with <C-hjkl>, resize with <C-arrow>
      mappings = { windows = true },
    })

    -- require("mini.animate").setup()
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
