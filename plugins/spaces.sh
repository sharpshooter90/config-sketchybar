#!/usr/bin/env bash
# This plugin acts as a common listener for Sketchybar events
# and updates your workspaces accordingly.
#
# Sketchybar passes the triggering event in the SENDER env variable.
#
# To use, point your workspace item's script to this plugin.
# For example, in your item configuration:
#   script="$PLUGIN_DIR/spaces.sx"
# and subscribe to events (display_change, system_woke, etc.)

case "${SENDER}" in
    "display_change")
        echo "Display change detected: active display $INFO at $(date)" >> /tmp/sketchybar_spaces.log
        sketchybar --reload
        ;;
    *)
        # Ignore all other events
        ;;
esac 

