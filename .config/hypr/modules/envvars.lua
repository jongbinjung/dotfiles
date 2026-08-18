-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("GDK_SCALE", "1.25")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/ssh-agent.socket")

hl.env("QT_IM_MODULE", "ibus")
hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland")

-- toolkit-specific scale
hl.env("GDK_SCALE", "2")
hl.env("HYPRCURSOR_SIZE", "48")
hl.env("XCURSOR_SIZE", "48")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
