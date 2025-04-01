local journal_dir = vim.env.OneDrive .. "\\repos\\memos"
if vim.env.OneDriveCommercial then
  journal_dir = vim.env.OneDriveCommercial .. "\\notes"
end

return {
  {
    dir = vim.env.LOCALAPPDATA .. "/nvim/lua/plugins/dailyjournal/",
    config = {
      journal_dir = journal_dir
    },
  },
}
