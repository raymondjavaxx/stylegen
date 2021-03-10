# stylegen

A CLI utility that allows managing the colors used in an iOS app from a centralized YAML file in a type-safe way.

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

Create a `theme.yaml` file in the root of your project by executing:

```shell
$ stylegen init
```

Edit the generated file with your favorite text editor, then use the `build` sub-command to generate the Swift code:

```shell
$ stylegen build
```

The generated file will contain all the colors and utility methods for referencing them. You must add this generated
file to your target.

In places where you normally do:

```swift
self.backgroundColor = UIColor(named: "AccentColor")
```

Now you can just do:

```swift
self.backgroundColor = .theme(.accent)
```

The `.theme()` static method serves as a namespace to easily distinguish between UIKit's built-in colors and our custom colors. The name of the namespacing function is inferred from the `system_name` property in the YAML file.

## TODO

* ~~`$ stylegen init` command~~
* Option to specify target frameworks: AppKit, UIKit, Core Graphics, and SwiftUI
* SwiftUI support
* AppKit support
