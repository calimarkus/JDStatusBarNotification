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
                                           style.barColor = [UIColor colorWithRed:0.797 green:0.000 blue:0.662 alpha:1.000];
                                           style.textColor = [UIColor whiteColor];
                                           style.animationType = JDStatusBarAnimationTypeFade;
                                           style.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:17.0];
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
        [JDStatusBarNotification showWithStatus:@"No, I don't have the money.."
                                   dismissAfter:2.0
                                      styleName:JDStatusBarStyleError];
    } else if (button == self.button4) {
        [JDStatusBarNotification showWithStatus:@"You know who I am!"
                                   dismissAfter:2.0
                                      styleName:JDStatusBarStyleWarning];
    } else if (button == self.button5) {
        [JDStatusBarNotification showWithStatus:@"That's how we roll!"
                                   dismissAfter:2.0
                                      styleName:JDStatusBarStyleSuccess];
    } else if (button == self.button6) {
        [JDStatusBarNotification showWithStatus:@"Oh, I love it!"
                                   dismissAfter:2.0
                                      styleName:SBStyle1];
    }
}

@end
