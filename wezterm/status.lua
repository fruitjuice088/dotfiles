local wezterm = require 'wezterm'

local DEFAULT_FG = { Color = '#9a9eab' }
local DEFAULT_BG = { Color = '#333333' }
local SPACE_1 = ' '
local SPACE_3 = '   '
local HEADER_KEY_NORMAL = { Foreground = DEFAULT_FG, Text = '' }
local HEADER_LEADER = { Foreground = { Color = '#ffffff' }, Text = '' }
local HEADER_IME = { Foreground = DEFAULT_FG, Text = 'あ' }

local function AddIcon(elems, icon)
    table.insert(elems, { Foreground = icon.Foreground })
    table.insert(elems, { Background = DEFAULT_BG })
    table.insert(elems, { Text = SPACE_1 .. icon.Text .. SPACE_3 })
end

local function GetKeyboard(elems, window)
    if window:leader_is_active() then
        AddIcon(elems, HEADER_LEADER)
        return
    end
    AddIcon(elems, window:composition_status() and HEADER_IME or HEADER_KEY_NORMAL)
end

local function LeftUpdate(window, pane)
  local elems = {}

  GetKeyboard(elems, window)

  window:set_left_status(wezterm.format(elems))
end


local HEADER_HOST = { Foreground = { Color = '#75b1a9' }, Text = ' ' }
local HEADER_CWD = { Foreground = { Color = '#92aac7' }, Text = ' ' }
local HEADER_DATE = { Foreground = { Color = '#ffccac' }, Text = '󱪺 ' }
local HEADER_TIME = { Foreground = { Color = '#bcbabe' }, Text = ' ' }
local HEADER_BATTERY = { Foreground = { Color = '#dfe166' }, Text = ' ' }

local last_valid_cwd = nil

local function AddElement(elems, header, str)
  table.insert(elems, { Foreground = header.Foreground })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = header.Text .. SPACE_1 })

  table.insert(elems, { Foreground = DEFAULT_FG })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = str .. SPACE_3 })
end

local function GetHostAndCwd(elems, pane)
    AddElement(elems, HEADER_HOST, wezterm.hostname())
end

local function GetDate(elems)
    AddElement(elems, HEADER_DATE, wezterm.strftime '%a %b %-d')
end

local function GetTime(elems)
    AddElement(elems, HEADER_TIME, wezterm.strftime '%H:%M')
end

local function GetBattery(elems, window)
    for _, b in ipairs(wezterm.battery_info()) do
        AddElement(elems, HEADER_BATTERY, string.format('%.0f%%', b.state_of_charge * 100))
    end
end

local function RightUpdate(window, pane)
    local elems = {}

    GetHostAndCwd(elems, pane)
    GetDate(elems)
    GetBattery(elems, window)
    GetTime(elems)

    window:set_right_status(wezterm.format(elems))
end

wezterm.on('update-status', function(window, pane)
    LeftUpdate(window, pane)
    RightUpdate(window, pane)
end)

