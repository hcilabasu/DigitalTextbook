//
//  CmapNodeWrapper.m
//  eBookReader
//
//  Created by Shang Wang on 5/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "CmapNodeWrapper.h"

@implementation CmapNodeWrapper

- (id)init {
    if ((self = [super init])) {
        self.cmapNodes = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addthumbnail: (CmapNode*)cmaps{
    [self.cmapNodes addObject:cmaps];
}

-(void)clearAllData{
    [self.cmapNodes removeAllObjects];
}

@end
