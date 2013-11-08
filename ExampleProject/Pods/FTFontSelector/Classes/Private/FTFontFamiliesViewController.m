#import "FTFontFamiliesViewController.h"
#import "FTFontDescriptor.h"

@implementation FTFontFamiliesViewController

- (instancetype)init;
{
  if ((self = [super init])) {
    self.title = NSLocalizedString(@"Fonts", nil);
    self.fontDescriptors = [FTFontDescriptor fontFamilies];
  }
  return self;
}

// Only on the iPad and only in the main list of families does the popover
// dismiss when changing selection. This does NOT mean tapping the disclosure
// button.
- (BOOL)dismissOnSelection;
{
  return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (BOOL)hasFamilyMembersAtIndexPath:(NSIndexPath *)indexPath;
{
  return [self.fontDescriptors[indexPath.row] hasFamilyMembers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  if ([self hasFamilyMembersAtIndexPath:indexPath]) {
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView
        accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
  [self changeSelectedFontToIndexPath:indexPath dismiss:NO];

  FTFontFamilyMembersViewController *controller = [FTFontFamilyMembersViewController new];
  FTFontDescriptor *descriptor = self.fontDescriptors[indexPath.row];
  controller.title = descriptor.displayName;
  controller.fontDescriptors = descriptor.familyMembers;
  controller.fontSelectorController = self.fontSelectorController;
  [self.navigationController pushViewController:controller animated:YES];
}

@end
