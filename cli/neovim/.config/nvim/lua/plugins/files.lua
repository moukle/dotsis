return {
  "chrisgrieser/nvim-genghis",
  enabled = false,
  dependencies = "stevearc/dressing.nvim",
  config = function()
    local keymap = vim.keymap.set
    local genghis = require("genghis")
    -- keymap("n", "<leader>yp", genghis.copyFilepath, { desc = "[Y]ank File[P]ath" })
    -- keymap("n", "<leader>yn", genghis.copyFilename, { desc = "[Y]ank File[N]ame" })
    -- keymap("n", "<leader>cx", genghis.chmodx, { desc = "[C]hmod +[x]" })
    -- keymap("n", "<leader>rf", genghis.renameFile, { desc = "[R]ename [F]ile" })
    -- keymap("n", "<leader>mf", genghis.moveAndRenameFile, { desc = "[M]ove and rename [F]ile" })
    -- keymap("n", "<leader>mc", genghis.moveToFolderInCwd, { desc = "[M]ove to Folder in [C]wd" })
    -- keymap("n", "<leader>nf", genghis.createNewFile, { desc = "[N]ew [F]ile" })
    -- keymap("n", "<leader>yf", genghis.duplicateFile, { desc = "[Y]ank and paste [F]ile" })
    -- keymap("n", "<leader>df", genghis.trashFile, { desc = "[D]elete [F]ile" })
    -- keymap("x", "<leader>x", genghis.moveSelectionToNewFile, { desc = "Cut to new File" })
  end,
}
