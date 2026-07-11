-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",

    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
-- hl.window_rule({
--     name  = "move-hyprland-run",
--     match = { class = "hyprland-run" },

--     move  = "20 monitor_h-120",
--     float = true,
-- })

-- REAPER fixes
hl.window_rule({
    name  = "reaper-floating-window-magnet",

    match = {
      class = "REAPER",
      float = true,
    },

    move = {"cursor_x", "cursor_y"},
})

hl.window_rule({
    name  = "reaper-menu-refocus-fix",
    match = {
      class = "^(REAPER)$",
      title = "^(menu)$"
    },

    no_initial_focus = true,
})

-- Layer rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
hl.layer_rule({
  match = { namespace = "waybar" },
  blur = true ,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = { namespace = "hyprlauncher" },
  blur = true ,
  dim_around = true,
  ignore_alpha = 0.1,
})

hl.layer_rule({
  match = { namespace = "swaync-control-.*" },
  blur = true ,
  dim_around = true,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = { namespace = "swaync-notification-.*" },
  blur = true ,
  ignore_alpha = 0.5,
})
