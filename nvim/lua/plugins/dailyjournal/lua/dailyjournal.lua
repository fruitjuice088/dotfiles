local M = {}

local function get_date_filename()
  return os.date("%Y.%m.%d") .. ".md"
end

local function open_file(filepath)
  vim.cmd("silent! edit " .. filepath)
end

local function is_valid_journal(filename)
  return filename:match("^%d%d%d%d.%d%d.%d%d.md$")
end

M.setup = function(args)
  M.journal_dir = args.journal_dir or vim.env.USERPROFILE .. "/notes"

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local cwd = vim.fn.getcwd()
      if cwd == M.journal_dir then
        require("dailyjournal").open_today_journal()
        vim.cmd("set filetype=markdown")
      end
    end,
  })
end

function M.open_today_journal()
  local today_filename = get_date_filename()
  local today_journal_filepath = M.journal_dir .. "/" .. today_filename
  open_file(today_journal_filepath)
end

function M.open_latest_journal()
  local files = vim.fn.globpath(M.journal_dir, "*.md", false, true)
  table.sort(files, function(a, b)
    return a > b
  end)

  local today_filename = get_date_filename()
  for _, file in ipairs(files) do
    local filename = file:match("([^\\]+)$")
    if is_valid_journal(filename) and filename ~= today_filename then
      open_file(file)
      return
    end
  end

  vim.api.nvim_err_writeln("No previous journal files found.")
end

return M
