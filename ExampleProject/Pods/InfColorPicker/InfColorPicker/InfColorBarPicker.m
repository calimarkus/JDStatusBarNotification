//==============================================================================
//
//  InfColorBarPicker.m
//  InfColorPicker
//
//  Created by Troy Gaul on 8/9/10.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "InfColorBarPicker.h"

#import "InfColorIndicatorView.h"
#import "InfHSBSupport.h"

//------------------------------------------------------------------------------

#define kContentInsetX 20

//==============================================================================

@implementation InfColorBarView

//------------------------------------------------------------------------------

static CGImageRef createContentImage()
{
	float hsv[] = { 0.0f, 1.0f, 1.0f };
	return createHSVBarContentImage( InfComponentIndexHue, hsv );
}

//------------------------------------------------------------------------------

- (void) drawRect: (CGRect) rect
{
	CGImageRef image = createContentImage();
	
	if( image ) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextDrawImage( context, [ self bounds ], image );
	
		CGImageRelease( image );
	}
}

//------------------------------------------------------------------------------

@end

//==============================================================================

@implementation InfColorBarPicker

//------------------------------------------------------------------------------

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
#pragma mark	Drawing
//------------------------------------------------------------------------------

- (void) layoutSubviews
{
	if( indicator == nil ) {
		CGFloat kIndicatorSize = 24.0f;
		indicator = [ [ InfColorIndicatorView alloc ] initWithFrame: CGRectMake( 0, 0, kIndicatorSize, kIndicatorSize ) ];
		[ self addSubview: indicator ];
	}
	
	indicator.color = [ UIColor colorWithHue: value saturation: 1.0f 
								  brightness: 1.0f alpha: 1.0f ];
	
	CGFloat indicatorLoc = kContentInsetX + ( self.value * ( self.bounds.size.width - 2 * kContentInsetX ) );
	indicator.center = CGPointMake( indicatorLoc, CGRectGetMidY( self.bounds ) );
}

//------------------------------------------------------------------------------
#pragma mark	Properties
//------------------------------------------------------------------------------

- (void) setValue: (float) newValue
{
	if( newValue != value ) {
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
	float percent = ( [ touch locationInView: self ].x - kContentInsetX ) 
				  / ( self.bounds.size.width - 2 * kContentInsetX );
	
	self.value = pin( 0.0f, percent, 1.0f );
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
