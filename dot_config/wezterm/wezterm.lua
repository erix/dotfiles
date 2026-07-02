local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Macchiato"
config.automatically_reload_config = true
config.window_background_opacity = 0.88
config.macos_window_background_blur = 20
config.font_dirs = {
	"/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts",
}
config.font = wezterm.font_with_fallback({
	{ family = "SF Mono" },
	{ family = "Symbols Nerd Font Mono" },
})
config.font_size = 12.0

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false

return config
