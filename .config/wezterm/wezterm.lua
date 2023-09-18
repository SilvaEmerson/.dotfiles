-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'Dracula (Official)'

-- config.font = wezterm.font 'Fira Code Nerd Font'
config.font = wezterm.font 'Fira Code iScript'
config.font_size = 12


config.window_decorations = "NONE"

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.window_frame = {
  border_left_width = '0cell',
  border_right_width = '0cell',
  border_bottom_height = '0cell',
  border_top_height = '0cell',
}

config.hide_tab_bar_if_only_one_tab = true

local gpus = wezterm.gui.enumerate_gpus()

config.webgpu_preferred_adapter = gpus[0]
config.front_end = 'WebGpu'

-- and finally, return the configuration to wezterm
return config
