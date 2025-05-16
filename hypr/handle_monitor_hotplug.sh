#!/bin/sh

handle() {
    case $1 in monitoradded*)
        hyprctl dispatch moveworkspacetomonitor "1 2"
        hyprctl dispatch moveworkspacetomonitor "2 2"
        hyprctl dispatch moveworkspacetomonitor "3 2"
        hyprctl dispatch moveworkspacetomonitor "4 2"
        hyprctl dispatch moveworkspacetomonitor "5 2"
    esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do handle "$line"; done