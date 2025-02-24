# FYI: Explanation of Sketchybar Spaces Listener Usage

This document explains the design decisions behind our Sketchybar event handling specifically for display configuration changes, and how our updated logic reflects a streamlined approach.

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

Our configuration, however, opts to use a dedicated listener item and an associated plugin script to manage display configuration changes. This approach, even for a single event like display_change, offers several benefits:

```bash
sketchybar --add event display_change

sketchybar --add item spaces_listener popup
sketchybar --set spaces_listener script="$PLUGIN_DIR/spaces.sh"
sketchybar --subscribe spaces_listener display_change
```

In the associated `plugins/spaces.sh` script, we react exclusively to the display_change event:

```bash
case "${SENDER}" in
    "display_change")
        echo "Display change detected: active display $INFO at $(date)" >> /tmp/sketchybar_spaces.log
        sketchybar --reload
        ;;
    *)
        # Ignore all other events
        ;;
esac
```

### Advantages of the Plugin Approach:

1. **Separation of Concerns**:

   - By moving event-handling logic into its own script, our configuration stays simple while centralizing the logic.

2. **Reusability & Maintainability**:

   - A dedicated plugin script can be reused across multiple configurations. As needs evolve, it's easier to update centralized logic than modify inline commands in various items.

3. **Scalability**:
   - Although our current use-case for display_change is straightforward, the plugin approach leaves room for future enhancements such as conditional adjustments based on `$INFO` without cluttering the configuration files.

## Conclusion

While the display_change event is natively supported by Sketchybar and can be handled directly in an item, our plugin-based approach provides clear separation, improved reusability, and scalability. This streamlined design focuses solely on reacting to display_change events, resulting in a more maintainable and flexible configuration.
