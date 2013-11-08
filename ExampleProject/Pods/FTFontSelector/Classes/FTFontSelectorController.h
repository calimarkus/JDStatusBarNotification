#import <UIKit/UIKit.h>


@class FTFontSelectorController;

/**
  The `FTFontSelectorControllerDelegate` protocol defines the methods you must implement for the
  [fontDelegate](../Classes/FTFontSelectorController.html#//api/name/fontDelegate) of a
  `FTFontSelectorController` object. Font selector controllers notify their delegate whenever user
  interactions would cause the font selection to change and/or the dismissal of the font selector
  to be required.

  For more information about the `FTFontSelectorController` class, see `FTFontSelectorController`
  Class Reference.
*/
@protocol FTFontSelectorControllerDelegate <NSObject>

/// @name Managing the font selector’s font selection change

/**
 Tells the delegate that the font selector’s font selection has been changed.

 This method is called in response to user-initiated font selection changes.

 @param controller The font selector controller who’s font selection has changed.
 @param fontName   The **postscript** name of the newly selected font.
*/
- (void)fontSelectorController:(FTFontSelectorController *)controller
     didChangeSelectedFontName:(NSString *)fontName;

/// @name Managing the font selector’s dismissal

/**
 Tells the delegate that the font selector should be dismissed.

 This method is called in response to user-initiated attempts to dismiss the font selector on
 iPhone (where a dismissal button is added to the font selector’s navigation bar), or on iPad when
 a selection change is made in the font families view (**not** the family members view).

 @param controller The font selector controller that should be dismissed.
*/
- (void)fontSelectorControllerShouldBeDismissed:(FTFontSelectorController *)controller;

@optional

/// @name Managing cell appearance

/**
 Tells the delegate that a table view is about to draw a cell for a particular row.

 A table view sends this message to its delegate just before it uses the cell to draw a row,
 thereby permitting the delegate to customize the cell object before it is displayed. This method
 gives the delegate a chance to override state-based properties set earlier by the font controller,
 such as selection and background color.

 @since 1.1.0

 @param controller The font selector controller informing the delegate of this impending event.
 @param cell       A cell that one of the table-views is going to use when drawing the row.
*/
- (void)fontSelectorController:(FTFontSelectorController *)controller
      willDisplayTableViewCell:(UITableViewCell *)cell;

/**
 Tells the delegate that a table view is about to draw a selection change for a particular row.

 A font selector sends this message to its delegate when the user (de)selects a row, thereby
 permitting the delegate to customize what a (de)selected row looks like. Generally this will be
 limited to the checkmark image that’s used to indicate row selection.

 In reality this message is not only sent when the selection state changes, but also when the cell
 is configured for the first time.

 @since 1.1.0

 @param controller The font selector controller informing the delegate of this impending event.
 @param cell       The cell that has changed selection.
 @param selected   Wether or not the cell is selected.
*/
- (void)fontSelectorController:(FTFontSelectorController *)controller
           changeCellSelection:(UITableViewCell *)cell
                      selected:(BOOL)selected;

@end

/**
 `FTFontSelectorController` implements a self contained `UINavigationController` subclass that
 provides all the required features. Simply implement the `FTFontSelectorControllerDelegate`
 protocol, assign the `fontDelegate`, and present it as you see fit.

 See [the example application](https://github.com/Fingertips/FTFontSelector/tree/master/Project)
 for possible ways to present this controller on both the iPhone and iPad, as can be seen below.

 **Note:** _The iPhone version of the example app uses a bit of a hack by adding the view to the
 `UITextView`’s `inputView`. In Pages the keyboard is actually dismissed beforehand, so keep this
 in mind._


 ## Common presentation on iPhone

 On iPhone, it’s common to add the controller instance as a child view controller in the same place
 that the keyboard is normally shown.

 <a target="_blank" href="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPhone%20Font%20Families.png" style="float:left;margin-right:10px">
   <img title="iPhone Font Families" src="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPhone%20Font%20Families.png" />
 </a>

 <a target="_blank" href="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPhone%20Font%20Family%20Members.png">
   <img title="iPhone Font Family Members" src="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPhone%20Font%20Family%20Members.png" />
 </a>

 ## Common presentation on iPad

 On iPad it’s common to show the controller in a `UIPopoverController`.

 <a target="_blank" href="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPad%20Font%20Families.png" style="float:left;margin-right:10px">
   <img title="iPad Font Families" src="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPad%20Font%20Families%20Small.png" />
 </a>

 <a target="_blank" href="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPad%20Font%20Family%20Members.png">
   <img title="iPad Font Family Members" src="https&colon;//raw.github.com/Fingertips/FTFontSelector/master/Project/Screenshots/iPad%20Font%20Family%20Members%20Small.png" />
 </a>

*/
@interface FTFontSelectorController : UINavigationController

/// @name Configuring the font selector attributes

/**
  The object that acts as the delegate of the receiving font selector.
*/
@property (weak) id<FTFontSelectorControllerDelegate> fontDelegate;

/**
  Indicates wether or not a dismissal button should be included in the font selector’s navigation
  bar.

  The default value is `YES`.

  @warning This applies _only_ to the iPhone. On the iPad this property is ignored.
*/
@property (assign) BOOL showsDismissButton;

/// @name Getting the font selector attributes

/**
  Returns the **postscript** name of the currently selected font.
*/
@property (readonly) NSString *selectedFontName;

/// @name Initializing a font selector controller object

/**
  Initializes and returns a font selector object with the specified font as the currently selected
  one.

  You **must** specify a valid font for this object to initialize.

  @param fontName The **postscript** name of the font that will be shown as being selected.

  @returns Returns an initialized `FTFontSelectorController` object or `nil` if the object could
  not be successfully initialized.
*/
- (instancetype)initWithSelectedFontName:(NSString *)fontName;

@end

