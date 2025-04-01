-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Save automatically when returning to normal mode
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*" },
  command = "silent! wall",
  nested = true,
})

-- for dailyjournal
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local cwd = vim.fn.getcwd()
    local sep = "\\"
    if cwd == vim.env.OneDrive .. sep .. "notes" then
      require("dailyjournal").open_today_journal()
      vim.cmd("bdelete")
    end
  end,
})
