#!/bin/bash

# Add event to subscribe
sketchybar --add event aerospace_workspace_change

# Define your spaces with names, titles, icons, and corresponding Aerospace workspace IDs
MAIN_SPACES=("1:Web:WEB:Arc" "2:Des:DES:Figma" "3:Obsidian:WRITING:Obsidian" "4:Code:CODE:Code")
SECONDARY_SPACES=("5:Terminal:TERM:Terminal" "6:Others:OTHERS:Others")

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

  # Add and configure the workspace item in sketchybar
  sketchybar --add item "workspace.$WORKSPACE_NAME" left \
    --subscribe "workspace.$WORKSPACE_NAME" aerospace_workspace_change \
    --set "workspace.$WORKSPACE_NAME" \
    icon.font="sketchybar-app-font:Regular:13.0" \
    label="$TITLE" \
    icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$ICON")" \
    click_script="$CLICK_SCRIPT" \
    script="$PLUGIN_DIR/aerospace.sh $WORKSPACE_ID" \
    background.color="$ACTIVE_WORKSPACE_COLOR" \
    background.border_color="$ACTIVE_WORKSPACE_COLOR" \
    associated_display=$DISPLAY
}

# Configure main workspaces (1-4) for display 1
for SPACE in "${MAIN_SPACES[@]}"; do
  configure_workspace "$SPACE" "main" "1"
done

# Configure secondary workspaces (5-6) for display 2
for SPACE in "${SECONDARY_SPACES[@]}"; do
  configure_workspace "$SPACE" "secondary" "2"
done

# Add brackets for main workspaces (1-4)
sketchybar --add bracket main_spaces \
           workspace.Web \
           workspace.Des \
           workspace.Obsidian \
           workspace.Code \
           --set main_spaces \
           background.color=0x40ffffff \
           background.corner_radius=5 \
           background.height=26 \
           associated_display=1

# Add brackets for secondary workspaces (5-6)
sketchybar --add bracket secondary_spaces \
           workspace.Terminal \
           workspace.Others \
           --set secondary_spaces \
           background.color=0x40808080 \
           background.corner_radius=5 \
           background.height=26 \
           associated_display=2