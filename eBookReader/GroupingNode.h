//
//  GroupingNode.h
//  MIReR
//
//  Created by Andreea Danielescu on 10/7/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

@interface GroupingNode : Node {
	NSMutableArray* children; ///< An array of references to the children of this grouping node.
}

- (NSMutableArray*) children;
- (void) addChild:(NSObject*)child;
- (void) removeChild:(NSObject*)child;

@end
