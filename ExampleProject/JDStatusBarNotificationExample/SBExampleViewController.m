//
//  SBExampleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarNotification.h"
#import "SBCustomStyleViewController.h"

#import "SBExampleViewController.h"

static NSString *const JDButtonName = @"JDButtonName";
static NSString *const JDButtonInfo = @"JDButtonInfo";
static NSString *const JDNotificationText = @"JDNotificationText";

static NSString *const SBStyle1 = @"SBStyle1";
static NSString *const SBStyle2 = @"SBStyle2";

@interface SBExampleViewController ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation SBExampleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ExampleViewControllerTitle"];

    [JDStatusBarNotification addStyleNamed:SBStyle1
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                     style.barColor = [UIColor colorWithRed:0.797 green:0.000 blue:0.662 alpha:1.000];
                                     style.textColor = [UIColor whiteColor];
                                     style.animationType = JDStatusBarAnimationTypeFade;
                                     style.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:17.0];
                                     style.progressBarColor = [UIColor colorWithRed:0.986 green:0.062 blue:0.598 alpha:1.000];
                                     style.progressBarHeight = 20.0;
                                     return style;
                                   }];

    [JDStatusBarNotification addStyleNamed:SBStyle2
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                     style.barColor = [UIColor cyanColor];
                                     style.textColor = [UIColor colorWithRed:0.056 green:0.478 blue:0.998 alpha:1.000];
                                     style.animationType = JDStatusBarAnimationTypeBounce;
                                     style.progressBarColor = style.textColor;
                                     style.progressBarHeight = 5.0;
                                     style.progressBarPosition = JDStatusBarProgressBarPositionTop;
                                     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                                       style.font = [UIFont fontWithName:@"DINCondensed-Bold" size:17.0];
                                       style.textVerticalPositionAdjustment = 2.0;
                                     } else {
                                       style.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0];
                                     }
                                     return style;
                                   }];

    self.data = @[@[@{JDButtonName:@"Show Notification", JDButtonInfo:@"Don't autohide.", JDNotificationText:@"Better call Saul!"},
                    @{JDButtonName:@"Show Progress for 1s", JDButtonInfo:@"", JDNotificationText:@"Some Progress…"},
                    @{JDButtonName:@"Show Activity Indicator", JDButtonInfo:@"", JDNotificationText:@"Some Activity…"},
                    @{JDButtonName:@"Update text", JDButtonInfo:@"", JDNotificationText:@"Some Activity…"},
                    @{JDButtonName:@"Dismiss Notification", JDButtonInfo:@"", JDNotificationText:@""}],
                  @[@{JDButtonName:@"Show JDStatusBarStyleError", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"No, I don't have the money.."},
                    @{JDButtonName:@"Show JDStatusBarStyleWarning", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"You know who I am!"},
                    @{JDButtonName:@"Show JDStatusBarStyleSuccess", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"That's how we roll!"},
                    @{JDButtonName:@"Show JDStatusBarStyleDark", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"Don't mess with me!"},
                    @{JDButtonName:@"Show JDStatusBarStyleMatrix", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"Wake up Neo…"}],
                  @[@{JDButtonName:@"Show custom style 1", JDButtonInfo:@"Duration: 3s, JDStatusBarAnimationTypeFade", JDNotificationText:@"Oh, I love it!"},
                    @{JDButtonName:@"Show custom style 2", JDButtonInfo:@"Duration: 3s, JDStatusBarAnimationTypeBounce", JDNotificationText:@"Level up!"}],
                  @[@{JDButtonName:@"Create your own style", JDButtonInfo:@"Test all possibilities", JDNotificationText:@""}]];
  }
  return self;
}

- (void)viewDidLoad;
{
  [super viewDidLoad];

  // presenting a notification, before a keyWindow is set
  [JDStatusBarNotification showWithStatus:@"👋 Hello World!"
                        dismissAfterDelay:2.0
                                styleName:JDStatusBarStyleMatrix];
}

- (BOOL)prefersStatusBarHidden
{
  return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
  return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  // create / dequeue cell
  static NSString* identifier = @"identifier";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
      cell.textLabel.backgroundColor = [UIColor clearColor];
      cell.detailTextLabel.backgroundColor = [UIColor clearColor];
      cell.backgroundView = [[UIView alloc] init];
      cell.backgroundView.backgroundColor = [UIColor whiteColor];
      cell.selectedBackgroundView = [[UIView alloc] init];
      cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
  }

  NSDictionary *data = self.data[indexPath.section][indexPath.row];
  cell.textLabel.text = data[JDButtonName];
  cell.detailTextLabel.text = data[JDButtonInfo];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;

  NSDictionary *data = self.data[indexPath.section][indexPath.row];
  NSString *status = data[JDNotificationText];

  // reset progress timer
  self.progress = 0.0;
  [self.timer invalidate];
  self.timer = nil;

  // show notification
  if (section == 0) {
    if (row == 0) {
      [JDStatusBarNotification showWithStatus:status];
    } else if (row == 1) {
      if(![JDStatusBarNotification isVisible]) {
        [JDStatusBarNotification showWithStatus:status dismissAfterDelay:1.4];
      }
      [self startTimer];
    } else if (row == 2) {
      if(![JDStatusBarNotification isVisible]) {
        [JDStatusBarNotification showWithStatus:status dismissAfterDelay:3.0];
      }
        [JDStatusBarNotification showActivityIndicator:YES];
    } else if (row == 3) {
      [JDStatusBarNotification updateStatus:@"Replaced Text.."];
    } else if (row == 4) {
      [JDStatusBarNotification dismiss];
    }
  } else if (section == 1) {
    NSString *style = JDStatusBarStyleError;
    if (row == 1) {
      style = JDStatusBarStyleWarning;
    } else if(row == 2) {
      style = JDStatusBarStyleSuccess;
    } else if(row == 3) {
      style = JDStatusBarStyleDark;
    } else if(row == 4) {
      style = JDStatusBarStyleMatrix;
    }

    [JDStatusBarNotification showWithStatus:status
                          dismissAfterDelay:3.0
                                  styleName:style];
  } else if (section == 2) {
    NSString *style = (row==0) ? SBStyle1 : SBStyle2;
    [JDStatusBarNotification showWithStatus:status
                          dismissAfterDelay:3.0
                                  styleName:style];
  } else if (section == 3) {
    SBCustomStyleViewController* viewController = [[SBCustomStyleViewController alloc] init];
    viewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController:viewController animated:YES];
  }

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)startTimer;
{
  [JDStatusBarNotification showProgressBarWithPercentage:self.progress];
  
  [self.timer invalidate];
  self.timer = nil;

  if (self.progress < 1.0) {
    CGFloat step = 0.02;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:step target:self
                                                selector:@selector(startTimer)
                                                userInfo:nil repeats:NO];
    self.progress += step;
  } else {
    [self performSelector:@selector(hideProgress)
               withObject:nil afterDelay:0.5];
  }
}

- (void)hideProgress;
{
  [JDStatusBarNotification showProgressBarWithPercentage:0.0];
}

@end
