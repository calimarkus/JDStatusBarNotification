//==============================================================================
//
//  InfColorBarPicker.h
//  InfColorPicker
//
//  Created by Troy Gaul on 8/9/10.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>

@class InfColorIndicatorView;

//------------------------------------------------------------------------------

@interface InfColorBarView : UIView

@end

//------------------------------------------------------------------------------

@interface InfColorBarPicker : UIControl {
	InfColorIndicatorView* indicator;
}

@property( nonatomic ) float value;

@end

//------------------------------------------------------------------------------
