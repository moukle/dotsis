return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  init = function()
    vim.opt.diffopt:append({ "algorithm:histogram", "indent-heuristic", "linematch:60" })
    -- Dim the M column so only added and deleted files stand out in the file panel.
    local function dim_modified() vim.api.nvim_set_hl(0, "DiffviewStatusModified", { link = "NonText" }) end
    dim_modified()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = dim_modified })

    -- Diffview and Neogit's commit view open in their own tab; hide the tab bar there so they look like a buffer.
    local showtabline = vim.o.showtabline
    local function is_review_tab()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NeogitCommitView" or vim.api.nvim_buf_get_name(buf):match("^diffview://") then
          return true
        end
      end
      return false
    end
    vim.api.nvim_create_autocmd({ "TabEnter", "BufWinEnter", "WinEnter" }, {
      callback = function() vim.o.showtabline = is_review_tab() and 0 or showtabline end,
    })
  end,
  opts = {
    enhanced_diff_hl = true,
    view = { default = { winbar_info = true } },
  },
}
