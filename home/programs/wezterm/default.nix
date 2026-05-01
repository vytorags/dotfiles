{ unstable, config, ... }:
let
  font = config.stylix.fonts.monospace;
in
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    extraConfig = ''
       local config = wezterm.config_builder()
       local act = wezterm.action

       config.enable_wayland = true
       config.enable_tab_bar = false
       config.window_close_confirmation = "NeverPrompt"
       config.cursor_blink_ease_in = "Constant"
       config.cursor_blink_ease_out = "Constant"
       config.line_height = 1.5
       config.font = wezterm.font_with_fallback({
       	{
       		family = "${font.name}",
       		harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
       		weight = "Bold",
       		italic = false,
       	},
       })
       config.font_rules = {
         {
             intensity = "Half",
             italic = false,
             font = wezterm.font("${font.name}", { weight = "Bold", stretch = "Normal" }),
         },
         {
             intensity = "Half",
             italic = true,
             font = wezterm.font("${font.name}", { weight = "Bold", stretch = "Normal", style = "Italic" }),
         },
       }
      config.font_size = 12.5
       config.custom_block_glyphs = true
       config.mouse_wheel_scrolls_tabs = false
       config.warn_about_missing_glyphs = false
       config.window_padding = {
       	left = "0.5cell",
       	right = "0.2cell",
       	top = "0.1cell",
       	bottom = "0cell",
       }
       config.keys = {
         {
           key = 't',
           mods = 'ALT',
           action = act.SpawnTab 'CurrentPaneDomain',
         },
       	{
       		key = ",",
       		mods = "ALT",
       		action = act.PromptInputLine({
       			description = "Enter new name for tab",
       			action = wezterm.action_callback(function(window, pane, line)
       				if line then
       					window:active_tab():set_title(line)
       				end
       			end),
       		}),
       	},
       	{
       		key = "w",
       		mods = "ALT",
       		action = act.ShowTabNavigator,
       	},
       	{
       		key = "n",
       		mods = "ALT",
       		action = act.ActivateTabRelative(1),
       	},
       	{
       		key = "p",
       		mods = "ALT",
       		action = act.ActivateTabRelative(-1),
       	},
       	{
       		key = "h",
       		mods = "ALT|SHIFT",
       		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
       	},
       	{
       		key = "v",
       		mods = "ALT|SHIFT",
       		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
       	},
       	{
       		key = "c",
       		mods = "ALT|SHIFT",
       		action = act.SplitPane({
       			direction = "Left",
       			command = { args = { "sh", "-c", "sleep 2; gemini" } },
       		}),
       	},
       	{
       		key = "h",
       		mods = "ALT",
       		action = act.ActivatePaneDirection("Left"),
       	},
       	{
       		key = "l",
       		mods = "ALT",
       		action = act.ActivatePaneDirection("Right"),
       	},
       	{
       		key = "k",
       		mods = "ALT",
       		action = act.ActivatePaneDirection("Up"),
       	},
       	{
       		key = "j",
       		mods = "ALT",
       		action = act.ActivatePaneDirection("Down"),
       	},
       	{
       		key = "h",
       		mods = "CTRL|ALT",
       		action = act.AdjustPaneSize({ "Left", 3 }),
       	},
       	{
       		key = "l",
       		mods = "CTRL|ALT",
       		action = act.AdjustPaneSize({ "Right", 3 }),
       	},
       	{
       		key = "k",
       		mods = "CTRL|ALT",
       		action = act.AdjustPaneSize({ "Up", 3 }),
       	},
       	{
       		key = "j",
       		mods = "CTRL|ALT",
       		action = act.AdjustPaneSize({ "Down", 3 }),
       	},
       	{
       		key = "w",
       		mods = "ALT|SHIFT",
       		action = act.CloseCurrentPane({ confirm = false }),
       	},
       	{
       		key = "f",
       		mods = "ALT",
       		action = wezterm.action_callback(function(_, pane)
       			local tab = pane:tab()
       			local panes = tab:panes_with_info()
       			if #panes == 1 then
       				pane:split({
       					direction = "Bottom",
       					size = 0.5,
       				})
       			elseif panes[1].is_zoomed then
       				tab:set_zoomed(false)
       				for _, p in ipairs(panes) do
       					if p.pane:pane_id() == last_active_pane_id then
       						p.pane:activate()
       						return
       					end
       				end
       			else
       				last_active_pane_id = pane:pane_id()
       				panes[1].pane:activate()
       				tab:set_zoomed(true)
       			end
       		end),
       	},
       }

       -- config.unix_domains = {
       --     { name = "unix" },
       -- }

       return config
    '';
  };
}
