-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Autostart necessary processes (like notifications daemons, status bars, etc.)
hl.on("hyprland.start", function ()
  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("waybar & hypridle & swaync & swaync-client -df")
end)
