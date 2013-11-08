//
//  SBCustomStyleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 08.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarNotification.h"
#import "CMTextStylePickerViewController.h"
#import "InfColorPicker.h"

#import "SBCustomStyleViewController.h"

@interface SBCustomStyleViewController () <UITextFieldDelegate, CMTextStylePickerViewControllerDelegate>
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

#pragma mark CMTextStylePickerViewControllerDelegate

- (void)textStylePickerViewControllerIsDone:(CMTextStylePickerViewController *)textStylePickerViewController;
{
    self.fontButton.titleLabel.font = textStylePickerViewController.selectedFont;
    [self.fontButton setTitleColor:textStylePickerViewController.selectedTextColour forState:UIControlStateNormal];;
    
    NSString *title = [NSString stringWithFormat: @"%@, %.1fpt", textStylePickerViewController.selectedFont.fontName, textStylePickerViewController.selectedFont.pointSize];
    [self.fontButton setTitle:title forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Actions

- (IBAction)selectFont:(id)sender
{
    CMTextStylePickerViewController *fontController = [CMTextStylePickerViewController textStylePickerViewController];
    fontController.delegate = self;
    fontController.selectedFont = self.fontButton.titleLabel.font;
    fontController.selectedTextColour = self.fontButton.titleLabel.textColor;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:fontController] animated:YES completion:nil];
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
