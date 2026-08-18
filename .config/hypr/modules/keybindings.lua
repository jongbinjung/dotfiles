--  vim: set ts=4 sw=4 tw=120 foldmethod=indent nowrap et :
-- https://wiki.hypr.land/Configuring/Basics/Binds/

-- Programs
local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "hyprlauncher"

-- Modifiers
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local modAlt = mainMod .. " + ALT"
local modCtrl = mainMod .. " + CTRL"
local modShift = mainMod .. " + SHIFT"
local modCtrlShift = modCtrl .. " + CTRL + SHIFT"

-- HJKL directions
local directions = {
    H = "left",
    J = "down",
    K = "up",
    L = "right",
}

local resize_step = 40 -- pixels to resize by when using resize keybindings
local resize = {
    -- Window resize mappings for four directions
    up    = { x =            0, y = -resize_step },
    down  = { x =            0, y =  resize_step },
    left  = { x = -resize_step, y =            0 },
    right = { x =  resize_step, y =            0 }
}

-- Common options for bindings that should work when locked and repeat (e.g., media controls)
local locked_and_repeating = { locked = true, repeating = true }

-- System
hl.bind(
    -- Exit
    modCtrlShift .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(
    -- Logout
    modCtrl .. " + Q",
    hl.dsp.exec_cmd("loginctl lock-session")
)
hl.bind(
    -- Reload waybar
    modCtrlShift .. " + R",
    function()
        hl.dispatch(hl.dsp.exec_cmd("pkill waybar && waybar"))
        hl.dispatch(hl.dsp.exec_cmd("waybar"))
    end
)
hl.bind(
    ---- Sway
    modShift .. " + M",
    hl.dsp.exec_cmd("swaync-client -t -sw")
)

-- Quick-launch
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + Z", hl.dsp.window.fullscreen({
  action = "toggle",
  window = "activewindow",
}))
hl.bind(mainMod .. " + X", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with mainMod + HJKL
for key, direction in pairs(directions) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
end

hl.bind(modCtrl .. " + H", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(modCtrl .. " + L", hl.dsp.focus({ workspace = "e+1" }))

-- Move window with mainMod + ALT + HJKL
for key, direction in pairs(directions) do
    hl.bind(modAlt .. " + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Resize window with mainMod + SHIFT + HJKL
for key, direction in pairs(directions) do
    hl.bind(
        modShift .. " + " .. key,
        hl.dsp.window.resize({
            x=resize[direction].x,
            y=resize[direction].y,
            relative=true
        }))
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind(modShift .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(modShift.. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), locked_and_repeating)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      locked_and_repeating)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     locked_and_repeating)
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   locked_and_repeating)
-- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), locked_and_repeating)
-- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), locked_and_repeating)

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
