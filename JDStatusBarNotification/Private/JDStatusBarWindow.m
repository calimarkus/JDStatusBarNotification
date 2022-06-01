//
//

#import "JDStatusBarWindow.h"

@implementation JDStatusBarWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  if (_topBar != nil) {
    CGRect rect = [self convertRect:_topBar.bounds fromView:_topBar];
    if (_topBar.userInteractionEnabled && CGRectContainsPoint(rect, point)) {
      return [_topBar hitTest:point withEvent:event];
    }
  }
  return nil;
}

@end
