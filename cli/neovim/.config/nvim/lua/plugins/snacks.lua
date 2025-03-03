return {
  "folke/snacks.nvim",
  opts = {
    notifier = { enabled = false },
    words = { enabled = true },
    scroll = { animate = { duration = { total = 100 } } },
    picker = {
      layout = {
        layout = {
          backdrop = false,
        },
      },
    },
    dashboard = {
      preset = {
        header = [[
█  █
███ ██
█████
██ ███
█  █
 ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            -- { icon = " ", key = "g", desc = "Find Text (Grep)", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            -- { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
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
        -- {
        --   pane = 1,
        --   icon = " ",
        --   title = "Recent Files",
        --   section = "recent_files",
        --   indent = 2,
        --   padding = 2,
        -- },
        { section = "startup" },
      },
    },
  },
  keys = {
    -- {
    --   "<leader>ff",
    --   function()
    --     Snacks.picker.files({ hidden = true })
    --   end,
    --   desc = "Find Files",
    -- },
    {
      "<leader>fp",
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
    -- stylua: ignore end
  },
}
