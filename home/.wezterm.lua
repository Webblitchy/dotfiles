-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


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

-- [[ CURSOR ]]
config.default_cursor_style = 'BlinkingBar'

config.cursor_blink_rate = 500

-- disable animation
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"


-- [[ Global config ]]
config.scrollback_lines = 10000

-- and finally, return the configuration to wezterm
return config
