//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class GroupingNode
 * \author Andreea Danielescu
 * \date 10/7/09
 * \brief Subclass of Node that is used as a parent or group node for multiple ConceptNode objects.  
 *
 * This node does not have a label.
 *****************************************************************************************************/

#import "GroupingNode.h"

@implementation GroupingNode

- (id) init {
	if ( self = [super init] ) 
	{ 
		children = [[NSMutableArray alloc] init];
        color=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
	} 
	
	return self; 
}
	
- (void) dealloc {
	//[children release];
	//[super dealloc];
}

- (NSMutableArray*) children {
	return children;
}

- (void) addChild:(NSObject*)child{
	[children addObject:child];
}

- (void) removeChild:(NSObject*)child{
    [children removeObject:child];
}
@end
