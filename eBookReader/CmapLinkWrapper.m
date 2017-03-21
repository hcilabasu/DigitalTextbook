//
//  CmapLinkWrapper.m
//  eBookReader
//
//  Created by Shang Wang on 6/14/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "CmapLinkWrapper.h"

@implementation CmapLinkWrapper

- (id)init {
    if ((self = [super init])) {
        self.cmapLinks = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addLinks: (CmapLink*)cmaps{
    [self.cmapLinks addObject:cmaps];
}


-(void)clearAllData{
    [self.cmapLinks removeAllObjects];
}

@end
