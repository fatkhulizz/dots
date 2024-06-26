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

wezterm.on('user-var-changed', function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while (number_value > 0) do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- For example, changing the color scheme:
config = {
	-- dont start as login shell, dammit
	default_prog = { '/usr/bin/zsh'},
	-- enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	color_scheme ='Catppuccin Mocha',
	-- colors = { background = 'black' },
	window_background_opacity = 0.8,
	-- font = wezterm.font('Iosevka Nerd Font'),
	font = wezterm.font('CaskaydiaCove Nerd Font Mono'),
	font_size = 12.0,

	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},

	-- cursor too thick
	cursor_thickness = 1,

	-- better underline
	underline_thickness = 6,
	underline_position = -4,

	-- disable ligature
	harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
	-- window_decorations = "RESIZE"
}


-- and finally, return the configuration to wezterm
return config
