require 'status'

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.initial_rows = 80
config.initial_cols = 150

-- This is where you actually apply your config choices

-- For example, charging the color scheme:
config.color_scheme = 'zenwritten_dark'

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { 'pwsh.exe', "-NoLogo" }
end

config.status_update_interval = 1000

config.window_background_opacity = 0.75
config.automatically_reload_config = true
config.enable_tab_bar = true
config.font_size = 12.0
config.font = wezterm.font("Hack Nerd Font")


-- Remove title bar
config.window_decorations = "RESIZE"
config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
}
config.window_background_gradient = {
    colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false
config.colors = {
    tab_bar = {
        inactive_tab_edge = "none",
    }
}
config.set_environment_variables = {
        WSLENV = "TERM_PROGRAM/u:TERM_PROGRAM_VERSION/u",
    }
-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- wezterm.on('window-config-reloaded', function(window, pane)
--     wezterm.log_info 'the config was reloaded for this window!'
-- end)

-- and finally, return the configuration to wezterm
return config
