//
//  SBCustomStyleViewController.h
//  JDStatusBarNotificationExample
//
//  Created by Markus on 08.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBCustomStyleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *fontButton;
@property (weak, nonatomic) IBOutlet UIView *textColorPreview;
@property (weak, nonatomic) IBOutlet UIView *barColorPreview;
@property (weak, nonatomic) IBOutlet UIButton *animationStyleButton;
@property (weak, nonatomic) IBOutlet UIView *progressBarColorPreview;
@property (weak, nonatomic) IBOutlet UIButton *barPositionButton;
@property (weak, nonatomic) IBOutlet UILabel *barHeightLabel;
@property (weak, nonatomic) IBOutlet UIView *lastRow;

- (IBAction)selectFont:(id)sender;
- (IBAction)selectFontSize:(UIStepper*)sender;
- (IBAction)selectTextColor:(id)sender;
- (IBAction)selectBarColor:(id)sender;
- (IBAction)selectAnimationStyle:(id)sender;
- (IBAction)selectProgressBarColor:(id)sender;
- (IBAction)selectProgressBarPosition:(id)sender;
- (IBAction)setProgressBarHeight:(UIStepper*)sender;

- (IBAction)show:(id)sender;
- (IBAction)showWithProgress:(id)sender;

@end
