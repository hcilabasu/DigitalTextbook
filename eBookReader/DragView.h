//
//  DragView.h
//  MIReR
//
//  Created by Andreea Danielescu on 9/24/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface DragView : NSView {
@interface DragView : NSObject {
	CGPoint startPoint; ///< The starting point of the click-and-drag action.
	CGPoint diagonalPoint; ///< The current point of the mouse while clicking-and-dragging.  This point is diagonal to the startPoint.
}

@property (assign) CGPoint startPoint;
@property (assign) CGPoint diagonalPoint;

@end
