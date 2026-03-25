#!/usr/bin/env zsh
WALLPAPER_DIR="$HOME/nixos-config/wallpapers/"

menu() {
	find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

main() {
	choice=$(menu | wofi --show dmenu --prompt "Select Wallpaper:" -n -c ~/nixos-config/modules/home/wofi/wallpaper -s ~/nixos-config/modules/home/wofi/style-wallpaper.css)
	selected_wallpaper=$(echo "$choice" | sed 's/^img://')
	swww img "$selected_wallpaper" --transition-type wipe  --transition-duration .5 
	wal -i "$selected_wallpaper"
}

main
