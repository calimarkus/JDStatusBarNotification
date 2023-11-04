//
//  SBExampleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBExampleViewController.h"

#import "Swift-To-ObjC-Header.h"

@implementation SBExampleViewController {
  UIViewController *_hostingController;
}

- (instancetype)initWithTitle:(NSString *)title {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.title = title;
  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view.backgroundColor = [UIColor systemGray6Color];

  if (@available(iOS 15.0, *)) {
    UIViewController *hostingController = [ExamplesScreenFactory createExamplesScreenWithTitle:self.title];
    [hostingController willMoveToParentViewController:self];
    [self addChildViewController:hostingController];
    [self.view addSubview:hostingController.view];
    hostingController.view.frame = self.view.bounds;
    hostingController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _hostingController = hostingController;
  } else {
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"The Example App only supports iOS 15+", "");
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor systemGray6Color];
    [label sizeToFit];
    self.view = label;
  }
}

@end
