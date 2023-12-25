#!/usr/bin/bash

# initializing wallpaper daemon
swww init &
swww img ~/almlab_sync/pictures/waves_haven.png &

# networkmanager applet
# np-applet --indicator

waybar &

# emacs daemon
/usr/bin/emacs --daemon

# notifications
# dunst &

# dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
