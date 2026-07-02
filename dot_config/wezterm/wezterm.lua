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
config.line_height = 1.05
config.cell_width = 1.0

config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
	left = 10,
	right = 10,
	top = 8,
	bottom = 8,
}

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false
config.tab_max_width = 32

config.keys = {
	{ key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
}

return config
