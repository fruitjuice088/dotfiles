local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local f = luasnip.function_node

local function ctime()
  return os.date("%H:%M")
end

luasnip.add_snippets("markdown", {
  s("ctime", {
    t("current time is "),
    f(ctime, {}),
  }),
})
