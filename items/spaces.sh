#!/bin/bash

# Add event to subscribe
sketchybar --add event aerospace_workspace_change

# Define your spaces with names and corresponding Nerd Font icons
MAIN_SPACES=("Web:WEB:Arc" "Des:DES:Figma" "Obsidian:WRITING:Obsidian" "Code:CODE:Code")
SECONDARY_SPACES=("Terminal:TERM:Terminal" "Others:OTHERS:Others")

# Function to configure workspace items
configure_workspace() {
  local SPACE=$1
  local GROUP=$2
  local DISPLAY=${3:-"all"}  # Default to "all" if not specified
  
  WORKSPACE_NAME=${SPACE%%:*}  # Extract name (everything before ':')
  ICON=${SPACE##*:}           # Extract icon (everything after ':')
  
  # Extract the part between the colons
  TITLE=${SPACE#*:}           # Remove everything before the first colon
  TITLE=${TITLE%%:*}          # Now remove everything after the next colon

  sketchybar --add item "workspace.$WORKSPACE_NAME" left \
    --subscribe "workspace.$WORKSPACE_NAME" aerospace_workspace_change \
    --set "workspace.$WORKSPACE_NAME" \
    icon.font="sketchybar-app-font:Regular:16.0" \
    script="$PLUGIN_DIR/front_app.sh" \
    label="$TITLE" \
    icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$ICON")" \
    click_script="aerospace workspace $WORKSPACE_NAME" \
    script="$PLUGIN_DIR/aerospace.sh $WORKSPACE_NAME" \
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
