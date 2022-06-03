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
@end

@implementation SBExampleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ExampleViewControllerTitle"];
    
    [[JDStatusBarNotificationPresenter sharedPresenter] addStyleNamed:SBStyle1 prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
      style.barColor = [UIColor colorWithRed:0.797 green:0.000 blue:0.662 alpha:1.000];
      style.textColor = [UIColor whiteColor];
      style.animationType = JDStatusBarAnimationTypeFade;
      style.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:17.0];
      style.progressBarStyle.barColor = [UIColor colorWithRed:0.986 green:0.062 blue:0.598 alpha:1.000];
      style.progressBarStyle.barHeight = 400.0;
      return style;
    }];
    
    [[JDStatusBarNotificationPresenter sharedPresenter] addStyleNamed:SBStyle2 prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
      style.barColor = [UIColor cyanColor];
      style.textColor = [UIColor colorWithRed:0.056 green:0.478 blue:0.998 alpha:1.000];
      style.animationType = JDStatusBarAnimationTypeBounce;
      style.progressBarStyle.barColor = style.textColor;
      style.progressBarStyle.barHeight = 22.0;
      style.progressBarStyle.position = JDStatusBarProgressBarPositionTop;
      if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        style.font = [UIFont fontWithName:@"DINCondensed-Bold" size:17.0];
        style.textVerticalPositionAdjustment = 2.0;
      } else {
        style.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0];
      }
      return style;
    }];
    
    self.data = @[@[@{JDButtonName:@"Show Notification", JDButtonInfo:@"Don't autohide.", JDNotificationText:@"Better call Saul!"},
                    @{JDButtonName:@"Animate ProgressBar & hide", JDButtonInfo:@"Hide bar at 100%", JDNotificationText:@"Animating Progress…"},
                    @{JDButtonName:@"Show ProgressBar at 33%", JDButtonInfo:@"", JDNotificationText:@"1/3 done."},
                    @{JDButtonName:@"Show Activity Indicator", JDButtonInfo:@"", JDNotificationText:@"Some Activity…"},
                    @{JDButtonName:@"Update text", JDButtonInfo:@"", JDNotificationText:@"Some Activity…"},
                    @{JDButtonName:@"Dismiss Notification", JDButtonInfo:@"", JDNotificationText:@""}],
                  @[@{JDButtonName:@"Show JDStatusBarStyleError", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"No, I don't have the money.."},
                    @{JDButtonName:@"Show JDStatusBarStyleWarning", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"You know who I am!"},
                    @{JDButtonName:@"Show JDStatusBarStyleSuccess", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"That's how we roll!"},
                    @{JDButtonName:@"Show JDStatusBarStyleDark", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"Don't mess with me!"},
                    @{JDButtonName:@"Show JDStatusBarStyleMatrix", JDButtonInfo:@"Duration: 3s", JDNotificationText:@"Wake up Neo…"}],
                  @[@{JDButtonName:@"Show custom style 1", JDButtonInfo:@"JDStatusBarAnimationTypeFade + Progress", JDNotificationText:@"Oh, I love it!"},
                    @{JDButtonName:@"Show custom style 2", JDButtonInfo:@"JDStatusBarAnimationTypeBounce + Progress", JDNotificationText:@"Level up!"},
                    @{JDButtonName:@"Show notification with button", JDButtonInfo:@"Manually customized view", JDNotificationText:@""},
                    @{JDButtonName:@"2 notifications in sequence", JDButtonInfo:@"Utilizing the completion block", JDNotificationText:@""}],
                  @[@{JDButtonName:@"Create your own style", JDButtonInfo:@"Test all possibilities", JDNotificationText:@""}]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // presenting a notification, before view is attached to window & before keyWindow is set
  [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:@"👋 Hello World!"
                                                   dismissAfterDelay:2.5
                                                           styleName:JDStatusBarStyleMatrix];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.data[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return @"Default Style";
    case 1:
      return @"Included Styles";
    case 2:
      return @"Customization";
    default:
      return nil;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;
  
  NSDictionary *data = self.data[indexPath.section][indexPath.row];
  NSString *status = data[JDNotificationText];
  
  // show notification
  if (section == 0) {
    if (row == 0) {
      [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:status];
    } else if (row == 1 || row == 2) {
      if(![[JDStatusBarNotificationPresenter sharedPresenter] isVisible]) {
        [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:status];
      }

      if (row == 1) {
        [[JDStatusBarNotificationPresenter sharedPresenter] showProgressBarWithPercentage:0.0];
        [[JDStatusBarNotificationPresenter sharedPresenter] showProgressBarWithPercentage:1.0
                                                                        animationDuration:1.0
                                                                               completion:^(JDStatusBarNotificationPresenter *presenter) {
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [presenter dismissAnimated:YES];
          });
        }];
      } else {
        [[JDStatusBarNotificationPresenter sharedPresenter] showProgressBarWithPercentage:0.33];
      }
    } else if (row == 3) {
      if(![[JDStatusBarNotificationPresenter sharedPresenter] isVisible]) {
        [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:status dismissAfterDelay:3.0];
      }
      [[JDStatusBarNotificationPresenter sharedPresenter] showActivityIndicator:YES];
    } else if (row == 4) {
      [[JDStatusBarNotificationPresenter sharedPresenter] updateStatus:@"Replaced Text.."];
    } else if (row == 5) {
      [[JDStatusBarNotificationPresenter sharedPresenter] dismissAnimated:YES];
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
    
    [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:status
                                                     dismissAfterDelay:3.0
                                                             styleName:style];
  } else if (section == 2) {
    if (row < 2) {
      NSString *style = (row==0) ? SBStyle1 : SBStyle2;
      [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:status styleName:style];

      // show progress after short delay & dismiss on completion
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[JDStatusBarNotificationPresenter sharedPresenter] showProgressBarWithPercentage:1.0
                                                                        animationDuration:1.0
                                                                               completion:^(JDStatusBarNotificationPresenter *presenter){
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [presenter dismissAnimated:YES];
          });
        }];
      });
    } else if (row == 2) {
      JDStatusBarView *view = [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:status];
      [view.textLabel removeFromSuperview];
      UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [[JDStatusBarNotificationPresenter sharedPresenter] dismissAnimated:YES];
      }];
      UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:action];
      button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
      [button setTitle:@"dismiss" forState:UIControlStateNormal];
      [view addSubview:button];
      [button sizeToFit];
      button.center = view.center;
    } else if (row == 3) {
      [[JDStatusBarNotificationPresenter sharedPresenter] showWithStatus:@"This is 1/2!"
                                                               styleName:JDStatusBarStyleDark];
      [[JDStatusBarNotificationPresenter sharedPresenter] showActivityIndicator:YES];
      [[JDStatusBarNotificationPresenter sharedPresenter] dismissAfterDelay:1.0 completion:^(JDStatusBarNotificationPresenter *presenter){
        [presenter showWithStatus:@"✅ This is 2/2!"
                dismissAfterDelay:1.0
                        styleName:JDStatusBarStyleDark];
      }];
    }
  } else if (section == 3) {
    SBCustomStyleViewController* viewController = [[SBCustomStyleViewController alloc] init];
    viewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController:viewController animated:YES];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
