# stylegen

```yaml
# Name of the design system. Defaults to "Theme".
# Feel free to use your company name, name of product,
# or name of your design system.
# e.g.: Primer, Material, Polaris, etc.
system_name: "Theme"

# Path of generated Swift file.
output_path: "Colors.swift"

# Key-value pairs of theme colors.
colors:

  accent: # Keys will be used as color names.
    color: "#00BFC2" # Hex color

  text_primary:
    light: # Value for light mode
      color: "#000000"
      # Optionally you can specify an alpha value.
      # Defaults to `1.0`.
      alpha: 0.95
    dark: # Value for dark mode
      color: "#FFFFFF"

  text_secondary:
    light:
      color: "#000000"
      alpha: 0.4
    dark:
      color: "#FFFFFF"
      alpha: 0.6

  primary_background:
    light:
      color: "#FFFFFF"
    dark:
      base: # Value for base (non-elevated) level
        color: "#0D0D0D"
      elevated: # Value for elevated level
        color: "#191D1D"
```
