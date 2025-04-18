return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    require("neogit").setup({
      disable_hint = true,
      integrations = {
        telescope = true,
        diffview = true,
      },
    })
    vim.keymap.set("n", "<leader>gg", ":Neogit kind=floating<cr>", { desc = "Neo[G]it" })
  end,
}
