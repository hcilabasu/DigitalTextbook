//
//  LogDataParser.h
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogData.h"
#import "LogDataWrapper.h"

@interface LogDataParser : NSObject
+ (LogDataWrapper *)loadLogData;
+ (void)saveLogData:(LogDataWrapper *)LogDatas;
@end
