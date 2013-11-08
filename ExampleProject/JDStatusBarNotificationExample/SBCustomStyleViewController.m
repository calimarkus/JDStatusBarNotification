//
//  SBCustomStyleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 08.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarNotification.h"
#import "FTFontSelectorController.h"
#import "InfColorPicker.h"

#import "SBCustomStyleViewController.h"

@interface SBCustomStyleViewController () <UITextFieldDelegate, FTFontSelectorControllerDelegate>
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

#pragma mark FTFontSelectorControllerDelegate

- (void)fontSelectorControllerShouldBeDismissed:(FTFontSelectorController *)controller;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fontSelectorController:(FTFontSelectorController *)controller didChangeSelectedFontName:(NSString *)fontName;
{
    self.fontButton.titleLabel.font = [UIFont fontWithName:fontName size:self.fontButton.titleLabel.font.pointSize];
//    [self.fontButton setTitleColor:textStylePickerViewController.selectedTextColour forState:UIControlStateNormal];
    
    NSString *title = [NSString stringWithFormat: @"%@, %.1fpt",
                       self.fontButton.titleLabel.font.fontName,
                       self.fontButton.titleLabel.font.pointSize];
    [self.fontButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark Actions

- (IBAction)selectFont:(id)sender
{
    FTFontSelectorController *fontController = [[FTFontSelectorController alloc] initWithSelectedFontName:self.fontButton.titleLabel.font.fontName];
    [fontController setFontDelegate:self];
    [self presentViewController:fontController animated:YES completion:nil];
}

- (IBAction)selectAnimationStyle:(id)sender {
}

- (IBAction)selectProgressBarColor:(id)sender
{
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
