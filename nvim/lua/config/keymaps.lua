-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fej", ":e ++encoding=sjis<CR>")

vim.keymap.set("n", "<leader>~~", ":s/^\\( *-* *\\)\\(.*\\)/\\1\\~\\~\\2\\~\\~<CR>:noh<CR>")
vim.keymap.set("n", "<leader>**", ":s/^\\( *-* *\\)\\(.*\\)/\\1\\*\\*\\2\\*\\*<CR>:noh<CR>")

vim.keymap.set("i", "<A-b>", '<C-R>=strftime("%H:%M")"<CR>')
vim.keymap.set("n", "<A-b>", '<C-R>=strftime("%H:%M")"<CR>')
vim.keymap.set("n", '<C-i>', '<Cmd>lua require("dailyjournal").open_today_journal()<CR>')
vim.keymap.set("n", '<C-A-i>', '<Cmd>lua require("dailyjournal").open_latest_journal()<CR>')
