return {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,
    opts = {
        notifier = {},
        dim = {
            animate = {
                total = 100, -- maximum duration
            },
        },
        picker = {
            prompt = "  ",
            files = { hidden = true },
            projects = { confirm = "" },
            layout = {
                layout = {
                    box = "vertical",
                    backdrop = false,
                    row = -1,
                    width = 0,
                    height = 0.4,
                    border = "top",
                    title = " {source} {live} {flags}",
                    title_pos = "left",
                    {
                        win = "input",
                        height = 1,
                        border = "bottom",
                    },
                    {
                        box = "horizontal",
                        {
                            win = "list",
                            border = "none",
                        },
                        {
                            win = "preview",
                            title = "{preview}",
                            width = 0.4,
                            border = "left",
                        },
                    },
                },
            },
        },
        bigfile = {
            enabled = true,
        },
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    {
                        icon = " ",
                        key = "i",
                        desc = "New File",
                        action = ":ene | startinsert",
                    },
                    -- {
                    --     icon = " ",
                    --     key = "f",
                    --     desc = "Find File",
                    --     action = ":lua Snacks.dashboard.pick('files')",
                    -- },
                    -- {
                    --     icon = " ",
                    --     key = "p",
                    --     desc = "Projects",
                    --     action = ":lua Snacks.dashboard.pick('projects'})",
                    -- },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    -- {
                    --     icon = " ",
                    --     key = "s",
                    --     desc = "Restore Session",
                    --     section = "session",
                    -- },
                    {
                        icon = " ",
                        key = "q",
                        desc = "Quit",
                        action = ":qa",
                    },
                },
                header = [[
█  █
███ ██
█████
██ ███
█  █
						]],
            },
            sections = {
                {
                    section = "header",
                },
                {
                    icon = " ",
                    title = "Keymaps",
                    section = "keys",
                    indent = 2,
                    padding = 2,
                },
                {
                    pane = 1,
                    icon = " ",
                    title = "Recent Files",
                    section = "recent_files",
                    indent = 2,
                    padding = 2,
                },
                -- {
                --     pane = 1,
                --     icon = " ",
                --     title = "Projects",
                --     section = "projects",
                --     indent = 2,
                --     padding = 1,
                -- },
                {
                    section = "startup",
                },
            },
        },
        quickfile = {
            enabled = true,
        },
        words = {
            enabled = true,
        },
        styles = {
            notification = {
                wo = {
                    wrap = true,
                },
            },
        },
        statuscolumn = {
            left = { "mark", "sign" }, -- priority of signs on the left (high to low)
            right = { "fold", "git" }, -- priority of signs on the right (high to low)
            folds = {
                open = false, -- show open fold icons
                git_hl = false, -- use Git Signs hl for fold icons
            },
            git = {
                -- patterns to match Git signs
                -- patterns = { "GitSign", "MiniDiffSign" },
            },
            refresh = 50, -- refresh at most every 50ms
        },
    },
    keys = {
        -- stylua: ignore start
        -- picker

        -- find
        { "<leader>ff", function() Snacks.picker.files({hidden = true}) end, desc = "Find Files", },
        -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files", },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },

        { "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" },

        {
            "<leader>pp",
            function()
                Snacks.picker.projects({
                    finder = "recent_projects",
                    format = "file",
                    win = {
                        preview = {
                            minimal = true,
                        },
                    },
                    confirm = function(picker, item)
                        picker:close()
                        vim.fn.chdir(Snacks.git.get_root(item.text))
                        if item then
                            vim.schedule(function()
                                Snacks.picker.files({
                                    filter = {
                                        cwd = Snacks.git.get_root(item.text),
                                    },
                                    -- finder = "recent_files",
                                    hidden = true,
                                    format = "file",
                                })
                            end)
                        end
                    end,
                })
            end,
            desc = "Projects and recent",
        },

        -- search
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>/", function() Snacks.picker.grep({hidden=true}) end, desc = "Grep" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },

        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications", },
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
        { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal", },

        {"<leader>td", function() Snacks.dim() end, desc = "Toggle Dim" }
,
    },
    -- stylua: ignore end
}
