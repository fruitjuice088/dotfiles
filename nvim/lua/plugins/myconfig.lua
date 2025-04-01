return {

  {
    "numToStr/Comment.nvim",
    opts = function(_, _)
      local ft = require("Comment.ft")
      ft.set("ahk", ";")
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufEnter",
    opts = { "*" },
  },
  {
    "lukoshkin/highlight-whitespace",
    config = true,
  },
}
