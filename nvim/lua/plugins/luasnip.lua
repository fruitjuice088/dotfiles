return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local snippets_paths = { vim.env.LOCALAPPDATA .. "/nvim/lua/snippets" }
      if vim.env.OneDriveCommercial then
        table.insert(snippets_paths, vim.env.OneDriveCommercial .. "/notes/.snippets")
      end
      require("luasnip.loaders.from_lua").load({ paths = snippets_paths })
    end,
  },
}
