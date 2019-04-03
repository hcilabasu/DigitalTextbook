//
//  LogDataWrapper.h
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogData.h"
@class ExpertModel;
@class CmapController;
@interface LogDataWrapper : NSObject
@property (nonatomic, retain) NSMutableArray *logArray;
@property ExpertModel* expertModel;
@property CmapController* parentCmapController;
-(void)addLogs: (LogData*)log;
-(void)clearAllData;
@end
