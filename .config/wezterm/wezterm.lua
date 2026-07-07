-- WezTerm config — ported from Ghostty (.config/ghostty/config)
-- Standard path ~/.config/wezterm/wezterm.lua works on Linux, macOS, Windows.

local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- --- Visuals & Typography ---
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.font_size = 10
config.line_height = 1.0
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- Ghostty -liga -calt
-- Theme — change this ONE line to re-theme everything; the tab bar derives from it.
local scheme_name = 'Gruvbox Dark (Gogh)'                   -- try: 'Tokyo Night' 'Tokyo Night Moon'
config.color_scheme = scheme_name
local scheme = wezterm.color.get_builtin_schemes()[scheme_name]

-- Crisper glyph rendering on LCD panels (subpixel). Drop to 'Normal' if fringing.
config.freetype_load_target = 'Normal'
config.freetype_render_target = 'Normal'

-- FiraCode ships no italic face; without this WezTerm swaps in a foreign italic
-- font (jarring, looks lower-res). Render italic/bold-italic as upright FiraCode.
config.font_rules = {
  { italic = true, intensity = 'Normal', font = wezterm.font 'FiraCode Nerd Font Mono' },
  { italic = true, intensity = 'Half',   font = wezterm.font 'FiraCode Nerd Font Mono' },
  { italic = true, intensity = 'Bold',   font = wezterm.font('FiraCode Nerd Font Mono', { weight = 'Bold' }) },
}

-- --- Opacity & Blur --- (blur is per-OS at the bottom)
config.window_background_opacity = 0.98

-- --- Cursor ---
config.default_cursor_style = 'SteadyBlock' -- block, no blink

-- Use the standard GNOME (Adwaita) mouse pointer instead of WezTerm's
-- core-X fallback, which renders as an ugly legacy arrow.
config.xcursor_theme = 'Adwaita'
config.xcursor_size = 24

-- --- Interaction & Compatibility ---
-- xterm-256color for tmux-over-SSH: remote hosts lack wezterm terminfo.
config.term = 'xterm-256color'

-- --- Window chrome & tab bar ---
-- Fold window buttons into the fancy tab bar (one unified top bar). On GNOME/X11
-- this isn't supported and the WM title bar can't be removed anyway (wezterm
-- issue #3936 - broken Motif hints on Mutter), so fall back to plain RESIZE.
local is_x11 = wezterm.target_triple:find 'linux' and not os.getenv 'WAYLAND_DISPLAY'
config.window_decorations = true and 'RESIZE' or 'INTEGRATED_BUTTONS|RESIZE'
config.use_fancy_tab_bar = true
-- Only X11 has a native WM titlebar with close/min/max buttons; elsewhere
-- (Windows/macOS) those buttons are drawn inside the tab bar itself
-- (INTEGRATED_BUTTONS above), so hiding the bar would hide them too.
config.hide_tab_bar_if_only_one_tab = is_x11
config.window_padding = { left = 4, right = 4, top = 2, bottom = 0 }

-- Dim unfocused WezTerm splits for clear focus (no effect on tmux panes).
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 }

-- Slim top bar, tinted from the active color scheme (see scheme_name above).
config.window_frame = {
  font = wezterm.font { family = 'FiraCode Nerd Font Mono', weight = 'Regular' },
  font_size = 9,
  active_titlebar_bg = scheme.background,
  inactive_titlebar_bg = scheme.background,
}

-- Subtle tabs derived from the scheme palette.
config.colors = {
  tab_bar = {
    background = scheme.background,
    active_tab = { bg_color = scheme.selection_bg, fg_color = scheme.foreground },
    inactive_tab = { bg_color = scheme.background, fg_color = scheme.brights[1] },
    inactive_tab_hover = { bg_color = scheme.selection_bg, fg_color = scheme.foreground },
    new_tab = { bg_color = scheme.background, fg_color = scheme.brights[1] },
    new_tab_hover = { bg_color = scheme.selection_bg, fg_color = scheme.foreground },
  },
}

-- --- Splits (Terminator Style) ---
-- --- Navigation (Alt + Arrow Keys) ---
config.keys = {
  { key = 'o',          mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Down' } },
  { key = 'e',          mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Right' } },
  { key = 'LeftArrow',  mods = 'ALT',        action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT',        action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'ALT',        action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'ALT',        action = act.ActivatePaneDirection 'Down' },
  { key = 'Enter',      mods = 'SHIFT',      action = act.SendString '\x1b\r' },
  -- Jump to tabs 1-9 with ALT + number.
  { key = '1',          mods = 'ALT',        action = act.ActivateTab(0) },
  { key = '2',          mods = 'ALT',        action = act.ActivateTab(1) },
  { key = '3',          mods = 'ALT',        action = act.ActivateTab(2) },
  { key = '4',          mods = 'ALT',        action = act.ActivateTab(3) },
  { key = '5',          mods = 'ALT',        action = act.ActivateTab(4) },
  { key = '6',          mods = 'ALT',        action = act.ActivateTab(5) },
  { key = '7',          mods = 'ALT',        action = act.ActivateTab(6) },
  { key = '8',          mods = 'ALT',        action = act.ActivateTab(7) },
  { key = '9',          mods = 'ALT',        action = act.ActivateTab(8) },
  {
    key = 'R',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Rename tab:',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

-- Ghostty copy-on-select = true: copy to clipboard on mouse selection.
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
}

-- Prettier tab titles: " <index> · <process/title> ", active tab bold.
-- Colors inherit from colors.tab_bar above.
wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local i = tab.tab_index + 1
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  title = wezterm.truncate_right(title, math.max(max_width - 6, 1))
  return wezterm.format {
    { Attribute = { Intensity = tab.is_active and 'Bold' or 'Normal' } },
    { Text = string.format(' %d · %s ', i, title) },
  }
end)

-- Battery percentage in the tab bar's right status (local machine only;
-- renders empty on machines with no battery, e.g. the Linux desktop).
wezterm.on('update-status', function(window, pane)
  local batteries = wezterm.battery_info()
  if #batteries == 0 then
    window:set_right_status('')
    return
  end
  local b = batteries[1]
  local icon = b.state == 'Charging' and '⚡' or ''
  window:set_right_status(wezterm.format {
    { Foreground = { Color = scheme.foreground } },
    { Text = string.format(' %s%.0f%% ', icon, b.state_of_charge * 100) },
  })
end)

-- Per-OS blur (Ghostty background-blur = 20). Linux blur is left to the
-- compositor (KDE/Wayland); WezTerm has no native Linux blur setting.
if wezterm.target_triple:find 'windows' then
  config.win32_system_backdrop = 'Acrylic'
  -- Default local shell: Git Bash (already installed with Git, no WSL
  -- needed) instead of cmd.exe. Use bin/bash.exe, not git-bash.exe itself
  -- (that one just spawns its own separate mintty window).
  config.default_prog = {
    'C:/Users/andreas.lebherz/AppData/Local/Programs/Git/bin/bash.exe',
    '--login',
    '-i',
  }
elseif wezterm.target_triple:find 'darwin' then
  config.macos_window_background_blur = 20
end

return config
