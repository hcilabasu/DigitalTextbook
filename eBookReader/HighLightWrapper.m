//
//  Party.m
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "HighLightWrapper.h"

@implementation HighLightWrapper
@synthesize players = _players;

- (id)init {
    
    if ((self = [super init])) {
        self.players = [[NSMutableArray alloc] init];
    }
    return self;
    
}

- (void) dealloc {
    self.players = nil;
}

@end