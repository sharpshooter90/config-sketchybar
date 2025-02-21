#!/bin/bash

sketchybar --add item media right \
  --set media label.color=$ACCENT_COLOR \
  label.max_chars=33 \
  icon.padding_left=0 \
  icon=󰎇 \
  icon.color=$ACCENT_COLOR \
  background.drawing=off \
  click_script="aerospace workspace Music" \
  label.font="BigBlueTerm437 Nerd Font Propo:Regular:12.0" \
  script="$PLUGIN_DIR/media.sh" \
  --subscribe media media_change

#click_script="open -a Spotify" \

# TODO: Add slowing moving animation for the text
