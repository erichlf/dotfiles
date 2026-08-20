local wezterm = require("wezterm")
local config = wezterm.config_builder()

local wez_tmux = wezterm.plugin.require("https://github.com/sei40kr/wez-tmux/")
wez_tmux.apply_to_config(config, {
	tab_and_split_indices_are_zero_based = true,
})

config.leader = { key = "a", mods = " CTRL" }
local keys = {
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
}

if not config.keys then
	config.keys = {}
end
for _, key in ipairs(keys) do
	table.insert(config.keys, key)
end

config.hide_tab_bar_if_only_one_tab = true

if wezterm.target_triple:find("windows") then
	config.default_prog = { "wsl" }
	config.default_domain = "WSL:Ubuntu-26.04"
end

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font_size = 11.0

return config
