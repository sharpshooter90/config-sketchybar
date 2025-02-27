#!/bin/bash

# Add event to subscribe
sketchybar --add event aerospace_workspace_change

# Add events to subscribe
# sketchybar --add event custom_display_change

# # Handle display changes by reloading sketchybar
# sketchybar --add item spaces_listener popup
# sketchybar --set spaces_listener script="$PLUGIN_DIR/spaces.sh"
# sketchybar --subscribe spaces_listener custom_display_change

# Retrieve display arrangement IDs from sketchybar
DISPLAY_COUNT=$(sketchybar --query displays | jq 'length')
if [ "$DISPLAY_COUNT" -eq 1 ]; then
  MAIN_DISPLAY=1
  SECONDARY_DISPLAY=1
else
  MAIN_DISPLAY=1
  SECONDARY_DISPLAY=2
fi

# Define your spaces with names, titles, icons, and corresponding Aerospace workspace IDs
MAIN_SPACES=("1:Web:WEB:Arc" "2:Des:DES:Figma" "3:Obsidian:WRITING:Obsidian" "4:Code:CODE:Code")
SECONDARY_SPACES=("5:Terminal:TERM:Terminal" "6:Comm:COM:Comm")

# Function to configure workspace items
configure_workspace() {
  local SPACE=$1
  local GROUP=$2
  local DISPLAY=${3:-"all"}  # Default to "all" if not specified

  # Extract components from the SPACE string (e.g., "1:Web:WEB:Arc")
  WORKSPACE_ID=${SPACE%%:*}           # Numeric ID (e.g., "1")
  REST=${SPACE#*:}                    # Everything after first colon (e.g., "Web:WEB:Arc")
  WORKSPACE_NAME=${REST%%:*}          # Custom name (e.g., "Web")
  TITLE=${REST#*:}                    # Remove custom name (e.g., "WEB:Arc")
  TITLE=${TITLE%%:*}                  # Extract title (e.g., "WEB")
  ICON=${REST##*:}                    # Extract icon (e.g., "Arc")

  # Define the click script to switch workspace using numeric ID
  local CLICK_SCRIPT="aerospace workspace '$WORKSPACE_ID' && sketchybar --trigger aerospace_workspace_change"
  local DISPLAY_SCRIPT="$PLUGIN_DIR/aerospace.sh '$WORKSPACE_ID' && $PLUGIN_DIR/spaces.sh '$MAIN_DISPLAY' '$SECONDARY_DISPLAY'"

  # Add and configure the workspace item in sketchybar
  sketchybar --add item "workspace.$WORKSPACE_NAME" left \
    --subscribe "workspace.$WORKSPACE_NAME" aerospace_workspace_change display_change \
    --set "workspace.$WORKSPACE_NAME" \
    icon.font="sketchybar-app-font:Regular:13.0" \
    label="$TITLE" \
    icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$ICON")" \
    click_script="$CLICK_SCRIPT" \
    script="$DISPLAY_SCRIPT" \
    background.color="$ACTIVE_WORKSPACE_COLOR" \
    background.border_color="$ACTIVE_WORKSPACE_COLOR" \
    associated_display=$DISPLAY
}

if [ "$DISPLAY_COUNT" -eq 1 ]; then
  # Only one display available: assign all workspaces to the single display.
  for SPACE in "${MAIN_SPACES[@]}" "${SECONDARY_SPACES[@]}"; do
    configure_workspace "$SPACE" "all" "$MAIN_DISPLAY"
  done
  
  # Create a single bracket for all workspaces
  sketchybar --add bracket all_spaces \
             workspace.Web \
             workspace.Des \
             workspace.Obsidian \
             workspace.Code \
             workspace.Terminal \
             workspace.Comm \
             --set all_spaces \
             background.color=$ACTIVE_WORKSPACE_BG_COLOR \
             background.corner_radius=5 \
             background.height=26 \
             associated_display=$MAIN_DISPLAY
else
  # Two displays: assign main spaces to MAIN_DISPLAY and secondary spaces to SECONDARY_DISPLAY.
  for SPACE in "${MAIN_SPACES[@]}"; do
    configure_workspace "$SPACE" "main" "$MAIN_DISPLAY"
  done
  for SPACE in "${SECONDARY_SPACES[@]}"; do
    configure_workspace "$SPACE" "secondary" "$SECONDARY_DISPLAY"
  done

  # Create brackets: one for main spaces and one for secondary spaces.
  sketchybar --add bracket main_spaces \
             workspace.Web \
             workspace.Des \
             workspace.Obsidian \
             workspace.Code \
             --set main_spaces \
             background.color=$ACTIVE_WORKSPACE_BG_COLOR \
             background.corner_radius=5 \
             background.height=26 \
             associated_display=$MAIN_DISPLAY
  
  sketchybar --add bracket secondary_spaces \
             workspace.Terminal \
             workspace.Comm \
             --set secondary_spaces \
             background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR \
             background.corner_radius=5 \
             background.height=26 \
             associated_display=$SECONDARY_DISPLAY
fi

# One method that I wanted to actually do is to have one item and create two brackets and show and hide them based on the display.
# the second way is actually add two items then display it conditionally for the displays based on the displays
# I think the second way is the better way to do it. lets try it.


# first lets create a workspace mapping for both displays using main spaces and secondary spaces