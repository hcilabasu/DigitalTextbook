//
//  ConceptNode.h
//  MIReR
//
//  Created by Andreea Danielescu on 10/15/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

@interface ConceptNode : Node {
	NSString* label; ///< The label for this concept node.
    UIImage* image;
    NSString* imageId;
    Boolean editingText;
}

@property (retain) NSString* label;
@property (retain) UIImage* image;
@property (retain) NSString* imageId;
@property (assign) CGPoint* position;
@property (assign) Boolean editingText;

@end
