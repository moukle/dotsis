return {
    "danymat/neogen",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
    keys = {
        {
            "<leader>cd",
            ":lua require('neogen').generate()<CR>",
            silent = true,
            noremap = true,
            desc = "Generate Docstring",
        },
    },
}
