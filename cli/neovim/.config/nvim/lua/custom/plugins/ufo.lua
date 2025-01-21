return {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    -- enabled = false,
    init = function()
        vim.opt.foldcolumn = "0" -- '0' is not bad
        vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true
        vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    end,
    config = function()
        require("ufo").setup()
        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

        -- disable ufo and fold column for Neogit and etc
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "Neogit*" },
            callback = function()
                require("ufo").detach()
                vim.opt_local.foldenable = false
                vim.opt_local.foldcolumn = "0"
            end,
        })
    end,
}
