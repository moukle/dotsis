-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>gg", ":Neogit kind=floating<cr>", { desc = "Neo[G]it" })
-- vim.keymap.del("n", "<leader>gG")

-- Must unbind for blink compl
-- vim.keymap.del("n", "<C-k>")

-- Inspired by helix's L/H
vim.keymap.set("n", "gl", "$")
vim.keymap.set("n", "gh", "^")

-- Keep cursor centred while scrolling up and down
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Next and previous instance of the highlighted letter
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Join line while keeping the cursor in the same position
vim.keymap.set("n", "J", "mzJ`z")

-- Search and replace current position word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Neogen
vim.keymap.set(
  "n",
  "<Leader>ng",
  ":lua require('neogen').generate({ type = 'class' })<CR>",
  { desc = "Generate Docstring" }
)
