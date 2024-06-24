-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- [[ BEHAVIOUR ]]
-- window_close_confirmation = "NeverPrompt"

-- [[ APPEARANCE ]]

-- theme
config.color_scheme = "Catppuccin Mocha"

-- Font
config.font_size = 13.0
config.font = wezterm.font(
  "JetBrainsMono NF",
  { weight = "Medium" }
)

-- Transparent background

config.window_background_opacity = .85

-- Nvim wheel scroll
config.alternate_buffer_wheel_scroll_speed = 1

-- Tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 25

-- Window size
config.initial_cols = 100
config.initial_rows = 25

config.window_padding = {
  left = '3cell',
  right = '3cell',
  top = '1cell',
  bottom = '1cell',
}

-- VISUAL BELL
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 75,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 75,
}
config.colors = {
  visual_bell = '#a1a2a6',
}

-- [[ CURSOR ]]
config.default_cursor_style = 'SteadyBlock'
-- config.animation_fps = 100
-- config.cursor_blink_rate = 300

-- disable animation
-- config.cursor_blink_ease_in = "Constant"
-- config.cursor_blink_ease_out = "Constant"


-- [[ Global config ]]
config.scrollback_lines = 10000
-- config.adjust_window_size_when_changing_font_size = false  -- bad with p10k
config.warn_about_missing_glyphs = false -- error when displaying binary

-- [[ Key binds ]]
config.keys = {
  {
    key = '=',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ResetFontSize,
  },
}


config.mouse_bindings = {
  -- Change mouse scroll amount
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByLine(-3),
    alt_screen = false -- not in nvim
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByLine(3),
    alt_screen = false -- not in nvim
  },


  -- CTRL-Click on links
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks

  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },

  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.Nop,
  },

}


return config
