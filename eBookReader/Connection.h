//
//  Connection.h
//  MIReR
//
//  Created by Andreea Danielescu on 10/6/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

//link is a link between any 2 objects. Nodes or relations, and doesn't have a label.
#import <UIKit/UIKit.h>

@interface Connection : NSObject {
	NSMutableArray* linkedObjects; ///< An array of objects that this connection links together (usually Node objects).
	NSString* connectionId; ///< The id for this connection.
	CGPoint location; ///< The location in the CmapView of the connection. (The location is the middle of the link).
	BOOL recalculatePos; ///< A boolean indicating whether or not this connection needs its location recalculated. This happens when a Node it connects to is moved, etc.
}

@property (assign) BOOL recalculatePos;
@property (assign) CGPoint location;
@property (retain) NSString* connectionId;

- (NSMutableArray*) linkedObjects;

- (void) addObject: (NSObject*)input;

@end
