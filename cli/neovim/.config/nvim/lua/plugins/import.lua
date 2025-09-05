return {
  "piersolenski/import.nvim",
  dependencies = {
    "folke/snacks.nvim",
    -- "nvim-telescope/telescope.nvim",
  },
  opts = {
    picker = "snacks",

    custom_languages = {
      {
        extensions = { "jl" },
        filetypes = { "julia" },
        regex = [[^(?:import|using)\s+(.*)]],
      },
    },
  },
  keys = {
    {
      "<leader>fi",
      function()
        require("import").pick()
      end,
      desc = "Find Imports",
    },
  },
}
