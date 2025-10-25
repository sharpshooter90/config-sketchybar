#!/bin/bash

# Add event to subscribe
sketchybar --add event aerospace_workspace_change

source "$CONFIG_DIR/colors.sh" # Source the colors configuration

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
SECONDARY_SPACES=("5:Terminal:TERM:Terminal" "6:Comm:COM:Comm" "7:Music:MUSIC:Music")

# Function to configure workspace items
configure_workspace() {
  local SPACE=$1
  local GROUP=$2
  local DISPLAY=${3:-"all"}  # Default to "all" if not specified
  local IS_FIRST=${4:-false}  # Is this the first item in its group?
  local IS_LAST=${5:-false}   # Is this the last item in its group?

  # Extract components from the SPACE string (e.g., "1:Web:WEB:Arc")
  WORKSPACE_ID=${SPACE%%:*}           # Numeric ID (e.g., "1")
  REST=${SPACE#*:}                    # Everything after first colon (e.g., "Web:WEB:Arc")
  WORKSPACE_NAME=${REST%%:*}          # Custom name (e.g., "Web")
  TITLE=${REST#*:}                    # Remove custom name (e.g., "WEB:Arc")
  TITLE=${TITLE%%:*}                  # Extract title (e.g., "WEB")
  ICON=${REST##*:}                    # Extract icon (e.g., "Arc")

  # Define the click script to switch workspace using numeric ID
  local CLICK_SCRIPT="aerospace workspace '$WORKSPACE_ID' && sketchybar --trigger aerospace_workspace_change"
  local DISPLAY_SCRIPT="$PLUGIN_DIR/spaces.sh '$MAIN_DISPLAY' '$SECONDARY_DISPLAY'"
  local FOCUS_SCRIPT="$PLUGIN_DIR/aerospace.sh '$WORKSPACE_ID'"
  local SHOW_ALL_WINDOWS_APP_ICONS_SCRIPT="$PLUGIN_DIR/show_all_windows_app_icons.sh '$WORKSPACE_ID'"

  # Set padding values based on position
  local LEFT_PADDING=6
  local RIGHT_PADDING=6
  
  # First item should have no left padding
  if [ "$IS_FIRST" = true ]; then
    LEFT_PADDING=0
  fi
  
  # Last item should have no right padding
  if [ "$IS_LAST" = true ]; then
    RIGHT_PADDING=0
  fi

  #FIXME: Re rendering the workspace windows icons every time the workspace changes might be a bit much.
  #FIXME: Need to figure out how we can render the focused indication in the end 
  
  # Add and configure the workspace item in sketchybar
  sketchybar --add item "workspace.$WORKSPACE_NAME" left \
    --subscribe "workspace.$WORKSPACE_NAME" aerospace_workspace_change display_change space_windows_change \
    --set "workspace.$WORKSPACE_NAME" \
    icon.font="sketchybar-app-font:Regular:13.0" \
    icon.color=$WORKSPACE_ICON_COLOR \
    label="$TITLE" \
    label.color=$WORKSPACE_LABEL_COLOR \
    label.y_offset=1.5 \
    icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$ICON")" \
    click_script="$CLICK_SCRIPT" \
    script="$FOCUS_SCRIPT && $DISPLAY_SCRIPT && $SHOW_ALL_WINDOWS_APP_ICONS_SCRIPT" \
    background.drawing=off \
    padding_left=4 \
    padding_right=4 \
    background.padding_left=$LEFT_PADDING \
    background.padding_right=$RIGHT_PADDING \
    label.padding_left=4 \
    label.padding_right=4 \
    associated_display=$DISPLAY
}

if [ "$DISPLAY_COUNT" -eq 1 ]; then
  # Only one display available: assign all workspaces to the single display.
  COMBINED_SPACES=("${MAIN_SPACES[@]}" "${SECONDARY_SPACES[@]}")
  TOTAL_SPACES=${#COMBINED_SPACES[@]}
  
  for i in "${!COMBINED_SPACES[@]}"; do
    IS_FIRST=false
    IS_LAST=false
    
    # Check if first or last in group
    if [ $i -eq 0 ]; then
      IS_FIRST=true
    fi
    if [ $i -eq $((TOTAL_SPACES-1)) ]; then
      IS_LAST=true
    fi
    
    configure_workspace "${COMBINED_SPACES[$i]}" "all" "$MAIN_DISPLAY" "$IS_FIRST" "$IS_LAST"
  done
  
  # Create a single bracket for all workspaces
  workspace_args=""
  for space in "${COMBINED_SPACES[@]}"; do
    IFS=':' read -r _ name _ _ <<< "$space"
    workspace_args+=" workspace.$name"
  done

  sketchybar --add bracket all_spaces \
             $workspace_args \
             --set all_spaces \
             background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR \
             background.corner_radius=5 \
             background.height=26 \
             associated_display=$MAIN_DISPLAY
else
  # Two displays: assign main spaces to MAIN_DISPLAY and secondary spaces to SECONDARY_DISPLAY.
  # Configure main spaces
  MAIN_COUNT=${#MAIN_SPACES[@]}
  for i in "${!MAIN_SPACES[@]}"; do
    IS_FIRST=false
    IS_LAST=false
    
    # Check if first or last in main group
    if [ $i -eq 0 ]; then
      IS_FIRST=true
    fi
    if [ $i -eq $((MAIN_COUNT-1)) ]; then
      IS_LAST=true
    fi
    
    configure_workspace "${MAIN_SPACES[$i]}" "main" "$MAIN_DISPLAY" "$IS_FIRST" "$IS_LAST"
  done
  
  # Configure secondary spaces
  SECONDARY_COUNT=${#SECONDARY_SPACES[@]}
  for i in "${!SECONDARY_SPACES[@]}"; do
    IS_FIRST=false
    IS_LAST=false
    
    # Check if first or last in secondary group
    if [ $i -eq 0 ]; then
      IS_FIRST=true
    fi
    if [ $i -eq $((SECONDARY_COUNT-1)) ]; then
      IS_LAST=true
    fi
    
    configure_workspace "${SECONDARY_SPACES[$i]}" "secondary" "$SECONDARY_DISPLAY" "$IS_FIRST" "$IS_LAST"
  done

  # Create brackets: one for main spaces and one for secondary spaces.
  # First, build the workspace arguments string
  workspace_args=""
  for space in "${MAIN_SPACES[@]}"; do
    IFS=':' read -r _ name _ _ <<< "$space"
    workspace_args+=" workspace.$name"
  done

  # Add the bracket with the workspace arguments
  sketchybar --add bracket main_spaces \
             $workspace_args \
             --set main_spaces \
             background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR \
             background.corner_radius=5 \
             background.height=26 \
             padding_left=0 \
             padding_right=0 \
             background.padding_left=0 \
             background.padding_right=0 \
             icon.padding_left=0 \
             icon.padding_right=0 \
             label.padding_left=0 \
             label.padding_right=0 \
             associated_display=$MAIN_DISPLAY

  sketchybar --add bracket secondary_spaces \
             workspace.Terminal \
             workspace.Comm \
             workspace.Music \
             --set secondary_spaces \
             background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR \
             background.corner_radius=5 \
             background.height=26 \
             padding_left=0 \
             padding_right=0 \
             background.padding_left=0 \
             background.padding_right=0 \
             icon.padding_left=0 \
             icon.padding_right=0 \
             label.padding_left=0 \
             label.padding_right=0 \
             associated_display=$SECONDARY_DISPLAY
fi

# One method that I wanted to actually do is to have one item and create two brackets and show and hide them based on the display.
# the second way is actually add two items then display it conditionally for the displays based on the displays
# I think the second way is the better way to do it. lets try it.


# first lets create a workspace mapping for both displays using main spaces and secondary spaces
