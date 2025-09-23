return {
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  {
    "nvim-mini/mini.comment",
    opts = {
      mappings = {
        comment = "gc",
        comment_line = "<c-c>",
        comment_visual = "<c-c>",
        textobject = "c-c>",
      },
    },
  },
}
