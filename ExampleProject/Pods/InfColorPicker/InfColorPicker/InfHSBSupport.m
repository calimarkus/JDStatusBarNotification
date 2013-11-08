//==============================================================================
//
//  InfHSBSupport.m
//  InfColorPicker
//
//  Created by Troy Gaul on 7 Aug 2010.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "InfHSBSupport.h"

//------------------------------------------------------------------------------

float pin( float minValue, float value, float maxValue )
{
	if( minValue > value )
		return minValue;
	else if( maxValue < value )
		return maxValue;
	else
		return value;
}

//------------------------------------------------------------------------------
#pragma mark	Floating point conversion
//------------------------------------------------------------------------------

static void hueToComponentFactors( float h, float* r, float* g, float* b )
{
	float h_prime = h / 60.0f;
	float x = 1.0f - fabsf( fmodf( h_prime, 2.0f ) - 1.0f );
	
	if( h_prime < 1.0f ) {
		*r = 1;
		*g = x;
		*b = 0;
	}
	else if( h_prime < 2.0f ) {
		*r = x;
		*g = 1;
		*b = 0;
	}
	else if( h_prime < 3.0f ) {
		*r = 0;
		*g = 1;
		*b = x;
	}
	else if( h_prime < 4.0f ) {
		*r = 0;
		*g = x;
		*b = 1;
	}
	else if( h_prime < 5.0f ) {
		*r = x;
		*g = 0;
		*b = 1;
	}
	else {
		*r = 1;
		*g = 0;
		*b = x;
	}
}

//------------------------------------------------------------------------------

void HSVtoRGB( float h, float s, float v, float* r, float* g, float* b )
{
	hueToComponentFactors( h, r, g, b );
	
	float c = v * s;
	float m = v - c;

	*r = *r * c + m;
	*g = *g * c + m;
	*b = *b * c + m;
}

//------------------------------------------------------------------------------

void RGBToHSV( float r, float g, float b, float* h, float* s, float* v, BOOL preserveHS )
{		
	float max = r;
	if( max < g )
		max = g;
	if( max < b )
		max = b;
	
	float min = r;
	if( min > g )
		min = g;
	if( min > b )
		min = b;
	
	// Brightness (aka Value)
	
	*v = max;
	
	// Saturation
	
	float sat;
	
	if( max != 0.0f ) {
		sat = ( max - min ) / max;
		*s = sat;
	}
	else {
		sat = 0.0f;
		if( !preserveHS )
			*s = 0.0f;		// Black, so sat is undefined, use 0
	}
	
	// Hue
	
	float delta;
	if( sat == 0.0f ) {
		if( !preserveHS )
			*h = 0.0f;		// No color, so hue is undefined, use 0
	}
	else {
		delta = max - min;
		
		float hue;
		
		if( r == max )
			hue = ( g - b ) / delta;
		else if( g == max )
			hue = 2 + ( b - r ) / delta;
		else
			hue = 4 + ( r - g ) / delta;

		hue /= 6.0f;

		if( hue < 0.0f )
			hue += 1.0f;
		
		if( !preserveHS || fabsf( hue - *h ) != 1.0f )
			*h = hue;	// 0.0 and 1.0 hues are actually both the same (red)
	}
}

//------------------------------------------------------------------------------
#pragma mark	Square/Bar image creation
//------------------------------------------------------------------------------

static UInt8 blend( UInt8 value, UInt8 percentIn255 )
{
	return (UInt8) ( (int) value * percentIn255 / 255 );
}

//------------------------------------------------------------------------------

static CGContextRef createBGRxImageContext( int w, int h, void* data )
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGBitmapInfo kBGRxBitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
		// BGRA is the most efficient on the iPhone.
	
	CGContextRef context = CGBitmapContextCreate( data, w, h, 8, w * 4, colorSpace, kBGRxBitmapInfo );
	
	CGColorSpaceRelease( colorSpace );

	return context;
}

//------------------------------------------------------------------------------

CGImageRef createSaturationBrightnessSquareContentImageWithHue( float hue )
{
	void* data = malloc( 256 * 256 * 4 );
	if( data == nil )
		return nil;
	
	CGContextRef context = createBGRxImageContext( 256, 256, data );
	
	if( context == nil ) {
		free( data );
		return nil;
	}
	
	UInt8* dataPtr = data;
	size_t rowBytes = CGBitmapContextGetBytesPerRow( context );
	
	float r, g, b;
	hueToComponentFactors( hue, &r, &g, &b );
	
	UInt8 r_s = (UInt8) ( ( 1.0f - r ) * 255 );
	UInt8 g_s = (UInt8) ( ( 1.0f - g ) * 255 );
	UInt8 b_s = (UInt8) ( ( 1.0f - b ) * 255 );
	
	for( int s = 0 ; s < 256 ; ++s ) {
		register UInt8* ptr = dataPtr;
		
		register unsigned int r_hs = 255 - blend( s, r_s );
		register unsigned int g_hs = 255 - blend( s, g_s );
		register unsigned int b_hs = 255 - blend( s, b_s );
		
		for( register int v = 255 ; v >= 0 ; --v ) {
			ptr[ 0 ] = (UInt8) ( v * b_hs >> 8 );
			ptr[ 1 ] = (UInt8) ( v * g_hs >> 8 );
			ptr[ 2 ] = (UInt8) ( v * r_hs >> 8 );
			
			// Really, these should all be of the form used in blend(),
			// which does a divide by 255. However, integer divide is
			// implemented in software on ARM, so a divide by 256 
			// (done as a bit shift) will be *nearly* the same value, 
			// and is faster. The more-accurate versions would look like:
			//	ptr[ 0 ] = blend( v, b_hs );
			
			ptr += rowBytes;
		}
		
		dataPtr += 4;
	}
	
		// Return an image of the context's content:
	
	CGImageRef image = CGBitmapContextCreateImage( context );
	
	CGContextRelease( context );
	free( data );
	
	return image;
}

//------------------------------------------------------------------------------

CGImageRef createHSVBarContentImage( InfComponentIndex barComponentIndex, float hsv[ 3 ] )
{
	UInt8 data[ 256 * 4 ];
	
		// Set up the bitmap context for filling with color:
	
	CGContextRef context = createBGRxImageContext( 256, 1, data );
	
	if( context == nil )
		return nil;
	
		// Draw into context here:
	
	UInt8* ptr = CGBitmapContextGetData( context );
	if( ptr == nil ) {
		CGContextRelease( context );
		return nil;
	}
	
	float r, g, b;
	for( int x = 0 ; x < 256 ; ++x ) {
		hsv[ barComponentIndex ] = (float) x / 255.0f;
		
		HSVtoRGB( hsv[ 0 ] * 360.0f, hsv[ 1 ], hsv[ 2 ], &r, &g, &b );
		
		ptr[ 0 ] = (UInt8) ( b * 255.0f );
		ptr[ 1 ] = (UInt8) ( g * 255.0f );
		ptr[ 2 ] = (UInt8) ( r * 255.0f );

		ptr += 4;
	}
	
		// Return an image of the context's content:
	
	CGImageRef image = CGBitmapContextCreateImage( context );
	
	CGContextRelease( context );
	
	return image;
}

//------------------------------------------------------------------------------
