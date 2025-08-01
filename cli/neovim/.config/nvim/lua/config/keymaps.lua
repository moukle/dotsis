-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>gg", ":Neogit kind=floating<cr>", { desc = "Neo[G]it" })
-- vim.keymap.del("n", "<leader>gG")

-- Must unbind for blink compl
-- vim.keymap.del("n", "<C-k>")

-- insert empty line above/below
vim.keymap.set("n", "<CR>", [[m'o<esc>0d$`']])
vim.keymap.set("n", "<S-CR>", [[m'O<esc>0d$`']])

-- rm whitespaces
vim.keymap.set("n", "<leader>dd", [[<cmd>%s/\s\+$//e<cr>]], { silent = true })

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

vim.keymap.set("i", "<c-q>", function()
  local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local after = line:sub(col + 1, -1)
  local closer_col = #after + 1
  local closer_i = nil
  for i, closer in ipairs(closers) do
    local cur_index, _ = after:find(closer)
    if cur_index and (cur_index < closer_col) then
      closer_col = cur_index
      closer_i = i
    end
  end
  if closer_i then
    vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
  else
    vim.api.nvim_win_set_cursor(0, { row, col + 1 })
  end
end, { silent = true })

vim.keymap.set("n", "<leader>h", function()
  local current_pos = vim.inspect_pos()
  local matches = {}
  if #current_pos.treesitter > 0 then
    matches = { " Treesitter:" }
  end
  for _, hl in pairs(current_pos.treesitter) do
    if hl.hl_group_link then
      table.insert(matches, "| " .. hl.hl_group .. " -> " .. hl.hl_group_link)
    else
      table.insert(matches, "| " .. hl.hl_group)
    end
  end
  if #current_pos.semantic_tokens > 0 then
    table.insert(matches, "")
    table.insert(matches, "󰭤 Semantic Tokens:")
  end
  for _, hl in pairs(current_pos.semantic_tokens) do
    if hl.opts.hl_group_link then
      table.insert(matches, "| " .. hl.opts.hl_group .. " -> " .. hl.opts.hl_group_link .. " @ " .. hl.opts.priority)
    else
      table.insert(matches, "| " .. hl.opts.hl_group .. " @ " .. hl.opts.priority)
    end
  end
  if #current_pos.syntax > 0 then
    table.insert(matches, "")
    table.insert(matches, "󰉊 Syntax:")
  end
  for _, hl in pairs(current_pos.syntax) do
    if hl.hl_group_link then
      table.insert(matches, "| " .. hl.hl_group .. " -> " .. hl.hl_group_link)
    else
      table.insert(matches, "| " .. hl.hl_group)
    end
  end
  if #matches > 0 then
    vim.lsp.util.open_floating_preview(matches, "hl-capture", {})
  else
    vim.lsp.util.open_floating_preview({ "No highlight groups found!" }, "hl-capture", {})
  end
end, { silent = true })
