//
//  SBStyleEditorViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 08.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBStyleEditorViewController.h"

#if IS_SCENE_BASED_EXAMPLE
  #import "JDSBN_WindowSceneExample-Swift.h"
#else
  #import "JDSBN_ClassicExample-Swift.h"
#endif

@implementation SBStyleEditorViewController {
UIViewController *_hostingController;
}

- (void)loadView {
  self.title = @"Style Editor";

  self.view = [[UIView alloc] init];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view.backgroundColor = [UIColor systemGray6Color];

  if (@available(iOS 15.0, *)) {
    UIViewController *hostingController = [StyleEditorViewFactory createStyleEditorView];
    [hostingController willMoveToParentViewController:self];
    [self addChildViewController:hostingController];
    [self.view addSubview:hostingController.view];
    hostingController.view.frame = self.view.bounds;
    hostingController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _hostingController = hostingController;
  }
}

@end
