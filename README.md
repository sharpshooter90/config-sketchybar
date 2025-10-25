# macOS Dotfiles

Personal configuration from [adventureland.io](https://adventureland.io)

## Sketchybar Configuration

This repository contains a **themed Sketchybar configuration** with a structured approach to color schemes and theme management.

### Features

- **Dynamic Theme System**: Switch between 9 different color themes
- **Consistent Theme Application**: Standardized theme structure for community consistency
- **Easy Theme Switching**: Apply themes via `SKETCHYBAR_THEME` environment variable

### Available Themes

| Theme       | Description          | Primary Colors                         |
| ----------- | -------------------- | -------------------------------------- |
| `yellow`    | Bright yellow accent | Yellow (#f7fc17) on dark background    |
| `blue`      | Cool blue scheme     | Blue (#15bdf9) on navy background      |
| `oxocarbon` | Dark modern theme    | Light gray (#f2f4f8) on dark (#161616) |
| `teal`      | Teal accent colors   | Teal accent on dark background         |
| `gray`      | Neutral gray theme   | Gray tones                             |
| `purple`    | Purple accent theme  | Purple accent colors                   |
| `red`       | Red accent theme     | Red accent colors                      |
| `green`     | Green accent theme   | Green accent colors                    |
| `orange`    | Orange accent theme  | Orange accent colors                   |

### Usage

**Theme Switching Commands**:

1. **Using `aerospace-theme` command** (Recommended):

```bash
aerospace-theme yellow      # Switch to yellow theme
aerospace-theme blue        # Switch to blue theme
aerospace-theme oxocarbon  # Switch to dark theme
# ... and 6 other themes available
```

2. **Using environment variable**:

```bash
export SKETCHYBAR_THEME=yellow    # Default theme
export SKETCHYBAR_THEME=blue      # Blue theme
export SKETCHYBAR_THEME=oxocarbon # Dark theme
# ... and 6 other themes available
```

**Community Configuration Management**:

Use the `dot-files-community` command to manage community dotfiles:

```bash
# List all available community repos
dot-files-community list

# List repos with specific config type
dot-files-community list sketchybar

# Apply a community config
dot-files-community apply sketchybar adventureland.io

# Backup current config
dot-files-community backup sketchybar

# Restore from backup
dot-files-community restore sketchybar

# Show current config
dot-files-community current sketchybar
```

**Aerospace Integration**: This configuration is designed to work with [Aerospace](https://aerospace.app) window manager:

- Workspace switching via Aerospace commands
- Dynamic workspace indicators
- Aerospace workspace change events
- Multi-monitor support with Aerospace

**Configuration Details**:

- **Font**: JetBrainsMono Nerd Font
- **Bar Position**: Top
- **Height**: 40px
- **Theme System**: Command-based (`aerospace-theme`) or environment variable (`SKETCHYBAR_THEME`)

### Theme Structure

Each theme defines:

- `BAR_COLOR`: Main bar background color
- `ITEM_BG_COLOR`: Item background color
- `ACCENT_COLOR`: Primary accent color for icons and labels
- `ITEM_BG_PRIMARY_COLOR`: Primary item background (optional)

### Aerospace Integration Details

This configuration includes specialized Aerospace integration:

- **Workspace Management**: Pre-configured workspaces (Web, Design, Writing, Code, Terminal, Communication, Music)
- **Dynamic Icons**: Shows active application icons in workspace indicators
- **Multi-Monitor Support**: Handles display configuration changes automatically
- **Aerospace Commands**: Uses `aerospace workspace` and `aerospace list-monitors` for workspace switching
- **Event Handling**: Responds to `aerospace_workspace_change` events

### Custom Commands

This configuration includes two powerful custom commands for theme and configuration management:

#### `aerospace-theme` Command

A comprehensive theme switcher that:

- Switches themes across SketchyBar, Aerospace, and Borders
- Automatically detects active community configurations
- Updates both active and community config files
- Commits changes to git repositories
- Reloads all relevant services
- Supports 9 different color themes

#### `dot-files-community` Command

A community dotfiles manager that:

- Lists available community repositories
- Applies community configurations
- Backs up and restores configurations
- Manages multiple config types (sketchybar, aerospace, ghostty, tmux, fastfetch)
- Integrates with chezmoi for configuration management
- Automatically reloads services after changes

### Future Plans

**Enhanced User Experience**: Plans are in development for a more intuitive command interface:

- **`ricing Space Config`**: A streamlined command for applying community configurations with better UX
- **`ricing Space Theme`**: An enhanced theme switching experience with visual previews and better feedback
- **Interactive Mode**: Commands with interactive prompts and visual selections
- **Theme Previews**: Live preview of themes before applying
- **Configuration Wizards**: Guided setup for new users

These improvements will provide a more user-friendly experience while maintaining the powerful functionality of the current commands.

### Installation

The configuration includes a mechanism to copy theme files to Sketchybar's config location, ensuring proper theme application across the system.

**Prerequisites**:

- [Aerospace](https://aerospace.app) window manager installed
- Sketchybar installed and configured
- JetBrainsMono Nerd Font installed
- Custom commands installed in `~/.local/bin/`
