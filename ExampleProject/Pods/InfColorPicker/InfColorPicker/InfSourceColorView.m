//==============================================================================
//
//  InfSourceColorView.m
//  InfColorPicker
//
//  Created by Troy Gaul on 8/10/10.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "InfSourceColorView.h"

//==============================================================================

@implementation InfSourceColorView

//------------------------------------------------------------------------------

@synthesize trackingInside;

//------------------------------------------------------------------------------
#pragma mark	UIView overrides
//------------------------------------------------------------------------------

- (void) drawRect: (CGRect) rect
{
	[ super drawRect: rect ];
	
	if( self.enabled && self.trackingInside ) {
		CGRect bounds = [ self bounds ];
		
		[ [ UIColor whiteColor ] set ];
		CGContextStrokeRectWithWidth( UIGraphicsGetCurrentContext(), 
									  CGRectInset( bounds, 1, 1 ), 2 );
		
		[ [ UIColor blackColor ] set ];
		UIRectFrame( CGRectInset( bounds, 2, 2 ) );
	}
}

//------------------------------------------------------------------------------
#pragma mark	UIControl overrides
//------------------------------------------------------------------------------

- (void) setTrackingInside: (BOOL) newValue
{
	if( newValue != trackingInside ) {
		trackingInside = newValue;
		[ self setNeedsDisplay ];
	}
}

//------------------------------------------------------------------------------

- (BOOL) beginTrackingWithTouch: (UITouch*) touch
					  withEvent: (UIEvent*) event
{
	if( self.enabled ) {
		self.trackingInside = YES;
		
		[ self sendActionsForControlEvents: UIControlEventTouchDown ];
		
		return YES;
	}
	else {
		return NO;
	}
}

//------------------------------------------------------------------------------

- (BOOL) continueTrackingWithTouch: (UITouch*) touch withEvent: (UIEvent*) event
{
	BOOL wasTrackingInside = self.trackingInside;
	BOOL isTrackingInside = CGRectContainsPoint( [ self bounds ], [ touch locationInView: self ] );
	
	self.trackingInside = isTrackingInside;
	
	if( isTrackingInside && !wasTrackingInside ) {
		[ self sendActionsForControlEvents: UIControlEventTouchDragEnter ];
	}
	else if( !isTrackingInside && wasTrackingInside ) {
		[ self sendActionsForControlEvents: UIControlEventTouchDragExit ];
	}
	else if( isTrackingInside ) {
		[ self sendActionsForControlEvents: UIControlEventTouchDragInside ];
	}
	else {
		[ self sendActionsForControlEvents: UIControlEventTouchDragOutside ];
	}

	return YES;
}

//------------------------------------------------------------------------------

- (void) endTrackingWithTouch: (UITouch*) touch withEvent: (UIEvent*) event
{
	self.trackingInside = NO;

	if( CGRectContainsPoint( [ self bounds ], [ touch locationInView: self ] ) ) {
		[ self sendActionsForControlEvents: UIControlEventTouchUpInside ];
	}
	else {
		[ self sendActionsForControlEvents: UIControlEventTouchUpOutside ];
	}
}

//------------------------------------------------------------------------------

- (void) cancelTrackingWithEvent: (UIEvent*) event
{
	self.trackingInside = NO;

	[ self sendActionsForControlEvents: UIControlEventTouchCancel ];
}

//------------------------------------------------------------------------------

@end

//==============================================================================
