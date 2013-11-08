#import <UIKit/UIKit.h>
#import "FTFontSelectorController.h"


@interface FTFontFamilyMembersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong) NSArray *fontDescriptors;
@property (strong) UITableView *tableView;
@property (assign) NSInteger currentSelectedFontIndex;
@property (weak) FTFontSelectorController<FTFontSelectorControllerDelegate> *fontSelectorController;
@property (readonly) BOOL dismissOnSelection;

- (void)changeSelectedFontToIndexPath:(NSIndexPath *)selectedIndexPath
                              dismiss:(BOOL)dismiss;

@end
