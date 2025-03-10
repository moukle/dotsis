return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      -- colorscheme = "everforest",
    },
  },
  {
    "catppuccin/nvim",
    init = function()
      require("catppuccin").setup({
        background = {
          light = "latte",
          dark = "macchiato",
        },
        dim_inactive = {
          -- enabled = true,
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
            Function = { fg = C.green },
            -- ["@punctuation.bracket"] = { C.subtext1 },

            FloatBorder = { fg = C.crust, bg = C.base },
            FloatTitle = { style = { "bold" }, fg = C.text, bg = C.base },
            -- NormalFloat = { bg = C.crust },
            Folded = { bg = C.crust, fg = C.surface2 },

            NeoTreeNormal = { bg = C.none },
            NeoTreeNormalNC = { bg = C.none },
            NeoTreeWinSeparator = { bg = C.none, fg = C.crust },
            SnacksPicker = { bg = C.base },
            MarkviewInlineCode = { bg = C.none },

            WhichKey = { bg = C.base },
            WhichKeyNormal = { bg = C.base },

            SnacksPickerBorder = { bg = C.base, fg = C.crust },
            SnacksPickerBoxTitle = { bg = C.base, fg = C.text },
            SnacksDashboardHeader = { fg = C.peach },
            SnacksDashboardIcon = { fg = C.yellow },
            SnacksDashboardDesc = { fg = C.text },
            SnacksDashboardFile = { fg = C.subtext1, style = { "bold" } },
            SnacksDashboardTitle = { fg = C.text, style = { "bold" } },
            SnacksDashboardKey = { fg = C.peach, style = { "bold" } },
            SnacksDashboardFooter = { fg = C.subtext0 },
            SnacksDashboardSpecial = { fg = C.peach, style = { "bold" } },
          }
        end,
        color_overrides = {
          -- ayu
          -- macchiato = {
          --   rosewater = "#F5B8AB",
          --   flamingo = "#F29D9D",
          --   pink = "#AD6FF7",
          --   mauve = "#FF8F40",
          --   red = "#E66767",
          --   maroon = "#EB788B",
          --   peach = "#FAB770",
          --   yellow = "#FACA64",
          --   green = "#70CF67",
          --   teal = "#4CD4BD",
          --   sky = "#61BDFF",
          --   sapphire = "#4BA8FA",
          --   blue = "#00BFFF",
          --   lavender = "#00BBCC",
          --   text = "#C1C9E6",
          --   subtext1 = "#A3AAC2",
          --   subtext0 = "#8E94AB",
          --   overlay2 = "#7D8296",
          --   overlay1 = "#676B80",
          --   overlay0 = "#464957",
          --   surface2 = "#3A3D4A",
          --   surface1 = "#2F313D",
          --   surface0 = "#1D1E29",
          --   base = "#0b0b12",
          --   mantle = "#11111a",
          --   crust = "#191926",
          -- },

          -- everforest
          macchiato = {
            green = "#A7C080",
            yellow = "#DBBC7F",
            peach = "#E69875",
            mauve = "#E69875",
            red = "#E67E80",
            maroon = "#E67E80",
            teal = "#83C092",
            sky = "#83C092",
            sapphire = "#83C092",
            blue = "#7FBBB3",
            lavender = "#7FBBB3",
            pink = "#D699B6",
            rosewater = "#D699B6",
            flamingo = "#D699B6",

            text = "#D3C6AA",
            subtext1 = "#9DA9A0",
            subtext0 = "#859289",
            overlay2 = "#7A8478",
            overlay1 = "#56635f",
            overlay0 = "#62716c",
            surface2 = "#4F585E",
            surface1 = "#475258",
            surface0 = "#3D484D",
            base = "#2D353B",
            mantle = "#232A2E",
            crust = "#343F44",
          },

          -- oled
          -- macchiato = {
          --   text = "#f5f5f5",
          --   subtext1 = "#ebebeb",
          --   subtext0 = "#e0e0e0",
          --   overlay2 = "#cccccc",
          --   overlay1 = "#b3b3b3",
          --   overlay0 = "#999999",
          --   surface2 = "#424242",
          --   surface1 = "#3d3d3d",
          --   surface0 = "#202020",
          --   base = "#000000",
          --   mantle = "#000000",
          --   crust = "#101010",
          -- },

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
            base = "#fcfcfc",
            mantle = "#ebebeb",
            crust = "#e3e3e3",
          },
        },
      })
    end,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      -- vim.cmd.colorscheme("everforest")
    end,
  },
}
