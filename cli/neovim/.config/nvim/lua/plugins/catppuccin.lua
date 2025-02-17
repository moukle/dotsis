return {
  "catppuccin/nvim",
  init = function()
    require("catppuccin").setup({
      background = {
        light = "latte",
        dark = "macchiato",
      },
      -- transparent_background = true,
      integrations = {
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        barbar = true,
        blink_cmp = true,
        diffview = true,
        fidget = true,
        snacks = true,
        lsp_trouble = true,
        which_key = true,
        fzf = true,
      },
      custom_highlights = function(C)
        return {
          NeoTreeNormal = { bg = C.none },
          NeoTreeNormalNC = { bg = C.none },
          NeoTreeWinSeparator = { bg = C.none, fg = C.crust },
          SnacksPicker = { bg = C.base },
          FloatBorder = { fg = C.crust, bg = C.base },
          FloatTitle = { style = { "bold" }, fg = C.text, bg = C.base },
          -- NormalFloat = { bg = C.crust },
          Folded = { bg = C.crust, fg = C.surface2 },

          WhichKey = { bg = C.base },
          WhichKeyNormal = { bg = C.base },

          SnacksPickerBorder = { bg = C.base, fg = C.crust },
          SnacksPickerBoxTitle = { bg = C.base, fg = C.text },
          SnacksDashboardHeader = { fg = C.rosewater },
          SnacksDashboardIcon = { fg = C.surface2 },
          SnacksDashboardDesc = { fg = C.subtext1 },
          SnacksDashboardFile = { fg = C.subtext1, style = { "bold" } },
          SnacksDashboardTitle = { fg = C.text, style = { "bold" } },
          SnacksDashboardKey = { fg = C.rosewater, style = { "bold" } },
          SnacksDashboardFooter = { fg = C.subtext0 },
          SnacksDashboardSpecial = { fg = C.rosewater, style = { "bold" } },
        }
      end,
      color_overrides = {
        macchiato = {
          text = "#f5f5f5",
          subtext1 = "#ebebeb",
          subtext0 = "#e0e0e0",
          overlay2 = "#cccccc",
          overlay1 = "#b3b3b3",
          overlay0 = "#999999",
          surface2 = "#424242",
          surface1 = "#3d3d3d",
          surface0 = "#202020",
          base = "#000000",
          mantle = "#000000",
          crust = "#101010",
        },
        latte = {
          text = "#4f4f4f",
          subtext1 = "#5f5f5f",
          subtext0 = "#6f6f6f",
          overlay2 = "#7f7f7f",
          overlay1 = "#8f8f8f",
          overlay0 = "#a0a0a0",
          surface2 = "#b5b5b5",
          surface1 = "#c4c4c4",
          surface0 = "#d4d4d4",
          base = "#fafafa",
          mantle = "#ebebeb",
          crust = "#e3e3e3",
        },
      },
    })
  end,
}
