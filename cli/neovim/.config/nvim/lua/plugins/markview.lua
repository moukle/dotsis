return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  -- event = VimEnter,
  event = InsertEnter,
  init = function()
    local presets = require("markview.presets")

    require("markview").setup({
      -- https://github.com/OXY2DEV/markview.nvim/issues/365
      experimental = { check_rtp_message = false },
      preview = {
        modes = { "n", "no", "c", "i" },
        hybrid_modes = { "i" },
        linewise_hybrid_mode = true,
      },

      -- headings = presets.headings.decorated,
      highlight_groups = {
        MarkviewCode = { bg = "none" },
        MarkviewInlineCode = { bg = "none" },
      },
      typst = {
        headings = {
          heading_1 = { style = "icon" },
        },
        math_blocks = {
          pad_amount = 0,
        },
        list_items = { enable = true },
        code_blocks = { enable = false },
        code_spans = { enable = false },

        subscripts = { enable = false },
        superscripts = { enable = false },
        -- math_spans = { enable = false },
      },
    })
  end,
  keys = {
    {
      "<leader>um",
      "<cmd>Markview<cr>",
      desc = "Toggle Markview",
    },
  },
}
