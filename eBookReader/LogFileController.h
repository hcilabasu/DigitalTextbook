//
//  LogFileController.h
//  eBookReader
//
//  Created by Shang Wang on 7/16/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogFileController : UIViewController


-(void) writeToTextFile: (NSString*) textString logTimeStampOrNot: (BOOL) isLogTime;
-(NSString*) readContent;
-(void)logHighlightActivity: (NSString*) colorString Text: (NSString*) highlightText;
@end
