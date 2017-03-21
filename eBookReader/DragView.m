//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class DragView
 * \author Andreea Danielescu
 * \date 9/24/09
 * \brief View for drag+select of multiple items in the CmapView. 
 *
 *****************************************************************************************************/

#import "DragView.h"

@implementation DragView

@synthesize startPoint;
@synthesize diagonalPoint;

/*- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	if (self)
	{
		//initialize.
		startPoint = NSMakePoint(0,0);
		diagonalPoint = startPoint;
	}
	return self;
}*/

- (id)init{
	if ( self = [super init] ) 
	{ 
		if (self)
		{
			//initialize.
			startPoint = CGPointMake(0, 0);
			diagonalPoint = startPoint;
		}
	} 
	return self;
}

/*- (void)drawRect:(NSRect)rect
{
	if(startPoint.x != diagonalPoint.x && startPoint.y != diagonalPoint.y)
	{
		NSColor *bgColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.15];

		NSBezierPath *bgPath = [NSBezierPath bezierPath];
    
		//draw rectangle
		[bgPath moveToPoint:startPoint];
		[bgPath lineToPoint:NSMakePoint(startPoint.x, diagonalPoint.y)];
		[bgPath lineToPoint:diagonalPoint];
		[bgPath lineToPoint:NSMakePoint(diagonalPoint.x, startPoint.y)];
		[bgPath lineToPoint:startPoint];
	 
		[bgPath closePath];
    
		[bgColor set];
		[bgPath fill];
	}
}*/

@end
