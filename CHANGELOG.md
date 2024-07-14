# Changelog

All notable changes to this project will be documented in this file.

## v0.8.0

### Changed

- Dropped Ruby 2.7 support.

## v0.7.0

### Added

- Added AppKit support.

### Changed

- Stylegen now requires Ruby 2.7 or higher.

## v0.6.1

### Fixed

- Fixed a bug where an extra space was being added after the access-level modifier in the generated code.

## v0.6.0

### Changed

- Switched from GLI to dry-cli for CLI. Some may produce slightly different STDOUT and STDERR output.

### Added

- Added `--output` flag to `stylegen init` command. This allows you to specify a different output file than the default `theme.yaml`.
- Added `--input` flag to `stylegen build` command. This allows you to specify a different input file than the default `theme.yaml`.

## v0.5.0

### Changed

- Switched generated code from `struct` to `class`.
- SwiftUI: Use `Color(uiColor:)` initializer when running on iOS 15+.

## v0.4.0

### Added

- Added support for color descriptions.

## v0.3.1

### Changed

- Increased precision of HEX color conversion to avoid truncation.

## v0.3.0

### Added

- SwiftUI support.

## v0.2.0

### Added

- `stylegen init` command.

## v0.1.0

- Initial release.
