return {
  "machakann/vim-swap",
  init = function()
    vim.keymap.set("n", "<left>", "<Plug>(swap-prev)", {}) -- g<
    vim.keymap.set("n", "<right>", "<Plug>(swap-next)", {}) -- g>
  end,
}
