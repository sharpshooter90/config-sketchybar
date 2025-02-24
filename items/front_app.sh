#!/bin/bash

# Add event for monitor focus changes
sketchybar --add event monitor_focus

DISPLAY_COUNT=$(sketchybar --query displays | jq 'length')

if [ "$DISPLAY_COUNT" -eq 1 ]; then
  MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
  sketchybar --add item front_app_main left \
    --set front_app_main background.color=$ACCENT_COLOR \
      icon.color=$BAR_COLOR \
      icon.font="sketchybar-app-font:Regular:16.0" \
      label.color=$BAR_COLOR \
      associated_display=$MAIN_DISPLAY \
      script="$PLUGIN_DIR/front_app.sh" \
      --subscribe front_app_main front_app_switched monitor_focus
else
  MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[1].DirectDisplayID')
  SECONDARY_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
  sketchybar --add item front_app_main left \
    --set front_app_main background.color=$ACCENT_COLOR \
      icon.color=$BAR_COLOR \
      icon.font="sketchybar-app-font:Regular:16.0" \
      label.color=$BAR_COLOR \
      associated_display=$MAIN_DISPLAY \
      script="$PLUGIN_DIR/front_app.sh" \
      --subscribe front_app_main front_app_switched monitor_focus

  sketchybar --add item front_app_secondary left \
    --set front_app_secondary background.color=$ACCENT_COLOR \
      icon.color=$BAR_COLOR \
      icon.font="sketchybar-app-font:Regular:16.0" \
      label.color=$BAR_COLOR \
      associated_display=$SECONDARY_DISPLAY \
      script="$PLUGIN_DIR/front_app.sh" \
      --subscribe front_app_secondary front_app_switched monitor_focus
fi
