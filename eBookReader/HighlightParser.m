//
//  PartyParser.m
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "GDataXMLNode.h"
#import "HighLight.h"

@implementation HighlightParser

+ (NSString *)dataFilePath:(BOOL)forSave {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"HLText.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"HLText" ofType:@"xml"];
    }
}

+ (HighLightWrapper *)loadHighlight {
    
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) {
        NSLog(@"Doc Nil!\n");
        return nil;
    }
    
   // NSLog(@"%@", doc.rootElement);
   
    
    HighLightWrapper *party = [[HighLightWrapper alloc] init];
    NSArray *partyMembers = [doc.rootElement elementsForName:@"Player"];
    for (GDataXMLElement *partyMember in partyMembers) {
        NSString *text;
        NSString *color;
        int pageNum;
        int searchCount;
        
        // Name
        NSArray *names = [partyMember elementsForName:@"Text"];
        if (names.count > 0) {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            text = firstName.stringValue;
        } else continue;
        
        
        NSArray *colors = [partyMember elementsForName:@"Color"];
        if (colors.count > 0) {
            GDataXMLElement *firstName = (GDataXMLElement *) [colors objectAtIndex:0];
            color = firstName.stringValue;
        } else continue;
        
        
        // Level
        NSArray *levels = [partyMember elementsForName:@"Page"];
        if (levels.count > 0) {
            GDataXMLElement *firstLevel = (GDataXMLElement *) [levels objectAtIndex:0];
            pageNum = firstLevel.stringValue.intValue;
        } else continue;
        
        // Class
        NSArray *classes = [partyMember elementsForName:@"Count"];
        if (classes.count > 0) {
            GDataXMLElement *firstClass = (GDataXMLElement *) [classes objectAtIndex:0];
            searchCount=firstClass.stringValue.intValue;

        } else continue;
        
        HighLight *player = [[HighLight alloc] initWithName:text pageNum:pageNum count:searchCount color:color];
        [party.players addObject:player];
    }
    return party;
    
}

+ (void)saveHighlight:(HighLightWrapper *)highLight {
    
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"HLText"];
    
    for(HighLight *player in highLight.players) {
        GDataXMLElement * playerElement =
        [GDataXMLNode elementWithName:@"Player"];
        GDataXMLElement * nameElement =
        [GDataXMLNode elementWithName:@"Text" stringValue:player.text];
        GDataXMLElement * colorElement =
        [GDataXMLNode elementWithName:@"Color" stringValue:player.color];

        GDataXMLElement * levelElement =
        [GDataXMLNode elementWithName:@"Page" stringValue:
        [NSString stringWithFormat:@"%d", player.page]];
        GDataXMLElement * classElement =
        [GDataXMLNode elementWithName:@"Count" stringValue:
        [NSString stringWithFormat:@"%d", player.searchCount]];
        
        [playerElement addChild:nameElement];
        [playerElement addChild:colorElement];
        [playerElement addChild:levelElement];
        [playerElement addChild:classElement];
        [partyElement addChild:playerElement];
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                   initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
    
}

@end