//==============================================================================
//
//  InfHSBSupport.h
//  InfColorPicker
//
//  Created by Troy Gaul on 7 Aug 2010.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>

//------------------------------------------------------------------------------

float pin( float minValue, float value, float maxValue );

//------------------------------------------------------------------------------

	// These functions convert between an RGB value with components in the
	// 0.0f..1.0f range to HSV where Hue is 0 .. 360 and Saturation and 
	// Value (aka Brightness) are percentages expressed as 0.0f..1.0f.
	// 
	// Note that HSB (B = Brightness) and HSV (V = Value) are interchangeable
	// names that mean the same thing. I use V here as it is unambiguous
	// relative to the B in RGB, which is Blue.

void HSVtoRGB( float h, float s, float v, float* r, float* g, float* b );

void RGBToHSV( float r, float g, float b, float* h, float* s, float* v, 
			   BOOL preserveHS );

//------------------------------------------------------------------------------

CGImageRef createSaturationBrightnessSquareContentImageWithHue( float hue );
	// Generates a 256x256 image with the specified constant hue where the
	// Saturation and value vary in the X and Y axes respectively.

//------------------------------------------------------------------------------

typedef enum {
	InfComponentIndexHue = 0,
	InfComponentIndexSaturation = 1,
	InfComponentIndexBrightness = 2,
} InfComponentIndex;

CGImageRef createHSVBarContentImage( InfComponentIndex barComponentIndex, float hsv[ 3 ] );
	// Generates an image where the specified barComponentIndex (0=H, 1=S, 2=V)
	// varies across the x-axis of the 256x1 pixel image and the other components
	// remain at the constant value specified in the hsv array.

//------------------------------------------------------------------------------
