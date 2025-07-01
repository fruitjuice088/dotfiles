-- ~/.config/nvim/init.lua
-- 軽量Neovim設定 (フルスクラッチ + luasnip)
-- LSPは除外、段階的に機能追加可能

-- ============================================================================
-- Phase 1: 絶対必要 (Microsoft Edit級軽量性) - 起動時間 15-20ms目標
-- ============================================================================

-- 基本設定
vim.opt.number = true                    -- 行番号表示
vim.opt.relativenumber = true            -- 相対行番号
vim.opt.tabstop = 2                      -- タブ文字の幅
vim.opt.shiftwidth = 2                   -- インデント幅
vim.opt.expandtab = true                 -- タブをスペースに変換
vim.opt.smartindent = true               -- スマートインデント
vim.opt.wrap = false                     -- 行の折り返し無効
vim.opt.ignorecase = true                -- 検索時大文字小文字無視
vim.opt.smartcase = true                 -- 大文字含む場合は区別
vim.opt.incsearch = true                 -- インクリメンタル検索
vim.opt.hlsearch = true                  -- 検索結果ハイライト
vim.opt.cursorline = true                -- カーソル行ハイライト

-- 背景透過設定
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#d7af5f" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c2c2c" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d7af5f", bold = true })
  end,
})

-- あなた専用の文字エンコーディング設定
vim.opt.fileencodings = "utf-8,sjis,euc-jp,cp932"
vim.opt.spelllang = { "en", "cjk" }      -- 日本語対応

-- 基本的な無効化設定（軽量化）
vim.g.autoformat = false                 -- 自動フォーマット無効
vim.g.loaded_python3_provider = 0        -- Python provider無効
vim.g.loaded_ruby_provider = 0           -- Ruby provider無効
vim.g.loaded_perl_provider = 0           -- Perl provider無効
vim.g.loaded_node_provider = 0           -- Node.js provider無効

-- ============================================================================
-- 軽量プラグイン管理（luasnip用）
-- ============================================================================

local function ensure_plugin(repo, dir)
  local install_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/" .. dir
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print("Installing " .. repo .. "...")
    vim.fn.system({
      "git", "clone", "--depth", "1",
      "https://github.com/" .. repo .. ".git",
      install_path
    })
    vim.cmd("packloadall!")
    print(repo .. " installed!")
  end
end

-- luasnipをインストール
ensure_plugin("L3MON4D3/LuaSnip", "luasnip")

-- ============================================================================
-- START: nvim-cmp (補完プラグイン) の設定
-- ============================================================================
ensure_plugin("hrsh7th/nvim-cmp", "nvim-cmp")
ensure_plugin("hrsh7th/cmp-buffer", "cmp-buffer")     -- バッファ内補完
ensure_plugin("hrsh7th/cmp-path", "cmp-path")         -- パス補完
ensure_plugin("saadparwaiz1/cmp_luasnip", "cmp_luasnip") -- LuaSnip連携
-- ============================================================================
-- END: nvim-cmp (補完プラグイン) の設定
-- ============================================================================

-- ============================================================================
-- START: GitHub Copilot の設定
-- ============================================================================
ensure_plugin("zbirenbaum/copilot.lua", "copilot.lua")
ensure_plugin("zbirenbaum/copilot-cmp", "copilot-cmp")
-- ============================================================================
-- END: GitHub Copilot の設定
-- ============================================================================

-- ============================================================================
-- Phase 2: 軽作業必須 (メモ・ジャーナル機能) - 起動時間 30-40ms目標
-- ============================================================================

-- keymap
vim.api.nvim_set_var("mapleader", " ")  -- リーダーキーをスペースに設定
vim.keymap.set("n", "<leader>fej", ":e ++encoding=sjis<CR>", { desc = "Open file with SJIS encoding" })
vim.keymap.set("n", "<leader>~~", ":s/^\\( *-* *\\)\\(.*\\)/\\1\\~\\~\\2\\~\\~<CR>:noh<CR>", { desc = "Add strikethrough" })
vim.keymap.set("n", "<leader>**", ":s/^\\( *-* *\\)\\(.*\\)/\\1\\*\\*\\2\\*\\*<CR>:noh<CR>", { desc = "Add bold" })

-- Insert curret time
vim.keymap.set("i", "<A-b>", '<C-R>=strftime("%H:%M")<CR>', { desc = "Add bold" })
vim.keymap.set("n", "<A-b>", 'i<C-R>=strftime("%H:%M")<CR><Esc>', { desc = "Insert current time" })

-- Auto save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*" },
  command = "silent! wall",
  nested = true,
  desc = "Auto save on insert leave and text change"
})

-- ============================================================================
-- Daily Journal Functionality
-- ============================================================================

local DailyJournal = {}

-- 設定
DailyJournal.journal_dir = vim.env.OneDriveCommercial and (vim.env.OneDriveCommercial .. "/notes") or (vim.env.OneDrive .. "/repos/memos")

-- ユーティリティ関数
local function get_date_filename()
  return os.date("%Y.%m.%d") .. ".md"
end

local function open_file(filepath)
  vim.cmd("silent! edit " .. filepath)
end

local function is_valid_journal(filename)
  return filename:match("^%d%d%d%d.%d%d.%d%d.md$")
end

function DailyJournal.open_today_journal()
  local today_filename = get_date_filename()
  local today_journal_filepath = DailyJournal.journal_dir .. "/" .. today_filename
  
  -- ディレクトリが存在しない場合何もしない
  if not vim.fn.isdirectory(DailyJournal.journal_dir) then
    vim.api.nvim_err_writeln("Journal directory does not exist: " .. DailyJournal.journal_dir)
    return
  end
  
  open_file(today_journal_filepath)
  
  -- ファイルが空の場合、基本テンプレートを挿入
  if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
    local date_str = os.date("%H:%M ")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, date_str)
    vim.cmd("normal! 4j$")  -- TODOセクションの末尾にカーソル移動
  end
end

-- 最新のジャーナルを開く
function DailyJournal.open_latest_journal()
  local files = vim.fn.globpath(DailyJournal.journal_dir, "*.md", false, true)
  
  if #files == 0 then
    vim.api.nvim_err_writeln("No journal files found.")
    return
  end
  
  table.sort(files, function(a, b)
    return a > b
  end)

  local today_filename = get_date_filename()
  for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ":t")
    if is_valid_journal(filename) and filename ~= today_filename then
      open_file(file)
      return
    end
  end

  vim.api.nvim_err_writeln("No previous journal files found.")
end

-- -- VimEnter時の自動開設定（あなたの既存機能）
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     local cwd = vim.fn.getcwd()
--     if cwd == DailyJournal.journal_dir then
--       DailyJournal.open_today_journal()
--       vim.cmd("set filetype=markdown")
--       if vim.env.OneDriveCommercial ~= nil then
--         vim.cmd("bdelete")
--       end
--     end
--   end,
-- })

-- キーマップ設定
vim.keymap.set("n", "<leader>ji", DailyJournal.open_today_journal, { desc = "Open today's journal" })
vim.keymap.set("n", "<leader>jo", DailyJournal.open_latest_journal, { desc = "Open latest journal" })

-- ============================================================================
-- LuaSnip設定（あなたのスニペット要件に対応）
-- ============================================================================

-- LuaSnipが読み込まれるまで待機
vim.defer_fn(function()
  local ok, luasnip = pcall(require, "luasnip")
  if not ok then
    print("LuaSnip not found")
    return
  end

  -- 基本設定
  luasnip.config.setup({
    history = true,
    -- updateevents = "TextChanged,TextChangedI", -- 競合チェックのため一時的に無効化
    enable_autosnippets = true,
  })

  -- スニペット定義 (別ファイルに移行)
  -- local s = luasnip.snippet
  -- local t = luasnip.text_node
  -- local f = luasnip.function_node

  -- markdownスニペット (別ファイルに移行)
  -- local markdown_snippets = { ... }

  -- 外部ファイルからスニペットを読み込む
  local markdown_snippets_ok, markdown_snippets = pcall(require, "custom-snippets.markdown")
  if not markdown_snippets_ok then
    print("Could not load markdown snippets")
    markdown_snippets = {}
  end

  -- markdownファイルタイプでスニペットを追加
  luasnip.add_snippets("markdown", markdown_snippets)
  
  -- journalディレクトリでも全ファイルタイプにmarkdownスニペットを適用
  vim.api.nvim_create_autocmd({"BufEnter", "BufNewFile"}, {
    callback = function()
      local cwd = vim.fn.getcwd()
      if cwd == DailyJournal.journal_dir then
        luasnip.add_snippets("all", markdown_snippets)
      end
    end,
  })

  -- LuaSnipキーマップ (nvim-cmpが制御するため、ここでは基本的な設定のみ)
  vim.keymap.set("i", "<C-l>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end, { desc = "Change choice in snippet" })

end, 500) -- 500ms後に実行（プラグイン読み込み待ち）

-- ============================================================================
-- START: nvim-cmp (補完プラグイン) の設定
-- ============================================================================
vim.defer_fn(function()
  local cmp_ok, cmp = pcall(require, "cmp")
  if not cmp_ok then
    print("nvim-cmp not found")
    return
  end

  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if not luasnip_ok then
    print("LuaSnip not found for nvim-cmp")
    return
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "copilot" }, -- Copilotの提案を追加
      { name = "luasnip" }, -- スニペットを補完ソースにする
      { name = "buffer" },  -- 開いているバッファの単語
      { name = "path" },    -- ファイルパス
    }),
    mapping = {
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
  })
end, 3000) -- LuaSnipより少し後に実行
-- ============================================================================
-- END: nvim-cmp (補完プラグイン) の設定
-- ============================================================================

-- ============================================================================
-- START: GitHub Copilot の設定
-- ============================================================================
vim.defer_fn(function()
  local copilot_ok, copilot = pcall(require, "copilot")
  if not copilot_ok then
    print("GitHub Copilot not found")
    return
  end
  copilot.setup({
    panel = { enabled = true },      -- パネルを有効化し、他の候補を表示できるようにする
    suggestion = { enabled = false }, -- cmp経由で表示するため、自動表示は無効化
    filetypes = {
      lua = true,        -- Luaファイルで有効化
      markdown = true,   -- markdownでは無効化
      ["*"] = false,     -- その他のファイルタイプでは無効化
    },
  })

  local copilot_cmp_ok, copilot_cmp = pcall(require, "copilot_cmp")
  if not copilot_cmp_ok then
    print("copilot-cmp not found")
    return
  end
  copilot_cmp.setup()

  -- Copilotパネルを開くキーマップ
  vim.keymap.set("i", "<A-c>", function() vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Cmd>Copilot panel<CR>", true, true, true), "") end, { desc = "Open Copilot Panel" })
end, 3200) -- cmpの後に実行
-- ============================================================================
-- END: GitHub Copilot の設定
-- ============================================================================

-- ============================================================================
-- Phase 3: 利便性向上 (カラー・ファイル操作) - 起動時間 50-100ms目標
-- ============================================================================

-- ============================================================================
-- START: which-key.nvim の設定
-- ============================================================================
ensure_plugin("folke/which-key.nvim", "which-key.nvim")

vim.defer_fn(function()
  local ok, which_key = pcall(require, "which-key")
  if not ok then
    print("which-key.nvim not found")
    return
  end
  which_key.setup({
    win = {
      border = "single", -- 枠を追加して見やすくする
    },
    -- 軽量性を維持するため、デフォルト。これでも充分らしい。
  })
end, 1000) -- 他のプラグイン読み込み後に実行
-- ============================================================================
-- END: which-key.nvim の設定
-- ============================================================================

-- ファイル操作の便利キーマップ
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>f", ":find ", { desc = "Find file" })
-- TODO: <leader>/ で全文検索したい

-- バッファ操作
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- ウィンドウ操作
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ============================================================================
-- 設定完了
-- ============================================================================

-- 起動時間測定（デバッグ用）
-- vim.defer_fn(function()
--   print("Lightweight Neovim with LuaSnip loaded")
-- end, 1000)
