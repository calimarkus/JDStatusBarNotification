#import "FTFontSelectorController.h"
#import "FTFontFamiliesViewController.h"

@interface FTFontSelectorController () <FTFontSelectorControllerDelegate>
@property (strong) NSString *selectedFontName;
@end

@implementation FTFontSelectorController

- (instancetype)initWithSelectedFontName:(NSString *)fontName;
{
  NSParameterAssert(fontName);
  FTFontFamiliesViewController *controller = [FTFontFamiliesViewController new];
  controller.fontSelectorController = self;
  if ((self = [super initWithRootViewController:controller])) {
    _selectedFontName = fontName;
    _showsDismissButton = YES;
  }
  return self;
}

- (void)fontSelectorController:(id)_
     didChangeSelectedFontName:(NSString *)postscriptName;
{
  self.selectedFontName = postscriptName;
  [self.fontDelegate fontSelectorController:self
                  didChangeSelectedFontName:self.selectedFontName];
}

- (void)fontSelectorControllerShouldBeDismissed:(id)_;
{
  [self.fontDelegate fontSelectorControllerShouldBeDismissed:self];
}

// It appears that UINavigationController always returns the size of it's root
// view.
//
// For now override it with how it should be shown on iPad in portrait.
- (CGSize)contentSizeForViewInPopover;
{
  return CGSizeMake(320, 425);
}

@end

