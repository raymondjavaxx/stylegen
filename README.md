# stylegen

A CLI utility that allows managing the colors used in an iOS app from a centralized YAML file in a type-safe way.

## Installing

For now you will have to clone this repository and and run `rake install`.

```shell
git clone https://github.com/raymondjavaxx/stylegen.git
cd stylegen
rake install
```

\* This will change once I start distributing the tool as a Ruby gem.

## How to use

Create a `theme.yaml` file in the root of your project. You can use the following YAML file as a starting point:

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

After creating the theme file run:

```shell
$ stylegen
```

This will generate a Swift file that you can add to your target. The generated file will contain all the colors and utility methods for referencing the colors.

In places where you normally do:

```swift
self.backgroundColor = UIColor(named: "AccentColor")
```

Now you can just do:

```swift
self.backgroundColor = .theme(.accent)
```

The `.theme()` static method serves as a namespace, to easily distinguish between UIKit's built-in colors and our custom colors. The name of the namespacing function is inferred from the `system_name` property in the YAML file.

## TODO

* `$ stylegen init` command
* Option to specify target frameworks: AppKit, UIKit, Core Graphics, and SwiftUI
* SwiftUI support
* AppKit support
