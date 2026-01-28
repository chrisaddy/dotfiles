# Theme Creation Command

Create a new color theme from a reference image or color palette.

## Instructions

When the user runs `/theme`, follow these steps:

### Step 1: Get Theme Name
Ask the user for a theme name (lowercase, hyphenated, e.g., "cool-ice", "forest-night").

### Step 2: Get Reference Image
Ask the user to paste a reference image. This can be:
- A color palette image
- A screenshot of a UI they like
- A photo or artwork for inspiration
- Any visual with colors they want to extract

### Step 3: Extract Colors
Analyze the image and identify:
1. **Dominant colors** - The main colors that define the palette
2. **Color roles** - Map colors to their semantic purpose

Extract and estimate hex values for:

**Core (required):**
- `bg` - Main background (usually the darkest or most neutral)
- `bg_dark` - Darker background variant (sidebars, popups)
- `bg_light` - Lighter background (selections, highlights)
- `fg` - Main text color (high contrast with bg)
- `fg_dark` - Dimmed text
- `fg_muted` - Comments, subtle text (low contrast)

**Accents (required):**
- `accent` - Primary accent (cursor, focus indicators)
- `secondary` - Secondary accent

**Semantic colors (required):**
- `red` - Errors, deletions
- `orange` - Warnings
- `yellow` - Warnings, search highlights
- `green` - Success, additions
- `cyan` - Info, links
- `blue` - Info, functions
- `magenta` - Special, keywords

**Derived (generate if not obvious from image):**
- `bright_*` variants - Lighten each semantic color ~15%
- `border` - Usually between bg and bg_light
- `selection` - Semi-transparent accent or distinct highlight
- `cursor` - Often same as fg or accent
- `cursor_text` - Opposite of cursor for visibility

### Step 4: Present the Palette
Show the user the extracted palette in a clear format:

```
Theme: <name>
Variant: dark/light

Background:    bg=#XXXXXX  bg_dark=#XXXXXX  bg_light=#XXXXXX
Foreground:    fg=#XXXXXX  fg_dark=#XXXXXX  fg_muted=#XXXXXX
Accents:       accent=#XXXXXX  secondary=#XXXXXX
Colors:        red=#XXXXXX  orange=#XXXXXX  yellow=#XXXXXX
               green=#XXXXXX  cyan=#XXXXXX  blue=#XXXXXX  magenta=#XXXXXX
```

Ask if they want to adjust any colors before saving.

### Step 5: Create Theme File
Write the theme to `themes/<name>.toml`:

```toml
[meta]
name = "<Display Name>"
variant = "dark"  # or "light"

[palette]
bg = "#XXXXXX"
bg_dark = "#XXXXXX"
bg_light = "#XXXXXX"
fg = "#XXXXXX"
fg_dark = "#XXXXXX"
fg_muted = "#XXXXXX"
accent = "#XXXXXX"
secondary = "#XXXXXX"
red = "#XXXXXX"
orange = "#XXXXXX"
yellow = "#XXXXXX"
green = "#XXXXXX"
cyan = "#XXXXXX"
blue = "#XXXXXX"
magenta = "#XXXXXX"
bright_red = "#XXXXXX"
bright_orange = "#XXXXXX"
bright_yellow = "#XXXXXX"
bright_green = "#XXXXXX"
bright_cyan = "#XXXXXX"
bright_blue = "#XXXXXX"
bright_magenta = "#XXXXXX"
border = "#XXXXXX"
selection = "#XXXXXX"
cursor = "#XXXXXX"
cursor_text = "#XXXXXX"

[terminal]
black = "#XXXXXX"
red = "#XXXXXX"
green = "#XXXXXX"
yellow = "#XXXXXX"
blue = "#XXXXXX"
magenta = "#XXXXXX"
cyan = "#XXXXXX"
white = "#XXXXXX"
bright_black = "#XXXXXX"
bright_red = "#XXXXXX"
bright_green = "#XXXXXX"
bright_yellow = "#XXXXXX"
bright_blue = "#XXXXXX"
bright_magenta = "#XXXXXX"
bright_cyan = "#XXXXXX"
bright_white = "#XXXXXX"
```

### Step 6: Offer to Apply
Ask if the user wants to apply the theme now using `theme-switch <name>`.

If yes, run: `~/dotfiles/bin/theme-switch <name>`

---

## Color Extraction Tips

When analyzing images:

1. **For dark themes**: Look for the darkest neutral as bg, lightest neutral as fg
2. **For light themes**: Invert - lightest as bg, darkest as fg
3. **Accent colors**: Usually the most saturated/vibrant color in the image
4. **Ensure contrast**: fg should have sufficient contrast with bg (aim for 7:1 ratio)
5. **Derive missing colors**: If image lacks a semantic color (e.g., no red), pick a complementary color that fits the palette mood

## Example Session

```
User: /theme

Claude: What would you like to name this theme? (lowercase, hyphenated)

User: cool-ice

Claude: Paste a reference image and I'll extract a color palette from it.

User: [pastes image]

Claude: I've analyzed your image. Here's the extracted palette:

Theme: cool-ice
Variant: dark

Background:    bg=#0a1628  bg_dark=#060f1a  bg_light=#122035
Foreground:    fg=#e0e8f0  fg_dark=#b8c4d0  fg_muted=#5a7088
Accents:       accent=#4fa8c7  secondary=#7b68ee
...

Would you like to adjust any colors, or save this palette?
```
