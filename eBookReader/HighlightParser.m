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
        HighLightWrapper *highlightWrapper = [[HighLightWrapper alloc] init];
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) {
        NSLog(@"Doc Nil!\n");
        return highlightWrapper;
    }
    NSArray *partyMembers = [doc.rootElement elementsForName:@"Highlight"];
    for (GDataXMLElement *partyMember in partyMembers) {
         NSString *bookTitle;
        NSString *text;
        NSString *color;
        int pageNum;
        int searchCount;
        int startContainer;
        int startOffset;
        int endContainer;
        int endOffset;
        
        NSArray *title = [partyMember elementsForName:@"BookTitle"];
        if (title.count > 0) {
            GDataXMLElement *firstTitle = (GDataXMLElement *) [title objectAtIndex:0];
            bookTitle = firstTitle.stringValue;
        } else continue;
        
        
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
        
        NSArray *startContainerArray = [partyMember elementsForName:@"StartContainer"];
        if (startContainerArray.count > 0) {
            GDataXMLElement *element_sc = (GDataXMLElement *) [startContainerArray objectAtIndex:0];
            startContainer=element_sc.stringValue.intValue;
        } else continue;
        
        
        NSArray *startOffsetArray = [partyMember elementsForName:@"StartOffset"];
        if (startOffsetArray.count > 0) {
            GDataXMLElement *element_sf = (GDataXMLElement *) [startOffsetArray objectAtIndex:0];
            startOffset=element_sf.stringValue.intValue;
            
        } else continue;
        
        NSArray *endContainerArray = [partyMember elementsForName:@"EndContainer"];
        if (endContainerArray.count > 0) {
            GDataXMLElement *element_ec = (GDataXMLElement *) [endContainerArray objectAtIndex:0];
            endContainer=element_ec.stringValue.intValue;
        } else continue;
        
        NSArray *endOffsetArray = [partyMember elementsForName:@"EndOffset"];
        if (endOffsetArray.count > 0) {
            GDataXMLElement *element_ef = (GDataXMLElement *) [endOffsetArray objectAtIndex:0];
            endOffset=element_ef.stringValue.intValue;
        } else continue;
        
        HighLight *player = [[HighLight alloc] initWithName:text pageNum:pageNum count:searchCount color:color startContainer:startContainer startOffset:startOffset endContainer:endContainer endOffset:endOffset bookTitle:bookTitle ];
        [highlightWrapper.highLights addObject:player];
    }
    return highlightWrapper;
    
}

+ (void)saveHighlight:(HighLightWrapper *)highLight {
    
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"HLText"];
    
    for(HighLight *player in highLight.highLights) {
        
        
        GDataXMLElement * playerElement =
        [GDataXMLNode elementWithName:@"Highlight"];
        
        GDataXMLElement * titleElement =
        [GDataXMLNode elementWithName:@"BookTitle" stringValue:player.bookTitle];
        
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
        
        GDataXMLElement * startContainerElement =
        [GDataXMLNode elementWithName:@"StartContainer" stringValue:
         [NSString stringWithFormat:@"%d", player.startContainer]];
        
        GDataXMLElement * startOffsetElement =
        [GDataXMLNode elementWithName:@"StartOffset" stringValue:
         [NSString stringWithFormat:@"%d", player.startOffset]];
        
        GDataXMLElement * endContainerElement =
        [GDataXMLNode elementWithName:@"EndContainer" stringValue:
         [NSString stringWithFormat:@"%d", player.endContainer]];
        
        GDataXMLElement * endOffsetElement =
        [GDataXMLNode elementWithName:@"EndOffset" stringValue:
         [NSString stringWithFormat:@"%d", player.endOffset]];
        
        [playerElement addChild:titleElement];
        [playerElement addChild:nameElement];
        [playerElement addChild:colorElement];
        [playerElement addChild:levelElement];
        [playerElement addChild:classElement];
        [playerElement addChild:startContainerElement];
        [playerElement addChild:startOffsetElement];
        [playerElement addChild:endContainerElement];
        [playerElement addChild:endOffsetElement];
        
        [partyElement addChild:playerElement];
    
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                   initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    //NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
    
}

@end