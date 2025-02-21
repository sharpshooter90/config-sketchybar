#!/bin/bash

# Add the Apple logo item to the left side
sketchybar \
  --add item apple.logo left \
  --set apple.logo icon=󰀵 \
  icon.font="JetBrainsMono Nerd Font:Bold:18.0" \
  icon.padding_right=8 \
  icon.y_offset=2 \
  icon.color=$WHITE \
  label.drawing=off \
  popup.height=35 \
  popup.background.drawing=off \
  background.drawing=off \
  click_script="sketchybar -m --set \$NAME popup.drawing=toggle"

# Set default padding for items
sketchybar \
  --default icon.padding_right=4 \
  icon.font="JetBrainsMono Nerd Font:Bold:16.0" \
  icon.y_offset=0 \
  icon.color=$WHITE \
  label.color=$WHITE \
  background.height=25 \
  background.corner_radius=5 \
  background.padding_left=5 \
  background.padding_right=5

# Add the Sleep item to the popup menu
sketchybar \
  --add item apple.sleep popup.apple.logo \
  --set apple.sleep icon=󰒲 \
  label="Sleep" \
  icon.y_offset=0 \
  background.color=$ITEM_BG_COLOR \
  background.drawing=on \
  click_script="osascript -e 'tell application \"System Events\" to sleep'; \
                                   sketchybar -m --set apple.logo popup.drawing=off"

# Add the Restart item to the popup menu
sketchybar \
  --add item apple.restart popup.apple.logo \
  --set apple.restart icon=󰜉 \
  label="Restart" \
  icon.y_offset=0 \
  background.color=$ITEM_BG_COLOR \
  background.drawing=on \
  click_script="osascript -e 'tell application \"System Events\" to restart'; \
                                    sketchybar -m --set apple.logo popup.drawing=off"

# Add the Shut Down item to the popup menu
sketchybar \
  --add item apple.shutdown popup.apple.logo \
  --set apple.shutdown icon=󰐥 \
  label="Shut Down" \
  icon.y_offset=0 \
  background.color=$ITEM_BG_COLOR \
  background.drawing=on \
  click_script="osascript -e 'tell application \"System Events\" to shut down'; \
                                      sketchybar -m --set apple.logo popup.drawing=off"
