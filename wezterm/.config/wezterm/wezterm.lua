local wezterm = require("wezterm")
return {
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	color_scheme = "seoulbones_dark",
	-- color_scheme = "idleToes",
	front_end = "WebGpu",
	colors = {
		background = "#202020",
		cursor_bg = "#cccccc",
	},

	font_size = 22.0,
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,
	font = wezterm.font("Fira Code"),
	harfbuzz_features = { "calt=0", "clig=1", "liga=1" },
	font_rules = {
		{
			italic = true,
			font = wezterm.font("Fira Code", { weight = "Light" }),
		},
	},
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 0,
	},
	-- default_prog = { "/usr/bin/zsh", "-l" },
}
