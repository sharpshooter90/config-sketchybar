#!/bin/bash

# Iterate through workspaces for all monitors and update each one with their active applications.
# If a workspace ID is passed as $1, only update that specific workspace

WORKSPACE_FILTER=$1
echo "Args: $WORKSPACE_FILTER"

# Get active monitors
MONITORS=$(aerospace list-monitors | awk '{print $1}')

# Define your spaces with names, titles, icons, and corresponding Aerospace workspace IDs
# These should match what's in spaces.sh
MAIN_SPACES=("1:Web:WEB:Arc" "2:Des:DES:Figma" "3:Obsidian:WRITING:Obsidian" "4:Code:CODE:Code")
SECONDARY_SPACES=("5:Terminal:TERM:Terminal" "6:Comm:COM:Comm")

# Function to get workspace name from ID
get_workspace_name() {
  local workspace_id=$1
  local workspace_name=""
  
  for space in "${MAIN_SPACES[@]}" "${SECONDARY_SPACES[@]}"; do
    local SPACE_ID=${space%%:*}
    if [ "$SPACE_ID" = "$workspace_id" ]; then
      local REST=${space#*:}
      workspace_name=${REST%%:*}
      break
    fi
  done
  
  echo "$workspace_name"
}

for monitor in $MONITORS; do
  echo "Monitor: $monitor"
  # Get all workspaces from current monitor
  WORKSPACES=$(aerospace list-workspaces --monitor "$monitor" --json | jq -r '.[].workspace')
  echo "Workspaces: $WORKSPACES"
  
  for workspace in $WORKSPACES; do
    # Skip if we're filtering for a specific workspace and this isn't it
    if [ ! -z "$WORKSPACE_FILTER" ] && [ "$workspace" != "$WORKSPACE_FILTER" ]; then
      continue
    fi
    
    # Get the workspace name that matches spaces.sh naming
    workspace_name=$(get_workspace_name "$workspace")
    
    # Skip if we couldn't find a matching workspace name
    if [ -z "$workspace_name" ]; then
      echo "Warning: No matching name found for workspace ID $workspace, skipping"
      continue
    fi
    
    # Get applications in current workspace
    WINDOWS_JSON=$(aerospace list-windows --monitor "$monitor" --workspace "$workspace" --json)
    echo "Debug: Workspace $workspace ($workspace_name), Raw JSON = $WINDOWS_JSON" >> /tmp/space_windows_debug.log
    
    # Extract application names
    WINDOWS=$(echo "$WINDOWS_JSON" | jq -r '.[] | .["app-name"]')
    echo "Debug: Workspace $workspace ($workspace_name), Parsed Windows = $WINDOWS" >> /tmp/space_windows_debug.log

    # Build the strip of icons or application names
    icon_strip=""
    for app in $WINDOWS; do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done

    # If there are no applications, use a dash or empty space
    if [ -z "$icon_strip" ]; then
      icon_strip=" —"
    fi

    echo "Debug: Workspace $workspace ($workspace_name), Final Icon Strip = $icon_strip" >> /tmp/space_windows_debug.log

    # Update SketchyBar with the workspace's application icons
    # Using workspace.NAME format to match spaces.sh
    sketchybar --set workspace."$workspace_name" icon="$icon_strip"
  done
done
