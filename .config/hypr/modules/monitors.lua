-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.07",
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
hl.config({
  xwayland = {
    force_zero_scaling = true
  }
})
