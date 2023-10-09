-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- [[ BEHAVIOUR ]]
-- window_close_confirmation = "NeverPrompt"

-- [[ APPEARANCE ]]

-- theme
config.color_scheme = "Catppuccin Mocha"

-- Font
config.font_size = 13.0
config.font = wezterm.font(
  "JetBrainsMono Nerd Font",
  { weight = "Medium" }
)

-- Transparent background

config.window_background_opacity = 0.8

wezterm.on("window-focus-changed", function()
  os.execute(
    'xdotool search -classname org.wezfurlong.wezterm | xargs -I{} xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id {}')
end)

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

-- CTRL-Click on links
config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.CompleteSelection("PrimarySelection"),
  },

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
  }
}


-- and finally, return the configuration to wezterm
return config
