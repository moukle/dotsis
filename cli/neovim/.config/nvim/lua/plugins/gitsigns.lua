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
}
