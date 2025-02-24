# FYI: Explanation of Sketchybar Spaces Listener and Dynamic Workspace Mapping

This document explains the design decisions behind our Sketchybar event handling specifically for display configuration changes, and how our updated logic reflects a streamlined approach to dynamic workspace mapping based on available displays.

## Background

Sketchybar uses events to trigger actions when system changes occur. A key event is:

- **display_change**: Fired when your display configuration changes (e.g., when you disconnect an external monitor). This event provides the new active display's identifier in the `$INFO` variable.

## Handling the display_change Event

Since display_change is a built-in event in Sketchybar, you can handle it directly within your item configuration. For example, you could simply subscribe an item to the event:

```bash
sketchybar --subscribe my_item display_change
```

Then, in your script, you can use `$INFO` to adjust your spaces accordingly. For simple actions, no additional plugin is required.

## Using a Dedicated Listener (Plugin) Approach

Our configuration, however, opts to use a dedicated listener item and an associated plugin script to manage display configuration changes. This approach provides several benefits such as separation of concerns, improved reusability, and scalability for future enhancements.

### Event Listener Setup

In our `items/spaces.sh` file, we set up the display_change event handling like so:

```bash
sketchybar --add event display_change

sketchybar --add item spaces_listener popup
sketchybar --set spaces_listener script="$PLUGIN_DIR/spaces.sh"
sketchybar --subscribe spaces_listener display_change
```

In the corresponding `plugins/spaces.sh` script, instead of reloading the entire configuration upon a display change, we now re-read the display configuration and selectively update only the workspace items and brackets with their correct associated display. For example:

```bash
case "${SENDER}" in
    "display_change")
        echo "Display change detected: active display $INFO at $(date)" >> /tmp/sketchybar_spaces.log

        # Re-read display configuration
        DISPLAY_COUNT=$(sketchybar --query displays | jq -r 'length')
        if [ "${DISPLAY_COUNT:-0}" -eq 1 ]; then
            MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
            handle_single_display "$MAIN_DISPLAY"
        else
            # Assume external monitor (BenQ) is at index 1 and built-in (Mac) is at index 0
            MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[1].DirectDisplayID')
            SECONDARY_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
            handle_dual_display "$MAIN_DISPLAY" "$SECONDARY_DISPLAY"
        fi
        ;;
    *)
        # Ignore all other events
        ;;
esac
```

## Dynamic Workspace Mapping Based on Display Count

Our configuration also dynamically maps workspaces based on the number of connected displays:

- **Single Display Scenario:**
  When only one display is available (for example, if you unplug your external monitor), all workspace items – including main (workspaces 1–4) and secondary (workspaces 5–6) – are assigned to that single display. In this case, a single bracket is created that groups all workspace items together.

- **Dual Display Scenario:**
  When two displays are available, we designate the external monitor (e.g., an external BenQ) as the **MAIN_DISPLAY** and the MacBook's built-in display as the **SECONDARY_DISPLAY**. Specifically, we assign:

  - The **MAIN_DISPLAY** is set to the second display (index 1), where four workspaces (workspaces 1–4) are shown.
  - The **SECONDARY_DISPLAY** is set to the first display (index 0) where the remaining two workspaces (workspaces 5–6) appear.

Workspace items are organized into two arrays:

- **MAIN_SPACES**: Workspaces 1 through 4
- **SECONDARY_SPACES**: Workspaces 5 and 6

Depending on the number of displays:

- In a single display setup, all workspaces are assigned to the same display and grouped under one bracket.
- In a dual display setup, main workspaces are mapped to the external monitor (MAIN_DISPLAY) and secondary workspaces to the MacBook display (SECONDARY_DISPLAY), with each group enclosed in its own bracket.

The display retrieval logic from our `items/spaces.sh` file demonstrates this mapping:

```bash
DISPLAY_COUNT=$(sketchybar --query displays | jq 'length')
if [ "$DISPLAY_COUNT" -eq 1 ]; then
  MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
  SECONDARY_DISPLAY=$MAIN_DISPLAY
else
  MAIN_DISPLAY=$(sketchybar --query displays | jq -r '.[1].DirectDisplayID')
  SECONDARY_DISPLAY=$(sketchybar --query displays | jq -r '.[0].DirectDisplayID')
fi
```

## Conclusion

While the display_change event is natively supported by Sketchybar and can be handled directly in an item, our plugin-based approach not only centralizes event logic but also enables dynamic workspace mapping based on available displays. This design ensures that your workspace layout adapts to your current monitor setup – grouping workspaces appropriately whether you have a single display or dual displays – and maintains a flexible, maintainable configuration for future enhancements.
