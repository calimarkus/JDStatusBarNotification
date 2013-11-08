//
//  SBCustomStyleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 08.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarNotification.h"

#import "SBCustomStyleViewController.h"

@interface SBCustomStyleViewController () <UITextFieldDelegate>
@end

@implementation SBCustomStyleViewController

- (void)viewDidLayoutSubviews;
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                             self.lastRow.frame.origin.y + self.lastRow.frame.size.height + 10.0);
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length == 0) {
        textField.text = @"Notification Text";
    }
    
    return YES;
}

#pragma mark Actions

- (IBAction)selectFont:(id)sender {
}

- (IBAction)selectAnimationStyle:(id)sender {
}

- (IBAction)selectProgressBarColor:(id)sender {
}

- (IBAction)selectProgressBarPosition:(id)sender {
}

- (IBAction)setProgressBarHeight:(id)sender {
    
}

- (IBAction)show:(id)sender {
}

- (IBAction)showWithProgress:(id)sender {
}

@end
