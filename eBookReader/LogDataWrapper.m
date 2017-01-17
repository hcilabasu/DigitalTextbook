//
//  LogDataWrapper.m
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "LogDataWrapper.h"

@implementation LogDataWrapper
@synthesize logArray;

- (id)init {
    if ((self = [super init])) {
        logArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addLogs: (LogData*)log{
    
    [logArray addObject:log];
}


-(void)clearAllData{
    [logArray removeAllObjects];
}

@end
