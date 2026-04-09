#!/usr/bin/env bash

options=" Shutdown\n Reboot\n Suspend\n Lock\n Logout"

chosen=$(echo -e "$options" | wofi --show dmenu \
    -s ~/nixos-config/modules/home/wofi/style.css \
    --width 250 --height 230 \
    --prompt "Power" \
    --no-actions \
    --insensitive \
    -D hide_search=true)

case "$chosen" in
    " Shutdown") systemctl poweroff ;;
    " Reboot")   systemctl reboot ;;
    " Suspend")  systemctl suspend ;;
    " Lock")     hyprlock ;;
    " Logout")   hyprctl dispatch exit ;;
esac
