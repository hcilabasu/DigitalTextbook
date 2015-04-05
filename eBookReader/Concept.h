//
//  Concept.h
//  eBookReader
//
//  Created by Shang Wang on 4/24/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Concept : NSObject


@property (nonatomic) NSString *conceptName; // the name of the concept
@property (nonatomic) NSString *textBookDefinition;// the textbook definition of the concept
@property (nonatomic) NSString *subject; // the subject of the concept: Biology, physics, maths, etc.
@property (nonatomic) NSMutableArray *textBookIndex;// the page/section index of the concept
@property int count;


@end
