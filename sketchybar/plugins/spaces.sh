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

# Helper function to update a list of workspace items with a given display ID
update_workspace_items() {
    local display_id=$1
    if [ -z "$display_id" ]; then
        echo "Error: No display ID provided"
        return 1
    fi
    shift
    if [ $# -eq 0 ]; then
        echo "Warning: No workspace items provided to update"
        return 0
    fi
    # Use an array to store workspace items
    local -a workspace_items=("$@")
    for item in "${workspace_items[@]}"; do
        sketchybar --set "$item" associated_display=$display_id
    done
}

MAIN_DISPLAY=$1
SECONDARY_DISPLAY=$2


# Handle the case where a single display is available
handle_single_display() {
    # Update all workspace items
    update_workspace_items "$MAIN_DISPLAY" \
        "workspace.Web" "workspace.Des" "workspace.Obsidian" "workspace.Code" "workspace.Terminal" "workspace.Comm" "workspace.Music"
    
    # Update the single bracket for all workspaces, if it exists
    sketchybar --set all_spaces associated_display=$MAIN_DISPLAY
}

# Handle the case where two displays are available
handle_dual_display() {
    # Update main workspace items (workspaces 1-4) to use the external monitor (main_display)
    update_workspace_items "$MAIN_DISPLAY" "workspace.Web" "workspace.Des" "workspace.Obsidian" "workspace.Code"
    
    # Update secondary workspace items (workspaces 5-6) to use the built-in display (secondary_display)
    update_workspace_items "$SECONDARY_DISPLAY" "workspace.Terminal" "workspace.Comm" "workspace.Music"
    
    # Update the corresponding brackets
    sketchybar --set main_spaces \
        associated_display=$MAIN_DISPLAY
    sketchybar --set secondary_spaces \
        associated_display=$SECONDARY_DISPLAY
}

# React only to the display_change event
case "${SENDER}" in
    "display_change")
        # Query both sketchybar's display count and system display count to detect changes
        # We check both since sketchybar may not be immediately in sync with system changes
        # This ensures we handle display changes reliably and don't miss the first instance
        # of a display being connected/disconnected
        # Get current display count and call appropriate function
        #INFO: this can be used to get more display information `system_profiler SPDisplaysDataType`
        DISPLAY_COUNT=$(sketchybar --query displays | jq '. | length')
        if [ "$DISPLAY_COUNT" -eq 1 ]; then
            handle_single_display
        elif [ "$DISPLAY_COUNT" -eq 2 ]; then
            handle_dual_display
        fi
        ;;
    *)
        # Ignore all other events
        ;;
esac
