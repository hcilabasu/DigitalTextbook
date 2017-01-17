//
//  LogFileController.h
//  eBookReader
//
//  Created by Shang Wang on 7/16/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogData.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"
@interface LogFileController : UIViewController
@property (nonatomic, retain) LogDataWrapper* logDataWrapper;
-(void) writeToTextFile: (NSString*) textString logTimeStampOrNot: (BOOL) isLogTime;
-(NSString*) readContent;
-(void)logHighlightActivity: (NSString*) colorString Text: (NSString*) highlightText PageNumber: (int) pageNum;
@end
