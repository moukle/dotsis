-- return {
--   "Bekaboo/dropbar.nvim",
-- }

return {
  "nvim-treesitter/nvim-treesitter-context",
  enabled = false,
  config = function()
    require("treesitter-context").setup({
      max_lines = 1,
      trim_scope = "inner",
      separator = "—",
    })

    vim.schedule(function()
      vim.cmd([[hi TreesitterContextBottom gui=None]])
      vim.cmd([[hi TreesitterContextLineNumber guibg=None]])
      vim.cmd([[hi TreesitterContext gui=None]])
    end)
  end,
}
