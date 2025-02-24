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
    shift
    for item in "$@"; do
        sketchybar --set "$item" associated_display=$display_id
    done
}

# Handle the case where a single display is available
handle_single_display() {
    local display_id=$1
    # Update all workspace items
    update_workspace_items "$display_id" \
        workspace.Web workspace.Des workspace.Obsidian workspace.Code workspace.Terminal workspace.Others
    
    # Update the single bracket for all workspaces, if it exists
    sketchybar --set all_spaces associated_display=$display_id
}

# Handle the case where two displays are available
handle_dual_display() {
    local main_display=$1
    local secondary_display=$2
    
    # Update main workspace items (workspaces 1-4) to use the external monitor (main_display)
    update_workspace_items "$main_display" workspace.Web workspace.Des workspace.Obsidian workspace.Code
    
    # Update secondary workspace items (workspaces 5-6) to use the built-in display (secondary_display)
    update_workspace_items "$secondary_display" workspace.Terminal workspace.Others
    
    # Update the corresponding brackets
    sketchybar --set main_spaces associated_display=$main_display
    sketchybar --set secondary_spaces associated_display=$secondary_display
}

# React only to the display_change event
case "${SENDER}" in
    "display_change")
        echo "Display change detected: active display $INFO at $(date)" >> /tmp/sketchybar_spaces.log
        
        # Re-read display configuration
        DISPLAY_COUNT=$(sketchybar --query displays | jq -r 'length')
        if [ "${DISPLAY_COUNT:-0}" -eq 1 ]; then
            MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
            handle_single_display "$MAIN_DISPLAY"
        else
            # Assume external monitor (BenQ) is at index 1 and built-in (Mac) is at index 0
            MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[1].DirectDisplayID')
            SECONDARY_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
            handle_dual_display "$MAIN_DISPLAY" "$SECONDARY_DISPLAY"
        fi
        ;;
    *)
        # Ignore all other events
        ;;
esac 

