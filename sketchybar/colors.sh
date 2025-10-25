#!/bin/bash

# Available themes: oxocarbon, teal, gray, purple, red, blue, green, orange, yellow
THEME="${SKETCHYBAR_THEME:-yellow}"

# Common colors
export WHITE=0xffffffff

# Load the selected theme
THEME_DIR="$CONFIG_DIR/themes"
if [ -f "$THEME_DIR/$THEME.sh" ]; then
  source "$THEME_DIR/$THEME.sh"
else
  echo "Theme '$THEME' not found. Using default oxocarbon."
  source "$THEME_DIR/oxocarbon.sh"
fi

# Set default for ITEM_BG_PRIMARY_COLOR if not defined by theme
if [ -z "$ITEM_BG_PRIMARY_COLOR" ]; then
  export ITEM_BG_PRIMARY_COLOR=0x40ffffff
fi

# Set default for TEXT_COLOR if not defined by theme
if [ -z "$TEXT_COLOR" ]; then
  export TEXT_COLOR=$WHITE
fi

# Set default for ACTIVE_WORKSPACE_SECONDARY_BG_COLOR if not defined by theme
if [ -z "$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR" ]; then
  export ACTIVE_WORKSPACE_SECONDARY_BG_COLOR=$ITEM_BG_COLOR
fi

# Derived colors
export ACTIVE_WORKSPACE_BG_COLOR=$ITEM_BG_PRIMARY_COLOR
export ACTIVE_WORKSPACE_BORDER_COLOR=$ACCENT_COLOR

# Workspace colors - derived from theme
export WORKSPACE_ICON_COLOR=$ACCENT_COLOR
export WORKSPACE_ICON_SECONDARY_COLOR=$WHITE
export WORKSPACE_LABEL_COLOR=$ACCENT_COLOR
export WORKSPACE_LABEL_SECONDARY_COLOR=$WHITE
export WORKSPACE_ICON_COLOR_ACTIVE=$ACCENT_COLOR
export WORKSPACE_LABEL_COLOR_ACTIVE=$ACCENT_COLOR
export WORKSPACE_ITEM_BORDER_ACTIVE_COLOR=$ACCENT_COLOR
