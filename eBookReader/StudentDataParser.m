//
//  LogDataParser.m
//  eBookReader
//
//  Created by Shang Wang on 10/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "StudentDataWrapper.h"
#import "StudentDataParser.h"
#import "GDataXMLNode.h"
@implementation StudentDataParser



+ (NSString *)dataFilePath:(BOOL)forSave {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"StudentDataList.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"StudentDataList.xml" ofType:@"xml"];
    }
}


+ (StudentDataWrapper *)loadLogData{
    StudentDataWrapper *stuDataWrapper = [[StudentDataWrapper alloc] init];
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) {
        NSLog(@"studentData Nil!\n");
        return stuDataWrapper;
    }
    // NSLog(@"%@", doc.rootElement);
    NSArray *partyMembers = [doc.rootElement elementsForName:@"StudentData"];
    if([partyMembers count]==0){
        NSLog(@"Empty!!!!\n\n\n");
    }
    for (GDataXMLElement *partyMember in partyMembers) {
        NSString *Name=@"";
        NSString *Password=@"";
        
        NSArray *m_name = [partyMember elementsForName:@"name"];
        if (m_name.count > 0) {
            GDataXMLElement *nameitem = (GDataXMLElement *) [m_name objectAtIndex:0];
            Name = nameitem.stringValue;
        } else continue;
        
        NSArray *m_password = [partyMember elementsForName:@"password"];
        if (m_password.count > 0) {
            GDataXMLElement *pswditem = (GDataXMLElement *) [m_password objectAtIndex:0];
            Password = pswditem.stringValue;
        } else continue;
        
        StudentData *player = [[StudentData alloc]initWithName:Name Password:Password];
        [stuDataWrapper.studentDataArray  addObject:player];
    }
    return stuDataWrapper;
}


+ (void)saveLogData:(StudentDataWrapper *)wrapper{
    
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"StudentDataList"];
    if([wrapper.studentDataArray count]==0){
        NSLog(@"0000000!!");
    }
    
    for(StudentData *studentItem in wrapper.studentDataArray) {
        
        GDataXMLElement * itemElement =
        [GDataXMLNode elementWithName:@"StudentData"];
        
        GDataXMLElement * m_name =
        [GDataXMLNode elementWithName:@"name" stringValue:studentItem.name];
        
        GDataXMLElement * m_password =
        [GDataXMLNode elementWithName:@"password" stringValue:studentItem.password];

        
        [itemElement addChild:m_name];
        [itemElement addChild:m_password];
        [partyElement addChild:itemElement];
        // NSLog(@"Add element");
        
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                  initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    NSString *filePath = [self dataFilePath:TRUE];
    //NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];

}


@end
