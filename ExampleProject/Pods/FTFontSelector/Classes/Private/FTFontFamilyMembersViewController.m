#import "FTFontFamilyMembersViewController.h"
#import "FTFontDescriptor.h"


static UIImage *
FTFontImageNamed(NSString *imageName)
{
  NSString *name = @"FTFontSelector.bundle";
  name = [name stringByAppendingPathComponent:imageName];
  return [UIImage imageNamed:name];
}

@implementation FTFontFamilyMembersViewController

#pragma mark - UIViewController

- (instancetype)init;
{
  if ((self = [super init])) {
    _currentSelectedFontIndex = -1;
  }
  return self;
}

- (void)loadView;
{
  self.tableView = [UITableView new];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.view = self.tableView;

  [self updateCurrentSelectedFontIndex];
  [self.tableView reloadData];

  if (self.fontSelectorController.showsDismissButton &&
        UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    SEL action = @selector(fontSelectorControllerShouldBeDismissed:);
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:FTFontImageNamed(@"ArrowDown")
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self.fontSelectorController
                                                              action:action];
    self.navigationItem.rightBarButtonItem = button;
  }
}

- (void)viewWillAppear:(BOOL)animated;
{
  [super viewWillAppear:animated];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentSelectedFontIndex
                                              inSection:0];
  [self.tableView scrollToRowAtIndexPath:indexPath
                        atScrollPosition:UITableViewScrollPositionMiddle
                                animated:NO];
}

#pragma mark - FTFontFamilyMembersViewController

- (BOOL)dismissOnSelection;
{
  return NO;
}

- (void)updateCurrentSelectedFontIndex;
{
  NSString *postscriptName = self.fontSelectorController.selectedFontName;
  NSParameterAssert(postscriptName);

  NSUInteger count = self.fontDescriptors.count;
  for (NSUInteger index = 0; index < count; index++) {
    FTFontDescriptor *descriptor = self.fontDescriptors[index];
    if ([descriptor descriptorWithPostscriptName:postscriptName] != nil) {
      self.currentSelectedFontIndex = index;
      return;
    }
  }
  self.currentSelectedFontIndex = -1;
}

#pragma mark - UITableView cell selection

- (void)updateCheckMarkOfCell:(UITableViewCell *)cell selected:(BOOL)selected;
{
  // TODO really really need to fix this layout without an image :)
  if (selected) {
    cell.imageView.image = FTFontImageNamed(@"CheckMark");
    cell.imageView.highlightedImage = FTFontImageNamed(@"CheckMark-White");
  } else {
    cell.imageView.image = FTFontImageNamed(@"CheckMark-Clear");
    cell.imageView.highlightedImage = FTFontImageNamed(@"CheckMark-Clear");
  }

  id<FTFontSelectorControllerDelegate> delegate = self.fontSelectorController.fontDelegate;
  SEL selector = @selector(fontSelectorController:changeCellSelection:selected:);
  if (delegate && [delegate respondsToSelector:selector]) {
    [delegate fontSelectorController:self.fontSelectorController
                 changeCellSelection:cell
                            selected:selected];
  }
}

- (void)changeSelectedFontToIndexPath:(NSIndexPath *)selectedIndexPath
                              dismiss:(BOOL)dismiss;
{
  if (selectedIndexPath.row == self.currentSelectedFontIndex) return;

  for (NSIndexPath *indexPath in [self.tableView indexPathsForVisibleRows]) {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self updateCheckMarkOfCell:cell selected:[indexPath isEqual:selectedIndexPath]];
  }

  self.currentSelectedFontIndex = selectedIndexPath.row;
  NSString *postscriptName = [self.fontDescriptors[selectedIndexPath.row] postscriptName];
  [self.fontSelectorController fontSelectorController:nil
                            didChangeSelectedFontName:postscriptName];
  if (dismiss) {
    [self.fontSelectorController fontSelectorControllerShouldBeDismissed:nil];
  }
}

#pragma mark - UITableView data source + delegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section;
{
  return self.fontDescriptors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  static NSString *cellID = @"fontCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellID];
  }
  [self updateCheckMarkOfCell:cell selected:self.currentSelectedFontIndex == indexPath.row];
  FTFontDescriptor *descriptor = self.fontDescriptors[indexPath.row];
  cell.textLabel.font = [UIFont fontWithName:descriptor.postscriptName size:21];
  cell.textLabel.text = descriptor.displayName;
  return cell;
}

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self changeSelectedFontToIndexPath:indexPath dismiss:self.dismissOnSelection];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
  id<FTFontSelectorControllerDelegate> delegate = self.fontSelectorController.fontDelegate;
  SEL selector = @selector(fontSelectorController:willDisplayTableViewCell:);
  if (delegate && [delegate respondsToSelector:selector]) {
    [delegate fontSelectorController:self.fontSelectorController willDisplayTableViewCell:cell];
  }
}

@end
