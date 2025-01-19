-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "\\", ":Neotree reveal<CR>", { desc = "NeoTree reveal" } },
    },
    opts = function(_, opts)
        local neotree = require("neo-tree")
        local function on_move(data)
            Snacks.rename.on_rename_file(data.source, data.destination)
        end
        local events = neotree.events
        opts.event_handlers = opts.event_handlers or {}
        vim.list_extend(opts.event_handlers, {
            { event = events.FILE_MOVED, handler = on_move },
            { event = events.FILE_RENAMED, handler = on_move },
        })

        -- neotree.setup({
        --     default_component_configs = {
        --         indent = {
        --             with_markers = false,
        --         },
        --         icon = {
        --             folder_closed = "",
        --             folder_open = "",
        --             folder_empty = "",
        --         },
        --         name = {
        --             use_git_status_colors = true,
        --         },
        --     },
        --     close_if_last_window = true,
        --     filesystem = {
        --         filtered_items = {
        --             hide_dotfiles = false,
        --             hide_by_name = {
        --                 ".git",
        --             },
        --         },
        --         follow_current_file = {
        --             enabled = true,
        --         },
        --         window = {
        --             mappings = {
        --                 ["\\"] = "close_window",
        --             },
        --         },
        --     },
        -- })
    end,
}
