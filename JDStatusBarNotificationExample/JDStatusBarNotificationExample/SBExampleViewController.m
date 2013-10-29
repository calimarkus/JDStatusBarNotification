//
//  SBExampleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarNotification.h"

#import "SBExampleViewController.h"

static NSString *const SBStyle1 = @"SBStyle1";
static NSString *const SBStyle2 = @"SBStyle2";

@interface SBExampleViewController ()

@end

@implementation SBExampleViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"JDStatusBarNotification";
        
        [JDStatusBarNotification addStyleNamed:SBStyle1
                                       prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                           style.barColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
                                           style.textColor = [UIColor whiteColor];
                                           style.animationType = JDStatusBarAnimationTypeFade;
                                           return style;
                                       }];
        
        [JDStatusBarNotification addStyleNamed:SBStyle2
                                       prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                           style.barColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
                                           style.textColor = [UIColor darkGrayColor];
                                           return style;
                                       }];
    }
    return self;
}

- (IBAction)buttonTouched:(UIButton*)button;
{
    if (button == self.button1) {
        [JDStatusBarNotification showWithStatus:@"Better caul Saul!"];
    } else if (button == self.button2) {
        [JDStatusBarNotification dismiss];
    } else if (button == self.button3) {
        [JDStatusBarNotification showWithStatus:@"You really better caul Saul!"
                                   dismissAfter:2.0
                                      styleName:SBStyle1];
    } else if (button == self.button4) {
        [JDStatusBarNotification showWithStatus:@"Better caul Saul!"
                                   dismissAfter:2.0
                                      styleName:SBStyle2];
    }
}

@end
