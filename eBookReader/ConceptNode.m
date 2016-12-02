//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class ConceptNode
 * \author Andreea Danielescu
 * \date 10/15/09
 * \brief The most common type of Node object used in the concept mapping tool.
 *
 * This Node has a label and can be grouped with other ConceptNodes by a GroupingNode.
 *****************************************************************************************************/

#import "ConceptNode.h"


@implementation ConceptNode

@synthesize label;
@synthesize image;
@synthesize imageId;
@synthesize position;
@synthesize editingText;

- (id) init {
	if ( self = [super init] ) 
	{ 
		[self setLabel:@""]; 
        [self setImageId:@""];
        image = [[UIImage alloc] init];
        color=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        editingText = FALSE;
	} 
	
	return self; 
}

- (void) dealloc {
	////[label release];
   // [imageId release];
    //[image release];
	//[super dealloc];
}

@end
