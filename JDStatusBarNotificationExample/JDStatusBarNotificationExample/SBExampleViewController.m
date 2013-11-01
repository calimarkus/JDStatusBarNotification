//
//  SBExampleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarNotification.h"

#import "SBExampleViewController.h"

static NSString *const JDButtonName = @"JDButtonName";
static NSString *const JDButtonInfo = @"JDButtonInfo";
static NSString *const JDNotificationText = @"JDNotificationText";

static NSString *const SBStyle1 = @"SBStyle1";

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
        self.title = @"JDStatusBarNotification";
        
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
        
        self.data = @[@[@{JDButtonName:@"Show Notification", JDButtonInfo:@"Default Style", JDNotificationText:@"Better call Saul!"},
                        @{JDButtonName:@"Show Progress", JDButtonInfo:@"0-100% in 1s", JDNotificationText:@""},
                        @{JDButtonName:@"Dismiss Notification", JDButtonInfo:@"Animated", JDNotificationText:@""}],
                      @[@{JDButtonName:@"Show JDStatusBarStyleError", JDButtonInfo:@"Duration: 2s", JDNotificationText:@"No, I don't have the money.."},
                        @{JDButtonName:@"Show JDStatusBarStyleWarning", JDButtonInfo:@"Duration: 2s", JDNotificationText:@"You know who I am!"},
                        @{JDButtonName:@"Show JDStatusBarStyleSuccess", JDButtonInfo:@"Duration: 2s", JDNotificationText:@"That's how we roll!"},
                        @{JDButtonName:@"Show JDStatusBarStyleDark", JDButtonInfo:@"Duration: 2s", JDNotificationText:@"Don't mess with me!"}],
                      @[@{JDButtonName:@"Show custom style", JDButtonInfo:@"Duration: 2s, JDStatusBarAnimationTypeFade", JDNotificationText:@"Oh, I love it!"}]];
    }
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1.0];
    self.tableView.backgroundView = nil;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.data[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
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
    
    // show notification
    if (section == 0 && row == 0) {
        [JDStatusBarNotification showWithStatus:status];
    } else if (section == 0 && row == 1) {
        self.progress = 0.0;
        [self startTimer];
    }  else if (section == 0 && row == 2) {
        [JDStatusBarNotification dismiss];
    } else if (section == 1) {
        NSString *style = JDStatusBarStyleError;
        if (row == 1) {
            style = JDStatusBarStyleWarning;
        } else if(row == 2) {
            style = JDStatusBarStyleSuccess;
        } else if(row == 3) {
            style = JDStatusBarStyleDark;
        }
        
        [JDStatusBarNotification showWithStatus:status
                                   dismissAfter:2.0
                                      styleName:style];
    } else if (section == 2 && row == 0) {
        [JDStatusBarNotification showWithStatus:status
                                   dismissAfter:2.0
                                      styleName:SBStyle1];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)startTimer;
{
    [JDStatusBarNotification showProgress:self.progress];
    
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
    [JDStatusBarNotification showProgress:0.0];
}

#pragma mark rotation

- (BOOL)shouldAutorotate; { return YES; }
- (NSUInteger)supportedInterfaceOrientations { return UIInterfaceOrientationMaskAll; }
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; { return YES; }

@end
