#!/usr/bin/env sh
INTERNAL="eDP-1"
EXTERNAL="HDMI-A-2"

# -H is font size(13px)*(2*num_options+1)
op=$(echo -e "  Main Screen Only\n  Second Screen Only\n  Extend\n  Mirror\n  Secondary Screen Side" | wofi -i -d -H 143 -c ~/.config/wofi/powermenu_config -s ~/.config/wofi/pmenu_style.css)

case $op in
        "  Main Screen Only")
                hyprctl --batch "keyword monitor $INTERNAL,preferred,0x0,auto ; keyword monitor $EXTERNAL,disable"
                ;;
        "  Second Screen Only")
                hyprctl --batch "keyword monitor $EXTERNAL,preferred,0x0,1 ; keyword monitor $INTERNAL,disable"
                ;;
        "  Extend")
                hyprctl --batch "keyword monitor $INTERNAL,preferred,0x0,auto ; keyword monitor $EXTERNAL,preferred,auto-left,1"
                ;;
        "  Mirror")
                # mirror off of the external monitor since external is likely higher res
                hyprctl --batch "keyword monitor $EXTERNAL,preferred,0x0,1 ; keyword monitor $INTERNAL,preferred,auto,1,mirror,$EXTERNAL"
                ;;
        "  Secondary Screen Side")
                # check if external monitor is connected
                if hyprctl monitors | grep --quiet $EXTERNAL; then
                        # check if there is -(minus) in the output of {hyprctl monitors}
                        # which would indicate that the external monitor is to the left of the internal monitor
                        # !!! will not work for up and down due to the regex
                        if hyprctl monitors | grep -qoP -- '-\d+x\-?\d+'; then
                                # move right
                                hyprctl keyword monitor "$EXTERNAL,preferred,auto-right,1"
                        else
                                hyprctl keyword monitor "$EXTERNAL,preferred,auto-left,auto"
                        fi
                else
                        hyprctl notify 3 4000 0 "fontsize:24 No External Monitor Connected"
                fi
                ;;
esac

#   if hyprctl monitors | grep --quiet $EXTERNAL_MONITOR; then
#     hyprctl keyword monitor "$EXTERNAL_MONITOR, disable"
#     hyprctl keyword monitor "$INTERNAL_MONITOR, preferred, 0, auto"
#   else
#     hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
#     hyprctl keyword monitor "$EXTERNAL_MONITOR, preferred, 0, auto"
#   fi
