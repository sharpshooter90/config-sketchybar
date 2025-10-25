#!/bin/bash

# Add event for monitor focus changes
sketchybar --add event monitor_focus

DISPLAY_COUNT=$(sketchybar --query displays | jq 'length')

if [ "$DISPLAY_COUNT" -eq 1 ]; then
  # For single display setup, just create one front_app item
  MAIN_DISPLAY=1
  sketchybar --add item front_app_main left \
    --set front_app_main background.color=$ACCENT_COLOR \
      icon.color=$TEXT_COLOR \
      icon.font="sketchybar-app-font:Regular:16.0" \
      label.color=$TEXT_COLOR \
      associated_display=$MAIN_DISPLAY \
      script="$PLUGIN_DIR/front_app.sh" \
      --subscribe front_app_main front_app_switched monitor_focus
else
  # For multi-display setup, create separate front_app items for each display
  MAIN_DISPLAY=1
  SECONDARY_DISPLAY=2
  sketchybar --add item front_app_main left \
    --set front_app_main background.color=$ACCENT_COLOR \
      icon.color=$TEXT_COLOR \
      icon.font="sketchybar-app-font:Regular:16.0" \
      label.color=$TEXT_COLOR \
      associated_display=$MAIN_DISPLAY \
      script="$PLUGIN_DIR/front_app.sh" \
      --subscribe front_app_main front_app_switched monitor_focus

  sketchybar --add item front_app_secondary left \
    --set front_app_secondary background.color=$ACCENT_COLOR \
      icon.color=$TEXT_COLOR \
      icon.font="sketchybar-app-font:Regular:16.0" \
      label.color=$TEXT_COLOR \
      associated_display=$SECONDARY_DISPLAY \
      script="$PLUGIN_DIR/front_app.sh" \
      --subscribe front_app_secondary front_app_switched monitor_focus
fi
