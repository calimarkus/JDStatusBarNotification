//==============================================================================
//
//  InfColorPickerController.h
//  InfColorPicker
//
//  Created by Troy Gaul on 7 Aug 2010.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>

@class InfColorBarView;
@class InfColorSquareView;
@class InfColorBarPicker;
@class InfColorSquarePicker;

@protocol InfColorPickerControllerDelegate;

//------------------------------------------------------------------------------

@interface InfColorPickerController : UIViewController {
	float hue;
	float saturation;
	float brightness;
}

	// Public API:

+ (InfColorPickerController*) colorPickerViewController;
+ (CGSize) idealSizeForViewInPopover;

- (void) presentModallyOverViewController: (UIViewController*) controller;

@property( retain, nonatomic ) UIColor* sourceColor;
@property( retain, nonatomic ) UIColor* resultColor;

@property( assign, nonatomic ) id< InfColorPickerControllerDelegate > delegate;

	// IB outlets:

@property( retain, nonatomic ) IBOutlet InfColorBarView* barView;
@property( retain, nonatomic ) IBOutlet InfColorSquareView* squareView;
@property( retain, nonatomic ) IBOutlet InfColorBarPicker* barPicker;
@property( retain, nonatomic ) IBOutlet InfColorSquarePicker* squarePicker;
@property( retain, nonatomic ) IBOutlet UIView* sourceColorView;
@property( retain, nonatomic ) IBOutlet UIView* resultColorView;
@property( retain, nonatomic ) IBOutlet UINavigationController* navController;

@end

//------------------------------------------------------------------------------

@protocol InfColorPickerControllerDelegate

@optional

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) controller;
	// This is only called when the color picker is presented modally.

- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) controller;

@end

//------------------------------------------------------------------------------
