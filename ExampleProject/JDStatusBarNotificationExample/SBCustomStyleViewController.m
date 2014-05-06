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
#import "SBSelectPropertyViewController.h"
#import "InfColorPicker.h"

#import "SBCustomStyleViewController.h"

@interface SBCustomStyleViewController () <UITextFieldDelegate, FTFontSelectorControllerDelegate, InfColorPickerControllerDelegate>
@property (nonatomic, assign) NSInteger colorMode;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) JDStatusBarAnimationType animationType;
@property (nonatomic, assign) JDStatusBarProgressBarPosition progressBarPosition;
@end

@implementation SBCustomStyleViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.animationType = JDStatusBarAnimationTypeMove;
    self.progressBarPosition = JDStatusBarProgressBarPositionBottom;
    
    self.textColorPreview.backgroundColor = self.fontButton.titleLabel.textColor;
    self.barColorPreview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.000];
    self.progressBarColorPreview.backgroundColor = [UIColor redColor];
    
    self.textColorPreview.layer.cornerRadius = round(CGRectGetHeight(self.textColorPreview.frame)/3.0);
    self.barColorPreview.layer.cornerRadius = self.textColorPreview.layer.cornerRadius;
    self.progressBarColorPreview.layer.cornerRadius = self.textColorPreview.layer.cornerRadius;
    
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
    NSString *title = [NSString stringWithFormat: @"Change font (%.1f pt)",
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
        style.animationType = self.animationType;
        
        style.progressBarColor = self.progressBarColorPreview.backgroundColor;
        style.progressBarPosition = self.progressBarPosition;
        
        NSString *height = [self.barHeightLabel.text stringByReplacingOccurrencesOfString:@"ProgressBarHeight (" withString:@""];
        height = [height stringByReplacingOccurrencesOfString:@" pt)" withString:@""];
        style.progressBarHeight = [height doubleValue];
        
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
    
    [self show:nil];
    
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

- (void)showColorPickerWithColor:(UIColor*)color;
{
    InfColorPickerController *colorController = [InfColorPickerController colorPickerViewController];
    colorController.delegate = self;
    colorController.sourceColor = color;
    colorController.resultColor = color;
    [colorController presentModallyOverViewController:self];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *view = colorController.view;
        colorController.view = [[UIView alloc] initWithFrame:view.frame];
        colorController.view.backgroundColor = [UIColor blackColor];
        view.frame = CGRectMake(0, 64, view.bounds.size.width, view.bounds.size.height-64);
        [colorController.view addSubview:view];
    }
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
    [self showColorPickerWithColor:self.textColorPreview.backgroundColor];
}

- (IBAction)selectBarColor:(id)sender;
{
    self.colorMode = 1;
    [self showColorPickerWithColor:self.barColorPreview.backgroundColor];
}

- (IBAction)selectAnimationStyle:(id)sender;
{
    NSArray *data = @[@"JDStatusBarAnimationTypeNone",
                      @"JDStatusBarAnimationTypeMove",
                      @"JDStatusBarAnimationTypeBounce",
                      @"JDStatusBarAnimationTypeFade"];
    SBSelectPropertyViewController *controller = [[SBSelectPropertyViewController alloc] initWithData:data resultBlock:^(NSInteger selectedRow) {
        self.animationType = selectedRow;
        [self.animationStyleButton setTitle:data[selectedRow] forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
        [self updateStyle];
    }];
    controller.title = @"Animation Type";
    controller.activeRow = self.animationType;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)selectProgressBarColor:(id)sender;
{
    self.colorMode = 2;
    [self showColorPickerWithColor:self.progressBarColorPreview.backgroundColor];
}

- (IBAction)selectProgressBarPosition:(id)sender;
{
    NSArray *data = @[@"JDStatusBarProgressBarPositionBottom",
                      @"JDStatusBarProgressBarPositionCenter",
                      @"JDStatusBarProgressBarPositionTop",
                      @"JDStatusBarProgressBarPositionBelow",
                      @"JDStatusBarProgressBarPositionNavBar"];
    SBSelectPropertyViewController *controller = [[SBSelectPropertyViewController alloc] initWithData:data resultBlock:^(NSInteger selectedRow) {
        self.progressBarPosition = selectedRow;
        [self.barPositionButton setTitle:data[selectedRow] forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
        [self updateStyle];
    }];
    controller.title = @"Progress Bar Position";
    controller.activeRow = self.progressBarPosition;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)setProgressBarHeight:(UIStepper*)sender;
{
    if (sender.value < 1) sender.value = 0.5;
    if (sender.value >= 1) sender.value = round(sender.value);
    
    self.barHeightLabel.text = [NSString stringWithFormat: @"ProgressBarHeight (%.1f pt)", sender.value];
    [self updateStyle];
}

#pragma mark Presentation

- (IBAction)show:(id)sender;
{
    [JDStatusBarNotification showWithStatus:self.textField.text dismissAfter:2.0 styleName:@"style"];
}

- (IBAction)showWithProgress:(id)sender;
{
    double delayInSeconds = [JDStatusBarNotification isVisible] ? 0.0 : 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.progress = 0.0;
        [self startTimer];
    });
    
    [JDStatusBarNotification showWithStatus:self.textField.text dismissAfter:1.3 styleName:@"style"];
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
