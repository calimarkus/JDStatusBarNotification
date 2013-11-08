//==============================================================================
//
//  InfColorIndicatorView.m
//  InfColorPicker
//
//  Created by Troy Gaul on 8/10/10.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "InfColorIndicatorView.h"

//==============================================================================

@implementation InfColorIndicatorView

//------------------------------------------------------------------------------

@synthesize color;

//------------------------------------------------------------------------------

- (id) initWithFrame: (CGRect) frame
{
	self = [ super initWithFrame: frame ];
	
	if( self ) {
		self.opaque = NO;
		self.userInteractionEnabled = NO;
	}
	
	return self;
}

//------------------------------------------------------------------------------

- (void) dealloc
{
	[ color release ];
	
	[ super dealloc ];
}

//------------------------------------------------------------------------------

- (void) setColor: (UIColor*) newColor
{
	if( ![ color isEqual: newColor ] ) {
		[ color release ];
		color = [ newColor retain ];
		
		[ self setNeedsDisplay ];
	}
}

//------------------------------------------------------------------------------

- (void) drawRect: (CGRect) rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGPoint center = { CGRectGetMidX( self.bounds ), CGRectGetMidY( self.bounds ) };
	CGFloat radius = CGRectGetMidX( self.bounds );
	
	// Fill it:
	
	CGContextAddArc( context, center.x, center.y, radius - 1.0f, 0.0f, 2.0f * (float) M_PI, YES );
	[ self.color setFill ];
	CGContextFillPath( context );

	// Stroke it (black transucent, inner):
	
	CGContextAddArc( context, center.x, center.y, radius - 1.0f, 0.0f, 2.0f * (float) M_PI, YES );
	CGContextSetGrayStrokeColor( context, 0.0f, 0.5f );
	CGContextSetLineWidth( context, 2.0f );
	CGContextStrokePath( context );

	// Stroke it (white, outer):
	
	CGContextAddArc( context, center.x, center.y, radius - 2.0f, 0.0f, 2.0f * (float) M_PI, YES );
	CGContextSetGrayStrokeColor( context, 1.0f, 1.0f );
	CGContextSetLineWidth( context, 2.0f );
	CGContextStrokePath( context );
}

//------------------------------------------------------------------------------

@end

//==============================================================================
