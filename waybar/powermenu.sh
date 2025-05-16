#!/usr/bin/env sh

# -H is font size(13px)*(2*num_options+1)
op=$(echo -e "  Poweroff\n  Reboot\n  Suspend\n  Logout" | wofi -i -d -H 117 -c ~/.config/waybar/powermenu_config -s ~/.config/waybar/pmenu_style.css)

case $op in
        "  Poweroff")
                # systemctl poweroff
                shutdown -h now
                ;;
        "  Reboot")
                systemctl reboot
                ;;
        "  Suspend")
                systemctl suspend
                ;;
        "  Logout")
                killall Hyprland
                ;;
esac