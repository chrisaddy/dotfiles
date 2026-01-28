# Dotfiles Theming System Specification

This document defines a unified theming system for syncing color themes across all terminal applications.

## Quick Start

```bash
# Create a new theme from an image (Claude Code command)
/theme

# Switch themes
theme-switch tokyonight
theme-switch cool-ice

# List available themes
theme-switch --list

# Show current theme
theme-switch --current
```

## Overview

The system uses a single source-of-truth for color palettes, with a script that generates app-specific configs. Themes are defined in TOML format and applied via `theme-switch <theme-name>`.

### Claude Code Integration

- **`/theme`** - Interactive command to create themes from reference images
  - Paste any image (palette, screenshot, artwork)
  - Claude extracts colors and maps to semantic roles
  - Generates the theme TOML file
  - Optionally applies immediately

## Directory Structure

```
dotfiles/
├── themes/
│   ├── tokyonight.toml      # Tokyo Night theme definition
│   ├── cool-ice.toml        # Custom theme example
│   └── ...                  # Additional themes
├── theme                    # Current theme name (single line, e.g., "cool-ice")
├── bin/
│   └── theme-switch         # Theme switching script
└── [app configs...]         # Generated/updated by theme-switch
```

## Theme File Format

Each theme is a TOML file with the following structure:

```toml
# themes/example.toml

[meta]
name = "Example Theme"
variant = "dark"  # "dark" or "light"

[palette]
# Core colors
bg = "#1a1b26"           # Main background
bg_dark = "#16161e"      # Darker background (sidebars, popups)
bg_light = "#232433"     # Lighter background (selections, highlights)
fg = "#c0caf5"           # Main foreground/text
fg_dark = "#a9b1d6"      # Dimmed foreground
fg_muted = "#565f89"     # Comments, subtle text

# Accent colors
accent = "#7aa2f7"       # Primary accent (cursors, focus)
secondary = "#bb9af7"    # Secondary accent

# Semantic colors
red = "#f7768e"
orange = "#ff9e64"
yellow = "#e0af68"
green = "#9ece6a"
cyan = "#7dcfff"
blue = "#7aa2f7"
magenta = "#bb9af7"

# Bright variants (for terminal ANSI colors)
bright_red = "#ff7a93"
bright_orange = "#ffb86c"
bright_yellow = "#f0c674"
bright_green = "#b9f27c"
bright_cyan = "#89ddff"
bright_blue = "#82aaff"
bright_magenta = "#c792ea"

# UI elements
border = "#3b4261"
selection = "#33467c"
cursor = "#c0caf5"
cursor_text = "#1a1b26"

# Git/diff colors (optional, defaults to semantic colors)
git_add = "#9ece6a"
git_change = "#e0af68"
git_delete = "#f7768e"

# Terminal ANSI colors (0-15)
# If not specified, derived from palette above
[terminal]
black = "#15161e"
red = "#f7768e"
green = "#9ece6a"
yellow = "#e0af68"
blue = "#7aa2f7"
magenta = "#bb9af7"
cyan = "#7dcfff"
white = "#a9b1d6"
bright_black = "#414868"
bright_red = "#ff7a93"
bright_green = "#b9f27c"
bright_yellow = "#f0c674"
bright_blue = "#82aaff"
bright_magenta = "#c792ea"
bright_cyan = "#89ddff"
bright_white = "#c0caf5"
```

## Supported Applications

### 1. Neovim

**Config location**: `nvim/.config/nvim/lua/themes/`

**Implementation**:
- `themes/init.lua` - Theme loader that reads current theme
- `themes/palettes/<theme>.lua` - Lua table with colors
- `plugins/colors.lua` - Updated to use custom theme or delegate to theme plugin

**Theme application**:
- For built-in themes (tokyonight), use the plugin with correct variant
- For custom themes, apply via `vim.api.nvim_set_hl()` calls

### 2. Ghostty

**Config location**: `ghostty/.config/ghostty/config`

**Implementation**:
- For preset themes: `theme = <preset-name>`
- For custom themes: inline color definitions

**Custom theme format**:
```
background = #1a1b26
foreground = #c0caf5
cursor-color = #c0caf5
selection-background = #33467c
selection-foreground = #c0caf5

palette = 0=#15161e
palette = 1=#f7768e
palette = 2=#9ece6a
palette = 3=#e0af68
palette = 4=#7aa2f7
palette = 5=#bb9af7
palette = 6=#7dcfff
palette = 7=#a9b1d6
palette = 8=#414868
palette = 9=#ff7a93
palette = 10=#b9f27c
palette = 11=#f0c674
palette = 12=#82aaff
palette = 13=#c792ea
palette = 14=#89ddff
palette = 15=#c0caf5
```

### 3. Tmux

**Config location**: `tmux/.tmux.conf`

**Implementation**:
- Status bar colors
- Pane border colors
- Message colors

**Theme variables applied**:
```bash
# Status bar
set -g status-style "bg=#{bg_dark},fg=#{fg_dark}"
set -g status-left-style "bg=#{accent},fg=#{bg}"
set -g status-right-style "bg=#{bg_light},fg=#{fg}"

# Pane borders
set -g pane-border-style "fg=#{border}"
set -g pane-active-border-style "fg=#{accent}"

# Messages
set -g message-style "bg=#{selection},fg=#{fg}"
```

### 4. Bat

**Config location**: `bat/.config/bat/config`

**Implementation**:
- Uses preset theme names that match our themes
- Fallback to closest match for custom themes

**Supported preset mappings**:
- tokyonight → `TwoDark` or custom bat theme
- Custom themes may require generating a `.tmTheme` file

### 5. Starship

**Config location**: `starship/.config/starship/starship.toml`

**Implementation**:
- Prompt character colors
- Module-specific colors (git, directory, etc.)

**Theme variables applied**:
```toml
[character]
success_symbol = "[➜](bold fg:green)"
error_symbol = "[➜](bold fg:red)"

[directory]
style = "bold fg:accent"

[git_branch]
style = "bold fg:magenta"
```

### 6. fzf-lua (Neovim)

**Config location**: `nvim/.config/nvim/lua/plugins/fzf.lua`

**Implementation**:
- Window border colors
- Preview window colors
- Highlight colors

### 7. Lazygit

**Config location**: `lazygit/.config/lazygit/config.yml`

**Implementation**:
- UI colors in `gui.theme` section
- Border colors
- Selected line colors

**Theme format**:
```yaml
gui:
  theme:
    activeBorderColor:
      - "#{accent}"
      - bold
    inactiveBorderColor:
      - "#{border}"
    selectedLineBgColor:
      - "#{selection}"
```

### 8. Bottom (btm)

**Config location**: `bottom/.config/bottom/bottom.toml`

**Implementation**:
- Widget colors
- Graph colors
- Border colors

## theme-switch Script

**Location**: `bin/theme-switch`

**Usage**:
```bash
theme-switch <theme-name>    # Switch to theme
theme-switch --list          # List available themes
theme-switch --current       # Show current theme
theme-switch --preview       # Preview theme without applying
```

**Behavior**:
1. Validate theme exists in `themes/` directory
2. Parse theme TOML file
3. Generate/update config for each supported app
4. Write theme name to `theme` file
5. Optionally reload running applications:
   - Neovim: send command via nvim socket
   - Tmux: `tmux source-file`
   - Ghostty: requires restart

## Adding a New Theme

1. Create `themes/<theme-name>.toml` with required palette
2. Run `theme-switch <theme-name>`

**Minimum required colors**:
- `bg`, `fg`, `accent`
- `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`

Missing colors will be derived:
- `bg_dark` = darken(bg, 10%)
- `bg_light` = lighten(bg, 10%)
- `fg_dark` = darken(fg, 15%)
- `fg_muted` = mix(fg, bg, 50%)
- `bright_*` = lighten(color, 15%)

## Adding a New Application

1. Add section to this spec with config location and format
2. Update `theme-switch` script with new generator function
3. Add app config to appropriate stow directory

## Theme Presets

### Tokyo Night
- **File**: `themes/tokyonight.toml`
- **Variant**: dark
- **Neovim**: Uses `folke/tokyonight.nvim` plugin directly
- **Ghostty**: Uses built-in `TokyoNight Storm` preset

### Cool Ice (Template)
- **File**: `themes/cool-ice.toml`
- **Variant**: dark
- **Description**: Custom cool-toned theme (user-defined)

## Implementation Notes

### Color Format
- All colors in hex format: `#rrggbb`
- No alpha channel support (apps handle transparency separately)

### Stow Integration
- Generated configs live in stow directories
- `stow -R <app>` after theme switch if symlinks break

### Dependencies
- `yq` or `dasel` for TOML parsing in shell script
- Alternatively, implement in Python/Lua for better TOML support

### Neovim Special Handling
For themes with native Neovim plugin support (tokyonight, catppuccin, etc.):
- Use the plugin directly instead of manual highlight groups
- Only use manual highlights for truly custom themes

This keeps syntax highlighting, LSP, and treesitter colors correct.
