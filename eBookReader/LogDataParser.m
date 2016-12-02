//
//  LogDataParser.m
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "LogDataParser.h"
#import "GDataXMLNode.h"
@implementation LogDataParser



+ (NSString *)dataFilePath:(BOOL)forSave {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"LogData.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"LogData" ofType:@"xml"];
    }
}


+ (LogDataWrapper *)loadLogData{
    
    LogDataWrapper *logDatakWrapper = [[LogDataWrapper alloc] init];
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) {
        NSLog(@"LogData Doc Nil!\n");
        return logDatakWrapper;
    }
    

   //  NSArray *partyMembers = [doc.rootElement elementsForName:@"tutor_related_message_sequence  context_message_id=\"B7AE5D-B8B9-3AAA-0B01-26CAA3302205\""];
    NSString* isPreview=[[NSUserDefaults standardUserDefaults] stringForKey:@"isPreview"];
    NSArray *partyMembers;
    partyMembers = [doc.rootElement elementsForName:@"tool_message"];
    /*
    if([isPreview isEqualToString:@"YES"]){
    
    partyMembers = [doc.rootElement elementsForName:@"tool_message"];
    }else{
    partyMembers = [doc.rootElement elementsForName:@"tutor_related_message_sequence  context_message_id=\"B7AE5D-B8B9-3AAA-0B01-26CAA3302205\""];
    }*/
    
    if([partyMembers count]==0){
        NSLog(@"Empty!!!!\n\n\n");
    }
    
    for (GDataXMLElement *partyMember in partyMembers) {
        int page=0;
         NSString*  student_id=@"";
         NSString* session_id=@"";
         NSString* time=@"";
         NSString* timeZone=@"";
         NSString* selection=@"";
         NSString* action=@"";
         NSString* input=@"";
        
        
        NSArray *savedTime = [partyMember elementsForName:@"time"];
        
        GDataXMLElement *savedTimeElement = (GDataXMLElement *) [savedTime objectAtIndex:0];
        NSString *savedTimeString = savedTimeElement.stringValue;
     
        
        NSArray *l_name = [partyMember elementsForName:@"user_id"];
        if (l_name.count > 0) {
            GDataXMLElement *nameitem = (GDataXMLElement *) [l_name objectAtIndex:0];
            student_id = nameitem.stringValue;
        } else continue;
        
        NSArray *r_name = [partyMember elementsForName:@"session_id"];
        if (r_name.count > 0) {
            GDataXMLElement *titleitem = (GDataXMLElement *) [r_name objectAtIndex:0];
            session_id = titleitem.stringValue;
        } else continue;
        
        NSArray *relation_name = [partyMember elementsForName:@"time"];
        if (relation_name.count > 0) {
            GDataXMLElement *titleitem = (GDataXMLElement *) [relation_name objectAtIndex:0];
            time = titleitem.stringValue;
        } else continue;
        
        NSArray *time_zone = [partyMember elementsForName:@"time_zone"];
        if (time_zone.count > 0) {
            GDataXMLElement *titleitem = (GDataXMLElement *) [time_zone objectAtIndex:0];
            timeZone = titleitem.stringValue;
        } else continue;
        
        NSArray *s_selection = [partyMember elementsForName:@"selection"];
        if (s_selection.count > 0) {
            GDataXMLElement *titleitem = (GDataXMLElement *) [s_selection objectAtIndex:0];
            selection = titleitem.stringValue;
        } else continue;
        
        NSArray *s_action = [partyMember elementsForName:@"action"];
        if (s_action.count > 0) {
            GDataXMLElement *titleitem = (GDataXMLElement *) [s_action objectAtIndex:0];
            action = titleitem.stringValue;
        } else continue;
        
        NSArray *s_input = [partyMember elementsForName:@"action"];
        if (s_input.count > 0) {
            GDataXMLElement *titleitem = (GDataXMLElement *) [s_input objectAtIndex:0];
            input = titleitem.stringValue;
        } else continue;
        
        NSArray *i_page = [partyMember elementsForName:@"PageNum"];
        if (i_page.count > 0) {
            GDataXMLElement *point_y = (GDataXMLElement *) [i_page objectAtIndex:0];
            page=point_y.stringValue.floatValue;
        } else continue;
        
        LogData *player = [[LogData alloc] initWithNameAndTime:student_id SessionID:session_id  action:action selection:selection input:input pageNum:page time:savedTimeString];
        
        [logDatakWrapper.logArray addObject:player];
    }
    return logDatakWrapper;
}


+ (void)saveLogData:(LogDataWrapper *)LogDatas{
    
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"LogData"];
    
    //GDataXMLElement * attibute = [GDataXMLNode attributeWithName:@"context_message_id" stringValue:@"B7AE5D-B8B9-3AAA-0B01-26CAA3302205"];
   // [partyElement addAttribute:attibute];
    
    if([LogDatas.logArray count]==0){
        NSLog(@"logdata empty!!");
    }
    
    for(LogData *linkItem in LogDatas.logArray) {
        
        GDataXMLElement * itemElement =
        [GDataXMLNode elementWithName:@"tool_message"];
        
        GDataXMLElement * e_userId =
        [GDataXMLNode elementWithName:@"user_id" stringValue:linkItem.student_id];
        
        GDataXMLElement * e_sessionId =
        [GDataXMLNode elementWithName:@"session_id" stringValue:linkItem.session_id];
        
        GDataXMLElement * e_time =
        [GDataXMLNode elementWithName:@"time" stringValue:linkItem.time];
        
        GDataXMLElement * e_timeZone =
        [GDataXMLNode elementWithName:@"time_zone" stringValue:linkItem.timeZone];
        
        GDataXMLElement * e_selection =
        [GDataXMLNode elementWithName:@"selection" stringValue:linkItem.selection];
        
        GDataXMLElement * e_action =
        [GDataXMLNode elementWithName:@"action" stringValue:linkItem.action];
        
        GDataXMLElement * e_input =
        [GDataXMLNode elementWithName:@"input" stringValue:linkItem.input];
        
        NSString* pageStr=[[NSString alloc]initWithFormat:@"%d", linkItem.page];
        GDataXMLElement * e_page =[GDataXMLNode elementWithName:@"PageNum" stringValue:pageStr];

        
        [itemElement addChild:e_userId];
        [itemElement addChild:e_sessionId];
        [itemElement addChild:e_time];
        [itemElement addChild:e_timeZone];
        [itemElement addChild:e_selection];
        [itemElement addChild:e_action];
        [itemElement addChild:e_input];
        [itemElement addChild:e_page];
        [partyElement addChild:itemElement];
       // NSLog(@"Add element");
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                  initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    NSString *filePath = [self dataFilePath:TRUE];
    //NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
 
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LogData.xml",
                          documentsDirectory];
    NSString *content1 = [[NSString alloc] initWithContentsOfFile:filePath
                                                    usedEncoding:nil
                                                           error:nil];
   // NSLog(content1);
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
                                                    usedEncoding:nil
                                                           error:nil];
}


@end
