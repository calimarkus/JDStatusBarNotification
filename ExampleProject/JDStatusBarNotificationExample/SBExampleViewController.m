//
//  SBExampleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBExampleViewController.h"

#import "SBStyleEditorViewController.h"
#import "Swift-To-ObjC-Header.h"

@implementation SBExampleViewController {
  UIViewController *_hostingController;
}

- (void)loadView {
  self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ExampleViewControllerTitle"];

  self.view = [[UIView alloc] init];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view.backgroundColor = [UIColor systemGray6Color];

  if (@available(iOS 15.0, *)) {
    __weak __typeof(self) weakSelf = self;
    UIViewController *hostingController = [ExamplesViewFactory createExamplesViewWithPresentationHandler:^{
      [weakSelf.navigationController pushViewController:[[SBStyleEditorViewController alloc] init] animated:YES];
    }];
    [hostingController willMoveToParentViewController:self];
    [self addChildViewController:hostingController];
    [self.view addSubview:hostingController.view];
    hostingController.view.frame = self.view.bounds;
    hostingController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _hostingController = hostingController;
  } else {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"The Example App only supports iOS 15+";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor systemGray6Color];
    [label sizeToFit];
    self.view = label;
  }
}

@end
