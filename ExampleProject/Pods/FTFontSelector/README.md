# FTFontSelector

[![Version](http://cocoapod-badges.herokuapp.com/v/FTFontSelector/badge.png)](http://cocoadocs.org/docsets/FTFontSelector)
[![Platform](http://cocoapod-badges.herokuapp.com/p/FTFontSelector/badge.png)](http://cocoadocs.org/docsets/FTFontSelector)

FTFontSelector implements a clone of the font selector that can be found in Apple’s iOS Pages
application.

See [the screenshots](https://github.com/Fingertips/FTFontSelector/tree/master/Project/Screenshots)
for examples of its usage on both iPhone and iPad.

**Note:** _For now it targets the current iOS 6 look, because we won’t know what Apple’s version in
iOS 7 will look like yet._


## Usage

The one exposed class that you need to work with is `FTFontSelectorController`. This class is a
self contained `UINavigationController` subclass that provides all the required features.


## Installation

FTFontSelector is available through [CocoaPods](http://cocoapods.org), to install it simply add the
following line to your Podfile:

    pod "FTFontSelector"

Alternatively, add all the source files in `Classes` and the resource bundle at
`Assets/FTFontSelector.bundle` to your Xcode project and add `CoreText` to the ‘frameworks build
phase’.


## Author

Eloy Durán, eloy.de.enige@gmail.com


## License

FTFontSelector is available under the MIT license. See
[the LICENSE file](https://raw.github.com/Fingertips/FTFontSelector/master/LICENSE) for more info.
