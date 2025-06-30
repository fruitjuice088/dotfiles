-- custom-snippets/markdown.lua

-- LuaSnipの関数をローカル変数に
local s = require("luasnip").snippet
local t = require("luasnip").text_node
local f = require("luasnip").function_node

-- スニペットの定義
local snippets = {
  -- 会議系
  s("regmtg", {
    f(function()
      local time = os.date("%H:%M")
      local end_time = os.date("%H:%M", os.time() + 3600) -- 1時間後
      return time .. "-" .. end_time .. " 定例会議"
    end),
  }),
  
  s("mtg", {
    f(function()
      local time = os.date("%H:%M")
      local end_time = os.date("%H:%M", os.time() + 1800) -- 30分後
      return time .. "-" .. end_time .. " 会議"
    end),
  }),
  
  -- タスク系
  s("task", {
    t("- [ ] "),
  }),
  
  s("done", {
    t("- [x] "),
  }),
  
  -- 時間系
  s("time", {
    f(function()
      return os.date("%H:%M")
    end),
  }),
  
  s("date", {
    f(function()
      return os.date("%Y-%m-%d")
    end),
  }),
  
  s("datetime", {
    f(function()
      return os.date("%Y-%m-%d %H:%M")
    end),
  }),
  
  -- 見出し系（時刻付き）
  s("h1", {
    f(function()
      return "# " .. os.date("%H:%M") .. " "
    end),
  }),
  
  s("h2", {
    f(function()
      return "## " .. os.date("%H:%M") .. " "
    end),
  }),
}

-- スニペットを返す
return snippets
