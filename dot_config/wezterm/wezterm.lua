local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Macchiato"
config.automatically_reload_config = true
config.font = wezterm.font({
	family = "RobotoMono Nerd Font",
	stretch = "UltraExpanded",
	weight = "Regular",
	-- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 13.0

return config
