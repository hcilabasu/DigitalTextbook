//
//  Node.h
//  MIReR
//
//  Created by Andreea Danielescu on 9/16/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Node : NSObject {
	CGPoint location; ///< The location (center point) of the node.
	CGSize size; ///< The size of the node.
	UIColor* color; ///< The color of the node. Default is white.
	NSString* nodeId; ///< The id of the node.
	Node* parent; ///< The node's parent (GroupingNode), if it has one.
	Boolean moved; ///< A boolean the node was moved and locations need to be recalculated.
}

- (NSString*) nodeId;
- (CGPoint) location;
- (CGSize) size;
- (UIColor*) color;
- (Node*) parent;
- (Boolean) moved;

- (void) setId: (NSString*)input;
- (void) setLocation: (CGPoint)location;
- (void) setSize: (CGSize) size;
- (void) setColor: (UIColor*) color;
- (void) setParent: (Node*) parent;
- (void) setMoved: (Boolean)value;

- (int) compareY: (Node*) othernode;
- (int) compareX: (Node*) othernode;

@end
