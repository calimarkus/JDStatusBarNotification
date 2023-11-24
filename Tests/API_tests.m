//
// API_tests
//

#import <XCTest/XCTest.h>

@import JDStatusBarNotification;

@interface API_tests : XCTestCase
@end

@interface TestSizingController : NSObject <JDStatusBarNotificationPresenterCustomViewSizingController>
@end

@implementation TestSizingController
- (CGSize)sizeThatFits:(CGSize)size { return CGSizeZero; }
@end

@implementation API_tests {
  JDStatusBarNotificationPresenter *_presenter;
}

- (void)setUp {
  [super setUp];
  _presenter = [JDStatusBarNotificationPresenter sharedPresenter];
}

#pragma mark - Presenter Tests

- (void)testPresentationAPI_Basic {
  XCTAssertNotNil([_presenter presentWithText:@"text"]);
  XCTAssertNotNil([_presenter presentWithText:@"text"]);
  XCTAssertNotNil([_presenter presentWithText:@"text" completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" completion:^(id presenter){}]);
  XCTAssertNotNil([_presenter presentWithTitle:@"text" subtitle:@"another" completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" dismissAfterDelay:0]);
}

- (void)testPresentationAPI_CustomStyle {
  XCTAssertNotNil([_presenter presentWithText:@"text" customStyle:@"x"]);
  XCTAssertNotNil([_presenter presentWithText:@"text" customStyle:@"x" completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" customStyle:@"x" completion:^(id presenter){}]);
  XCTAssertNotNil([_presenter presentWithTitle:@"text" subtitle:@"another" customStyle:@"x" completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" dismissAfterDelay:0 customStyle:@"x"]);
}

- (void)testPresentationAPI_IncludedStyle {
  const JDStatusBarNotificationIncludedStyle style = JDStatusBarNotificationIncludedStyleDefaultStyle;
  XCTAssertNotNil([_presenter presentWithText:@"text" includedStyle:style]);
  XCTAssertNotNil([_presenter presentWithText:@"text" includedStyle:style completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" includedStyle:style completion:^(id presenter){}]);
  XCTAssertNotNil([_presenter presentWithTitle:@"text" subtitle:@"another" includedStyle:style completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" dismissAfterDelay:0 includedStyle:style]);
}

- (void)testPresentationAPI_CustomView {
  XCTAssertNotNil([_presenter presentWithCustomView:[UIView new] styleName:nil completion:nil]);
  XCTAssertNotNil([_presenter presentWithCustomView:[UIView new] sizingController:nil styleName:nil completion:nil]);
  XCTAssertNotNil([_presenter presentWithCustomView:[UIView new] sizingController:[TestSizingController new] styleName:nil completion:nil]);
}

- (void)testDismissalAPI {
  [_presenter dismiss];
  [_presenter dismissWithCompletion:nil];
  [_presenter dismissWithCompletion:^(id presenter){}];
  [_presenter dismissAnimated:false];
  [_presenter dismissAfterDelay:0];
  [_presenter dismissAfterDelay:1];
  [_presenter dismissAfterDelay:0 completion:nil];
  [_presenter dismissAnimated:false afterDelay:0 completion:nil];
}

- (void)testStyleAPI {
  [_presenter updateDefaultStyle:^id(id style) { return style; }];
  [_presenter addStyleNamed:@"x" prepare:^id(id style) { return style; }];
  [_presenter addStyleNamed:@"x" basedOnStyle:JDStatusBarNotificationIncludedStyleDefaultStyle prepare:^id(id style) { return style; }];
}

- (void)testProgressBarAPI {
  [_presenter displayProgressBarWithPercentage:0];
  [_presenter displayProgressBarWithPercentage:1];
  [_presenter animateProgressBarToPercentage:0
                       animationDuration:0
                              completion:nil];
  [_presenter animateProgressBarToPercentage:1
                       animationDuration:1
                              completion:nil];
}

- (void)testOtherAPI {
  [_presenter displayActivityIndicator:true];
  [_presenter displayLeftView:nil];
  [_presenter updateText:@"text"];
  [_presenter updateSubtitle:@"text"];

  [_presenter isVisible];
  [_presenter setWindowScene:nil];
}

#pragma mark - Style Enum Tests

- (void)testStyleEnumAvailability {
    int a = (JDStatusBarNotificationIncludedStyleDefaultStyle
             + JDStatusBarNotificationIncludedStyleDark
             + JDStatusBarNotificationIncludedStyleLight
             + JDStatusBarNotificationIncludedStyleSuccess
             + JDStatusBarNotificationIncludedStyleWarning
             + JDStatusBarNotificationIncludedStyleError
             + JDStatusBarNotificationIncludedStyleMatrix);

  int b = (JDStatusBarNotificationBackgroundTypeFullWidth
           + JDStatusBarNotificationBackgroundTypePill);

  int c = (JDStatusBarNotificationAnimationTypeMove
           + JDStatusBarNotificationAnimationTypeBounce
           + JDStatusBarNotificationAnimationTypeFade);

  int d = (JDStatusBarNotificationProgressBarPositionTop
           + JDStatusBarNotificationProgressBarPositionCenter
           + JDStatusBarNotificationProgressBarPositionBottom);

  int e = (JDStatusBarNotificationSystemBarStyleDefaultStyle
           + JDStatusBarNotificationSystemBarStyleLightContent
           + JDStatusBarNotificationSystemBarStyleDarkContent);

  int f = (JDStatusBarNotificationLeftViewAlignmentLeft
           + JDStatusBarNotificationLeftViewAlignmentCenterWithText);
}

#pragma mark - Style Tests

- (void)testStyle {
  JDStatusBarNotificationStyle *style = [JDStatusBarNotificationStyle new];

  style.textStyle = [JDStatusBarNotificationTextStyle new];
  style.subtitleStyle = [JDStatusBarNotificationTextStyle new];
  style.backgroundStyle = [JDStatusBarNotificationBackgroundStyle new];
  style.progressBarStyle = [JDStatusBarNotificationProgressBarStyle new];
  style.leftViewStyle = [JDStatusBarNotificationLeftViewStyle new];

  style.systemStatusBarStyle = JDStatusBarNotificationSystemBarStyleDefaultStyle;
  style.animationType = JDStatusBarNotificationAnimationTypeMove;
  style.canSwipeToDismiss = NO;
  style.canTapToHold = NO;
  style.canDismissDuringUserInteraction = NO;
}

- (void)testLeftViewStyle {
  JDStatusBarNotificationLeftViewStyle *style = [JDStatusBarNotificationLeftViewStyle new];

  style.spacing = 0;
  style.offsetX = 0;
  style.offset = CGPointZero;
  style.tintColor = nil;
  style.alignment = JDStatusBarNotificationLeftViewAlignmentLeft;
}

- (void)testTextStyle {
  JDStatusBarNotificationTextStyle *style = [JDStatusBarNotificationTextStyle new];

  style.textColor = nil;
  style.font = [UIFont systemFontOfSize:10];
  style.textShadowColor = nil;
  style.textShadowOffset = CGSizeZero;
  style.shadowColor = nil;
  style.shadowOffset = CGPointZero;
  style.textOffsetY = 0;
}

- (void)testPillStyle {
  JDStatusBarNotificationPillStyle *style = [JDStatusBarNotificationPillStyle new];

  style.height = 0;
  style.topSpacing = 0;
  style.minimumWidth = 0;
  style.borderColor = nil;
  style.borderWidth = 0;
  style.shadowColor = nil;
  style.shadowRadius = 0;
  style.shadowOffset = CGSizeZero;
  style.shadowOffsetXY = CGPointZero;
}

- (void)testBackgroundStyle {
  JDStatusBarNotificationBackgroundStyle *style = [JDStatusBarNotificationBackgroundStyle new];

  style.backgroundColor = nil;
  style.backgroundType = JDStatusBarNotificationBackgroundTypePill;
  style.pillStyle = [JDStatusBarNotificationPillStyle new];
}

- (void)testProgressBarStyle {
  JDStatusBarNotificationProgressBarStyle *style = [JDStatusBarNotificationProgressBarStyle new];

  style.barColor = nil;
  style.barHeight = 0;
  style.position = JDStatusBarNotificationProgressBarPositionBottom;
  style.horizontalInsets = 0;
  style.offsetY = 0;
  style.cornerRadius = 0;
}

@end
