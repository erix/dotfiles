local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Macchiato"
config.automatically_reload_config = true
config.font = wezterm.font({
	family = "RobotoMono Nerd Font",
	-- stretch = "UltraExpanded",
	-- weight = "Regular",
	-- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 13.0

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false

return config
