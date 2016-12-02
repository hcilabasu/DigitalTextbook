//
//  LogData.m
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "LogData.h"

@implementation LogData
@synthesize session_id;
@synthesize selection;
@synthesize student_id;
@synthesize time;
@synthesize timeZone;
@synthesize action;
@synthesize input;
@synthesize page;
- (id)initWithName:(NSString*)m_studentId SessionID: (NSString*)m_sessionId action:(NSString*)m_action selection:(NSString*)m_selection input: (NSString*)m_input pageNum: (int) m_page{
    
    if ((self = [super init])) {

        
        NSArray* nsDateArray = [[[NSDate dateWithTimeIntervalSinceNow:0] description] componentsSeparatedByString:@" "];
        // date
        NSString* dateString = [nsDateArray objectAtIndex:0];
        NSArray*  adate = [dateString componentsSeparatedByString:@"-"];
        NSInteger ayear=[[adate objectAtIndex:0] integerValue];
        NSInteger amon=[[adate objectAtIndex:1] integerValue];
        NSInteger aday=[[adate objectAtIndex:2] integerValue];
        aday=aday-1;
        // time
        NSString* timeString = [nsDateArray objectAtIndex:1];
        NSArray*  timeArray = [timeString componentsSeparatedByString:@":"];
        NSInteger ahour=[[timeArray objectAtIndex:0] integerValue];
        ahour=ahour-7;
        if(ahour<0){
            ahour=ahour+24;
        }
        NSInteger amin=[[timeArray objectAtIndex:1] integerValue];
        NSInteger asec=[[timeArray objectAtIndex:2] integerValue];
        
        time= [NSString stringWithFormat:@"%d - %d - %d   %d:%d:%d     ",ayear, amon, aday,ahour,amin,asec];
        student_id=m_studentId;
        session_id=m_selection;
        timeZone=@"UTC";
        
        action=m_action;
        selection=m_selection;
        input=m_input;
        page=m_page+1;
    
    }
    return self;
    
}




- (id)initWithNameAndTime:(NSString*)m_studentId SessionID: (NSString*)m_sessionId action:(NSString*)m_action selection:(NSString*)m_selection input: (NSString*)m_input pageNum: (int) m_page time: (NSString*)m_timeString{
    
    if ((self = [super init])) {
        
        
        NSArray* nsDateArray = [[[NSDate dateWithTimeIntervalSinceNow:0] description] componentsSeparatedByString:@" "];
        // date
        NSString* dateString = [nsDateArray objectAtIndex:0];
        NSArray*  adate = [dateString componentsSeparatedByString:@"-"];
        NSInteger ayear=[[adate objectAtIndex:0] integerValue];
        NSInteger amon=[[adate objectAtIndex:1] integerValue];
        NSInteger aday=[[adate objectAtIndex:2] integerValue];
        aday=aday-1;
        // time
        NSString* timeString = [nsDateArray objectAtIndex:1];
        NSArray*  timeArray = [timeString componentsSeparatedByString:@":"];
        NSInteger ahour=[[timeArray objectAtIndex:0] integerValue];
        ahour=ahour-7;
        if(ahour<0){
            ahour=ahour+24;
        }
        NSInteger amin=[[timeArray objectAtIndex:1] integerValue];
        NSInteger asec=[[timeArray objectAtIndex:2] integerValue];
        
        time= m_timeString;
        student_id=m_studentId;
        session_id=m_selection;
        timeZone=@"UTC";
        
        action=m_action;
        selection=m_selection;
        input=m_input;
        page=m_page;
        
    }
    return self;
    
}



@end

