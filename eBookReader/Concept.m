//
//  Concept.m
//  eBookReader
//
//  Created by Shang Wang on 4/24/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "Concept.h"

@implementation Concept

@synthesize conceptName;
@synthesize textBookDefinition;
@synthesize subject;
@synthesize textBookIndex;
@synthesize count;


- (id) init
{
    if (self = [super init])
    {
        count=1;
    }
    return self;
}
@end
