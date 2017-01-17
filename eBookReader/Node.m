//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class Node
 * \author Andreea Danielescu
 * \date 9/16/09
 * \brief This class is a superclass of GroupingNode and ConceptNode.
 *
 * It contains code that is relevant to both classes.
 *****************************************************************************************************/

#import "Node.h"

@implementation Node

- (NSString*) nodeId {
	return nodeId;
}

- (CGPoint) location {
	return location;
}

- (UIColor*) color {
	return color;
}

- (CGSize) size{
	return size;
}

- (Node*) parent{
	return parent;
}

- (Boolean) moved {
	return moved;
}

- (void) setId: (NSString*)input {
	//[nodeId autorelease];
	nodeId = input;
}

- (void) setLocation: (CGPoint)input {
	location = input;
}

- (void) setColor: (UIColor*)input {
	//[color autorelease];
	color = input;
}

- (void) setSize: (CGSize) input{
	size = input;
	
	if(size.height < 25)
		size.height = 25;
	
	if(size.width < 50)
		size.width = 50;
}

- (void) setParent: (Node*) input{
	//[parent autorelease];
	parent = input;
}

- (void) setMoved: (Boolean)value{
	moved = value;
}

- (int) compareY: (Node*) othernode {
	if (location.y < [othernode location].y)
		return -1;
	else if (location.y > [othernode location].y)
		return 1;
	else
		return 0;
}

- (int) compareX: (Node*) othernode {
	if (location.x < [othernode location].x)
		return -1;
	else if (location.x > [othernode location].x)
		return 1;
	else
		return 0;	
}

- (id) init {
	if ( self = [super init] ) 
	{ 
		[self setId:@""]; 
		moved = FALSE;
		size = CGSizeMake(100, 50);
		//color = [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		parent = NULL;
	} 
	
	return self; 
}

- (void) dealloc {
	////[nodeId release];
	//[parent release];
    
    //[color release];
    
	//[super dealloc];
}

@end
