return {
  "nvim-lualine/lualine.nvim",
  config = function()
    vim.opt.laststatus = 3
    vim.cmd.hi("StatusLine guibg = none")

    local custom_catppuccin = require("catppuccin.utils.lualine")("macchiato")
    custom_catppuccin.normal.c.bg = "none"

    require("lualine").setup({
      globalstatus = true,
      options = {
        theme = custom_catppuccin,
        disabled_filetypes = {
          winbar = {},
          statusline = {
            "neo-tree",
          },
        },
        component_separators = "",
        section_separators = {
          left = "",
          right = "",
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
            separator = {
              left = "",
              right = "",
            },
            -- separator = { left = "", right = "" },
            right_padding = 2,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          {
            "branch",
            separator = {
              left = "",
              right = "",
            },
            left_padding = 2,
          },
          -- { "branch", separator = { left = "", right = "" } },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          "%=",
          "filename",
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
