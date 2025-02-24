#!/bin/sh

# Function to get clean monitor ID
get_monitor_id() {
  echo "$1" | cut -d '|' -f 1 | tr -d ' '
}

# Function to update item visibility based on focused monitor
update_visibility() {
  local name=$1
  local item_display=$2
  local focused_monitor=$3
  
  # Clean up monitor IDs for comparison
  local clean_item_display=$(get_monitor_id "$item_display")
  local clean_focused_monitor=$(get_monitor_id "$focused_monitor")
  
  if [ "$clean_item_display" = "$clean_focused_monitor" ]; then
    sketchybar --set "$name" drawing=on
    return 0
  else
    sketchybar --set "$name" drawing=off
    return 1
  fi
}

# Get the focused monitor from aerospace
FOCUSED_MONITOR=$(aerospace list-monitors --focused)

# Get the associated display for the triggered item
ITEM_DISPLAY=$(sketchybar --query "$NAME" | jq -r '.associated_display // empty')

# If ITEM_DISPLAY is empty, set it based on the item name
if [ -z "$ITEM_DISPLAY" ]; then
  if [ "$NAME" = "front_app_main" ]; then
    ITEM_DISPLAY="2"  # Main display
  else
    ITEM_DISPLAY="1"  # Secondary display
  fi
fi

case "$SENDER" in
  "front_app_switched")
    # Check if $INFO contains a colon
    if echo "$INFO" | grep -q ':'; then
      EVENT_DISPLAY=$(echo "$INFO" | cut -d ':' -f 1)
      APP_NAME=$(echo "$INFO" | cut -d ':' -f 2-)
    else
      EVENT_DISPLAY="$ITEM_DISPLAY"
      APP_NAME="$INFO"
    fi
    
    # Update visibility first
    if update_visibility "$NAME" "$ITEM_DISPLAY" "$FOCUSED_MONITOR"; then
      # Only update app info if this is the correct display for the event
      if [ "$(get_monitor_id "$ITEM_DISPLAY")" = "$(get_monitor_id "$EVENT_DISPLAY")" ]; then
        ICON="$($CONFIG_DIR/plugins/icon_map_fn.sh "$APP_NAME")"
        sketchybar --set "$NAME" label="$APP_NAME" icon="$ICON"
      fi
    fi
    ;;
    
  "monitor_focus")
    update_visibility "$NAME" "$ITEM_DISPLAY" "$FOCUSED_MONITOR"
    ;;
esac
