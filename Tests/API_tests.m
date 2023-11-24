//
// API_tests
//

#import <XCTest/XCTest.h>

#import <JDStatusBarNotification/JDStatusBarNotification.h>

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

- (void)testPresentationAPI_Basic {
  XCTAssertNotNil([_presenter presentWithText:@"text"]);
  XCTAssertNotNil([_presenter presentWithText:@"text"]);
  XCTAssertNotNil([_presenter presentWithText:@"text" completion:nil]);
  XCTAssertNotNil([_presenter presentWithTitle:@"text" subtitle:@"another" completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" dismissAfterDelay:0]);
}

- (void)testPresentationAPI_CustomStyle {
  XCTAssertNotNil([_presenter presentWithText:@"text" customStyle:@"x"]);
  XCTAssertNotNil([_presenter presentWithText:@"text" customStyle:@"x" completion:nil]);
  XCTAssertNotNil([_presenter presentWithTitle:@"text" subtitle:@"another" customStyle:@"x" completion:nil]);
  XCTAssertNotNil([_presenter presentWithText:@"text" dismissAfterDelay:0 customStyle:@"x"]);
}

- (void)testPresentationAPI_IncludedStyle {
  const JDStatusBarNotificationIncludedStyle style = JDStatusBarNotificationIncludedStyleDefaultStyle;
  XCTAssertNotNil([_presenter presentWithText:@"text" includedStyle:style]);
  XCTAssertNotNil([_presenter presentWithText:@"text" includedStyle:style completion:nil]);
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
  [_presenter dismissAnimated:false];
  [_presenter dismissAfterDelay:0];
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
  [_presenter animateProgressBarToPercentage:0
                       animationDuration:0
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

@end
