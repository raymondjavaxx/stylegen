# stylegen

A CLI utility for managing the colors used in an iOS/macOS app from a centralized YAML file in a type-safe way.

![CI](https://github.com/raymondjavaxx/stylegen/workflows/CI/badge.svg?branch=master)

## Installing

You can install `stylegen` manually by running:

```shell
$ gem install stylegen
```

Or by adding the following entry to your [Gemfile](https://guides.cocoapods.org/using/a-gemfile.html), then running `$ bundle install`.

```ruby
gem "stylegen"
```

## How to use

To use stylegen in your project, you will need to create a `theme.yaml` file at the root of the project by executing:

```shell
$ stylegen init
```

The generated YAML file will look similar to this:

```yaml
# Name of the design system. Defaults to "Theme".
# Feel free to use your company name, name of product,
# or name of your design system.
# e.g.: Primer, Material, Polaris, etc.
# system_name: "Theme"

# Path of generated Swift file.
output_path: "Colors.swift"

# UI frameworks to support.
# frameworks:
#   - UIKit
#   - AppKit

# Enables SwiftUI support.
# swiftui: false

# Key-value pairs of theme colors.
colors:

  accent: # Keys will be used as color names.
    color: "#00BFC2" # Hex color

  # Shorthand syntax
  warning: "#ED4337"

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
    description: The color for the main background of your interface.
    light: "#FFFFFF"
    dark:
      # Value for base (non-elevated) level
      base: "#0D0D0D"
      # Value for elevated level
      elevated: "#191D1D"
```

You can use your favorite text editor to edit the YAML file, then use the `build` sub-command to generate the Swift code:

```shell
$ stylegen build
```

The generated file will contain all the colors and utility methods for referencing them. You must add this generated
file to your Xcode target to use it.

In places where you normally do:

```swift
self.backgroundColor = UIColor(named: "AccentColor")
```

Now you can just do:

```swift
self.backgroundColor = .theme(.accent)
```

The `.theme()` static method serves as a namespace to easily distinguish between UIKit's built-in colors and our custom
colors. The name of the namespacing function gets inferred from the `system_name` property in the YAML file.
