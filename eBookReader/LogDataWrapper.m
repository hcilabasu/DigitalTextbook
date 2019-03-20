//
//  LogDataWrapper.m
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "LogDataWrapper.h"
#import "CmapController.h"
#import "BookPageViewController.h"
@implementation LogDataWrapper
@synthesize logArray;
@synthesize expertModel;
@synthesize parentCmapController;
- (id)init {
    if ((self = [super init])) {
        logArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)addLogs: (LogData*)log{
    [logArray addObject:log];
    parentCmapController.parentBookPageViewController.expertModel.parentCmapController=parentCmapController;
    parentCmapController.parentBookPageViewController.expertModel.logArray=logArray;
    parentCmapController.parentBookPageViewController.expertModel.bookNodeWrapper=parentCmapController.bookNodeWrapper;
    parentCmapController.parentBookPageViewController.expertModel.bookLinkWrapper=parentCmapController.bookLinkWrapper;
    
    [parentCmapController.parentBookPageViewController.expertModel evaluate];
}


-(void)clearAllData{
    [logArray removeAllObjects];
}

@end
