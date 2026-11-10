-- Deleted lines get a thin red line instead of LazyVim's triangle, matching the ▎ bars of added and changed lines.
-- The line sits on the edge where the lines were: below for `delete`, above for `topdelete` (deleted at file start).
local DELETE_SIGNS = {
  delete = { text = "▁" },
  topdelete = { text = "▔" },
}

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = DELETE_SIGNS,
    signs_staged = DELETE_SIGNS,
  },
  keys = {
    {
      "<leader>gv",
      function()
        -- Unified diff inside the real buffer, so LSP and section headings keep working; hunks of all files go to quickfix.
        local gs = require("gitsigns")
        local on = gs.toggle_deleted()
        gs.toggle_linehl(on)
        gs.toggle_word_diff(on)
        if on then gs.setqflist("all") end
      end,
      desc = "Review changes inline",
    },
  },
}
