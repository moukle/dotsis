-- return {
--     "Vigemus/iron.nvim",
--     opts = {
--         keymaps = {
--             send_motion = "<space>sc",
--             visual_send = "<space>sc",
--             send_file = "<space>sf",
--             send_line = "<space>sl",
--             send_mark = "<space>sm",
--             cr = "<space>s<cr>",
--             interrupt = "<space>s<space>",
--             exit = "<space>sq",
--             clear = "<space>cl",
--             mark_motion = "<space>mc",
--             mark_visual = "<space>mc",
--             remove_mark = "<space>md",
--         },
--     },
-- }

return {
    "pappasam/nvim-repl",
    init = function()
        vim.g["repl_filetype_commands"] = {
            bash = "bash",
            julia = "cd src && julia --project",
            python = "ipython --no-autoindent",
            zsh = "zsh",
        }
    end,
    keys = {
        { "<Leader>cc", "<cmd>silent ReplToggle<CR><cmd>silent ReplClear<CR>", mode = "n", desc = "Toggle Repl" },
        { "<C-c><C-c>", "<Plug>(ReplSendLine)", mode = "n", desc = "Send Repl Line" },
        { "<C-c><C-c>", "<Plug>(ReplSendVisual)", mode = "x", desc = "Send Repl Visual Selection" },
    },
}
