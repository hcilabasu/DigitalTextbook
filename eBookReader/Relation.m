//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class Relation
 * \author Andreea Danielescu
 * \date 9/16/09
 * \brief Subclass of Connection that has a label associated with it.
 *
 *****************************************************************************************************/

#import "Relation.h"

@implementation Relation

@synthesize label;
@synthesize editingText;

- (id) init {
	if (self = [super init])
	{
		[self setLabel:@""];
        editingText = FALSE;
	}
	
	return self;
}

- (void) dealloc {
	//[label release];
	//[super dealloc];
}

@end
