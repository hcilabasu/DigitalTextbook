//
//  LogData.h
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogData : NSObject
@property (strong, nonatomic) NSString*  student_id;
@property (strong, nonatomic) NSString* session_id;
@property (strong, nonatomic) NSString* time;
@property (strong, nonatomic) NSString* timeZone;
@property (strong, nonatomic) NSString* selection;
@property (strong, nonatomic) NSString* action;
@property (strong, nonatomic) NSString* input;
@property (nonatomic, assign) int page;
- (id)initWithName:(NSString*)m_studentId SessionID: (NSString*)m_sessionId action:(NSString*)m_action selection:(NSString*)m_selection input: (NSString*)m_input pageNum: (int) m_page;
- (id)initWithNameAndTime:(NSString*)m_studentId SessionID: (NSString*)m_sessionId action:(NSString*)m_action selection:(NSString*)m_selection input: (NSString*)m_input pageNum: (int) m_page time: (NSString*)timeString;
@end
