#!/bin/bash

source "$CONFIG_DIR/colors.sh"
STATE="$(echo "$INFO" | jq -r '.state')"
if [ "$STATE" = "playing" ]; then
  MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
  sketchybar --set $NAME label="$MEDIA" label.color=$WORKSPACE_LABEL_SECONDARY_COLOR icon.color=$WORKSPACE_ICON_SECONDARY_COLOR background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR drawing=on
else
  sketchybar --set $NAME drawing=off
fi
