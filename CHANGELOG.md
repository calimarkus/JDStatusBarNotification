# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.2.0] - 2023-12-10

### Added

- New Swift-native APIs. These achieve more with less, as I can make proper use of e.g. optionals and default parameters.

### Changed

- Converted source code to Swift (with backwards compatible objc translation)
- This lets me remove the hacks around multi-language targets

## [2.1.2] - 2023-11-13

### Changed

- Bring back Swift 5.7 compatibility

## [2.1.1] - 2023-11-05

### Changed

- Fixed SPM build issues. (#133)

## [2.1.0] - 2023-10-31

### Changed

- Breaking change: A rewritten Swift API for better Swift ergonomics, Obj-C unaffected.

### Added

- A swift-only `presentSwiftView()` presentation helper to easily present SwiftUI views
- A new `presentWithCustomView:sizingController:` API for additional control on the sizing, utilized by the above swift API

## [2.0.9] - 2023-10-11

### Changed

- Reworked layouting & sizing of the notification
    - Fix the presentation, when no statusbar is visible (#130)
    - Fix pill position with flexible pill heights across devices (#122)
    - Fix the .fullWidth presentation on dynamic island devices
    - Fix the .fullWidth style presentation in landscape for all devices

## [2.0.8] - 2023-06-08

### Changed

- Fixed Swift package for Xcode 15 compatibility

## [2.0.7] - 2022-09-27

### Changed

- Fixed 14 Pro / Dynamic Island banner positioning

## [2.0.6] - 2022-06-27

### Changed

- Fixed Swift Package Format so that dump-package works again

## [2.0.5] - 2022-06-27

tl;dr: Another documentation update.

### Changed

- Changed Swift Package `swift-tools-version` to 5.3
- Added `.spi.yml` for better Swift Package Index integration

## [2.0.4] - 2022-06-26

tl;dr: A documentation update.

### Added

- Overhauled all public API documentation & converted it to the docc syntax

### Changed

- Renamed: `JDStatusBarStyle` -> `JDStatusBarNotificationStyle` & sub-style classes.
  (Note: If you initalize styles in your codebase this is a breaking change. The current API design doesn't expect users to initialize styles, but it is possible to do so.)
- Renamed private classes and enums and their swift naming for more consistency.

## [2.0.3] - 2022-06-22

### Added

- Added rubber-banding effect when panning down on notification (.pill style only)
- Explicitly customizable ActivityIndicator color
- Ability to disable Tap-To-Hold behavior
- Added leftView Y offset (more positioning control)

### Fixed

- Fix broken `.canDismissDuringUserInteraction` - it can now be disabled again.
- Fix failing animation on presentation calls during ongoing presentation
- Fix progress bar sometimes not showing up

## [2.0.2] - 2022-06-19

### Added

- Prevent dismissal during user interaction (hold or pan), configurable.
- Use pill height as minimum pill width.

### Fixed

- Fix `.canSwipeToDismiss` - it can now be disabled again.

### Changed

- Remove `.centerWithTextUnlessSubtitleExists`, default to `.centerWithText`.

## [2.0.1] - 2022-06-15

### Added

- Subtitle support (customizable)
- Generic left view support (think icons, profile pictures, etc.), customizable layout

### Fixed

- WindowScene inferred automatically (no need to set it explicitly anymore)
- Disable drag-to-dismiss during dismiss animation
- Tweaked default style pill size & positioning
- Don't clip text to bounds

## [2.0.0] - 2022-06-14

Big release. Many bugfixes, expanded public API, new features. Modernized outdated codebase - more or less a full rewrite.
This is a breaking API release. Existing code using previous versions of this library will require some adjustments.
Those adjustments should be simple though - mostly new API naming.

### Added

- A pill shaped layout (original layout available as "full-width" layout)
- Drag-to-dismiss + general support for user interaction on the notification
- Easy progress bar animation through public API
- Custom view presentation
- Presentation when no status bar is visible
- More robust layouting of text & activity indicator
- Support for apps that use window scenes
- Explicit Swift naming for all public APIs + Swift example project
- Full fledged style editor in example project + config export

### Fixed

- Many bug fixes

### Changed

- Non-notch device layout matches notch device layout now
- Included styles moved to explicit API, instead of `styleName` API
- `JDStatusBarView` internals no longer exposed, custom view APIs added instead.

### Removed

- `JDStatusBarHeightForIPhoneXHalf` layout
- `BarAnimationTypeNone`
- `ProgressBarPositionBelow`, `JDStatusBarProgressBarPositionNavBar`

## [1.6.1] - 2019-12-13

Old version based on original release. No release notes available.

[Unreleased]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.2.0...HEAD
[2.2.0]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.1.2...2.2.0
[2.1.2]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.1.0...2.1.2
[2.1.1]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.1.0...2.1.1
[2.1.0]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.9...2.1.0
[2.0.9]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.8...2.0.9
[2.0.8]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.7...2.0.8
[2.0.7]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.6...2.0.7
[2.0.6]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.5...2.0.6
[2.0.5]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.4...2.0.5
[2.0.4]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.3...2.0.4
[2.0.3]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.2...2.0.3
[2.0.2]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.1...2.0.2
[2.0.1]: https://github.com/calimarkus/JDStatusBarNotification/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/calimarkus/JDStatusBarNotification/compare/1.6.1...2.0.0
[1.6.1]: https://github.com/calimarkus/JDStatusBarNotification/releases/tag/1.6.1

