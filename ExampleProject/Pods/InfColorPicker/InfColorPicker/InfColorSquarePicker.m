//==============================================================================
//
//  InfColorSquarePicker.m
//  InfColorPicker
//
//  Created by Troy Gaul on 8/9/10.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "InfColorSquarePicker.h"

#import "InfColorIndicatorView.h"
#import "InfHSBSupport.h"

//------------------------------------------------------------------------------

#define kContentInsetX 20
#define kContentInsetY 20

#define kIndicatorSize 24

//==============================================================================

@implementation InfColorSquareView

//------------------------------------------------------------------------------

@synthesize hue;

//------------------------------------------------------------------------------

- (void) updateContent
{
	CGImageRef imageRef = createSaturationBrightnessSquareContentImageWithHue( hue * 360 );
	self.image = [ UIImage imageWithCGImage: imageRef ];
	CGImageRelease( imageRef );
}

//------------------------------------------------------------------------------
#pragma mark	Properties
//------------------------------------------------------------------------------

- (void) setHue: (float) value
{
	if( value != hue || self.image == nil ) {
		hue = value;
		
		[ self updateContent ];
	}
}

//------------------------------------------------------------------------------

@end

//==============================================================================

@implementation InfColorSquarePicker

//------------------------------------------------------------------------------

@synthesize hue;
@synthesize value;

//------------------------------------------------------------------------------
#pragma mark	Lifetime
//------------------------------------------------------------------------------

- (void) dealloc
{
	[ indicator release ];
	
	[ super dealloc ];
}

//------------------------------------------------------------------------------
#pragma mark	Appearance
//------------------------------------------------------------------------------

- (void) setIndicatorColor
{
	if( indicator == nil )
		return;
	
	indicator.color = [ UIColor colorWithHue: hue saturation: value.x 
								  brightness: value.y alpha: 1.0f ];
}

//------------------------------------------------------------------------------

- (void) layoutSubviews
{
	if( indicator == nil ) {
		CGRect indicatorRect = { CGPointZero, { kIndicatorSize, kIndicatorSize } };
		indicator = [ [ InfColorIndicatorView alloc ] initWithFrame: indicatorRect ];
		[ self addSubview: indicator ];
	}
	
	[ self setIndicatorColor ];
	
	CGFloat indicatorX = kContentInsetX + ( self.value.x * ( self.bounds.size.width - 2 * kContentInsetX ) );
	CGFloat indicatorY = self.bounds.size.height - kContentInsetY 
									    - ( self.value.y * ( self.bounds.size.height - 2 * kContentInsetY ) );
	
	indicator.center = CGPointMake( indicatorX, indicatorY );
}

//------------------------------------------------------------------------------
#pragma mark	Properties
//------------------------------------------------------------------------------

- (void) setHue: (float) newValue
{
	if( newValue != hue ) {
		hue = newValue;
		
		[ self setIndicatorColor ];
	}
}

//------------------------------------------------------------------------------

- (void) setValue: (CGPoint) newValue
{
	if( !CGPointEqualToPoint( newValue, value ) ) {
		value = newValue;
		
		[ self sendActionsForControlEvents: UIControlEventValueChanged ];
		[ self setNeedsLayout ];
	}
}

//------------------------------------------------------------------------------
#pragma mark	Tracking
//------------------------------------------------------------------------------

- (void) trackIndicatorWithTouch: (UITouch*) touch 
{
	CGRect bounds = self.bounds;
	
	CGPoint touchValue;
	touchValue.x = ( [ touch locationInView: self ].x - kContentInsetX ) 
				   / ( bounds.size.width - 2 * kContentInsetX );
	
	touchValue.y = ( [ touch locationInView: self ].y - kContentInsetY ) 
				   / ( bounds.size.height - 2 * kContentInsetY );
	
	touchValue.x = pin( 0.0f, touchValue.x, 1.0f );
	touchValue.y = 1.0f - pin( 0.0f, touchValue.y, 1.0f );
	
	self.value = touchValue;
}

//------------------------------------------------------------------------------

- (BOOL) beginTrackingWithTouch: (UITouch*) touch
					  withEvent: (UIEvent*) event
{
	[ self trackIndicatorWithTouch: touch ];
	return YES;
}

//------------------------------------------------------------------------------

- (BOOL) continueTrackingWithTouch: (UITouch*) touch 
						 withEvent: (UIEvent*) event
{
	[ self trackIndicatorWithTouch: touch ];
	return YES;
}

//------------------------------------------------------------------------------

@end

//==============================================================================
