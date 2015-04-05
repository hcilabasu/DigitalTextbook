//
//  Relation.h
//  MIReR
//
//  Created by Andreea Danielescu on 9/16/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Node.h"
#import "Connection.h"

@interface Relation : Connection {
	NSString* label; ///< The label for this relation.
    Boolean editingText;
}

@property (retain) NSString* label;
@property (assign) Boolean editingText;

@end
