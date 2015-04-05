//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class Connection
 * \author Andreea Danielescu
 * \date 10/6/09
 * \brief Connects two Node objects of any type. Does not have a label. Superclass to a Relation.
 *
 *****************************************************************************************************/

#import "Connection.h"

@implementation Connection

@synthesize recalculatePos;
@synthesize location;
@synthesize connectionId;

- (NSMutableArray*) linkedObjects {
	return linkedObjects;
}

- (void) addObject: (NSObject*)input{
	[linkedObjects addObject:input];
}

- (id) init {
	if (self = [super init])
	{
		[self setConnectionId:@""];
		linkedObjects = [[NSMutableArray alloc] init];
		recalculatePos = TRUE;
	}
	
	return self;
}

- (void) dealloc {
	//[linkedObjects release];
    //[connectionId release];
	//[super dealloc];
}

@end
