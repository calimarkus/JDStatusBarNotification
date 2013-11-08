//
//  SBCustomStyleViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 08.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JDStatusBarNotification.h"
#import "FTFontSelectorController.h"
#import "InfColorPicker.h"

#import "SBCustomStyleViewController.h"

@interface SBCustomStyleViewController () <UITextFieldDelegate, FTFontSelectorControllerDelegate, InfColorPickerControllerDelegate>
@property (nonatomic, assign) NSInteger colorMode;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation SBCustomStyleViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.textColorPreview.backgroundColor = self.fontButton.titleLabel.textColor;
    self.barColorPreview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.000];
    self.progressBarColorPreview.backgroundColor = [UIColor redColor];
    
    self.textColorPreview.layer.cornerRadius = self.textColorPreview.frame.size.width/2.0;
    self.barColorPreview.layer.cornerRadius = self.textColorPreview.frame.size.width/2.0;
    self.progressBarColorPreview.layer.cornerRadius = self.textColorPreview.frame.size.width/2.0;
    
    [self updateFontText];
    [self updateStyle];
}

- (void)viewDidLayoutSubviews;
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                             self.lastRow.frame.origin.y + self.lastRow.frame.size.height + 10.0);
}

#pragma mark UI Updates

- (void)updateFontText;
{
    NSString *title = [NSString stringWithFormat: @"%@, %.1fpt",
                       self.fontButton.titleLabel.font.familyName,
                       self.fontButton.titleLabel.font.pointSize];
    [self.fontButton setTitle:title forState:UIControlStateNormal];
    self.textColorPreview.backgroundColor = self.fontButton.titleLabel.textColor;
}

- (void)updateStyle;
{
    [JDStatusBarNotification addStyleNamed:@"style" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        style.font = self.fontButton.titleLabel.font;
        style.textColor = self.textColorPreview.backgroundColor;
        style.barColor = self.barColorPreview.backgroundColor;
        style.progressBarColor = self.progressBarColorPreview.backgroundColor;
        
        return style;
    }];
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
    [self updateFontText];
    [self updateStyle];
}

#pragma mark InfColorPicker

- (void)showColorPicker;
{
    InfColorPickerController *colorController = [InfColorPickerController colorPickerViewController];
    colorController.delegate = self;
    colorController.sourceColor = self.fontButton.titleLabel.textColor;
    colorController.resultColor = self.fontButton.titleLabel.textColor;
    [colorController presentModallyOverViewController:self];
    
    UIView *view = colorController.view;
    colorController.view = [[UIView alloc] initWithFrame:view.frame];
    colorController.view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectOffset(CGRectInset(view.frame, 0, 40), 0, 20);
    [colorController.view addSubview:view];
}

#pragma mark InfColorPickerControllerDelegate

- (void)colorPickerControllerDidChangeColor:(InfColorPickerController *)controller;
{
    switch (self.colorMode) {
        case 0: {
            [self.fontButton setTitleColor:controller.resultColor forState:UIControlStateNormal];
            self.textColorPreview.backgroundColor = controller.resultColor;
            [self updateFontText];
            break;
        }
        case 1: {
            self.barColorPreview.backgroundColor = controller.resultColor;
            break;
        }
        case 2: {
            self.progressBarColorPreview.backgroundColor = controller.resultColor;
            break;
        }
    }
    
    [self updateStyle];
}

- (void)colorPickerControllerDidFinish:(InfColorPickerController *)controller;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Actions

- (IBAction)selectFont:(id)sender;
{
    FTFontSelectorController *fontController = [[FTFontSelectorController alloc] initWithSelectedFontName:self.fontButton.titleLabel.font.fontName];
    [fontController setFontDelegate:self];
    [self presentViewController:fontController
                       animated:YES completion:nil];
}

- (IBAction)selectFontSize:(UIStepper*)sender;
{
    self.fontButton.titleLabel.font = [UIFont fontWithName:self.fontButton.titleLabel.font.fontName size:sender.value];
    [self updateFontText];
    [self updateStyle];
}

- (IBAction)selectTextColor:(id)sender;
{
    self.colorMode = 0;
    [self showColorPicker];
}

- (IBAction)selectBarColor:(id)sender;
{
    self.colorMode = 1;
    [self showColorPicker];
}

- (IBAction)selectAnimationStyle:(id)sender;
{
    
}

- (IBAction)selectProgressBarColor:(id)sender;
{
    self.colorMode = 2;
    [self showColorPicker];
}

- (IBAction)selectProgressBarPosition:(id)sender;
{
    
}

- (IBAction)setProgressBarHeight:(UIStepper*)sender;
{
    
}


- (IBAction)show:(id)sender;
{
    [JDStatusBarNotification showWithStatus:self.textField.text dismissAfter:2.0 styleName:@"style"];
}

- (IBAction)showWithProgress:(id)sender;
{
    [JDStatusBarNotification showWithStatus:self.textField.text dismissAfter:1.3 styleName:@"style"];

    double delayInSeconds = [JDStatusBarNotification isVisible] ? 0.0 : 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.progress = 0.0;
        [self startTimer];
    });
}

#pragma mark Progress Timer

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

@end
