//
//  CmapNodeParser.m
//  eBookReader
//
//  Created by Shang Wang on 5/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "CmapNodeParser.h"
#import "GDataXMLNode.h"
#import "CmapNode.h"
#import "CmapNodeWrapper.h"
@implementation CmapNodeParser

+ (NSString *)dataFilePath:(BOOL)forSave {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"CmapNodeList.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"CmapNodeList" ofType:@"xml"];
    }
}



+ (CmapNodeWrapper *)loadCmapNode {
    CmapNodeWrapper *cmapNodeWrapper = [[CmapNodeWrapper alloc] init];
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) {
        NSLog(@"Thumbnail Doc Nil!\n");
        return cmapNodeWrapper;
    }
    // NSLog(@"%@", doc.rootElement);
    NSArray *partyMembers = [doc.rootElement elementsForName:@"CmapNode"];
    if([partyMembers count]==0){
        NSLog(@"Empty!!!!\n\n\n");
    }
    for (GDataXMLElement *partyMember in partyMembers) {
        NSString *conceptName=@"";
        int p_x;
        int p_y;
        NSString *bookTitle=@"";
        int page;
        
        NSArray *titles = [partyMember elementsForName:@"ConceptName"];
        if (titles.count > 0) {
            GDataXMLElement *nameitem = (GDataXMLElement *) [titles objectAtIndex:0];
            conceptName = nameitem.stringValue;
        } else continue;
        
        
        NSArray *booktitles = [partyMember elementsForName:@"BookTitle"];
        if (booktitles.count > 0) {
            GDataXMLElement *titleitem = (GDataXMLElement *) [booktitles objectAtIndex:0];
            bookTitle = titleitem.stringValue;
        } else continue;
        
        NSArray *point_x = [partyMember elementsForName:@"PointX"];
        if (point_x.count > 0) {
            GDataXMLElement *pointXItem = (GDataXMLElement *) [point_x objectAtIndex:0];
            p_x = pointXItem.stringValue.intValue;
        } else continue;
        
        
        NSArray *point_y = [partyMember elementsForName:@"PointY"];
        if (point_y.count > 0) {
            GDataXMLElement *pointYItem = (GDataXMLElement *) [point_y objectAtIndex:0];
            p_y = pointYItem.stringValue.intValue;
        } else continue;
        
        
        NSArray *showPoint_y = [partyMember elementsForName:@"PageNum"];
        if (showPoint_y.count > 0) {
            GDataXMLElement *point_y = (GDataXMLElement *) [showPoint_y objectAtIndex:0];
            page=point_y.stringValue.floatValue;
            
        } else continue;

        
        CmapNode *player = [[CmapNode alloc] initWithName:conceptName bookTitle:bookTitle positionX:p_x positionY:p_y Tag:0 page:page];
        [cmapNodeWrapper.cmapNodes addObject:player];
    }
    return cmapNodeWrapper;
    
}




+ (void)saveCmapNode:(CmapNodeWrapper *)wrapper {
    
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"CmapNodeList"];
    if([wrapper.cmapNodes count]==0){
        NSLog(@"0000000!!");
    }
    
    for(CmapNode *nodeItem in wrapper.cmapNodes) {
        
        GDataXMLElement * itemElement =
        [GDataXMLNode elementWithName:@"CmapNode"];
        
        GDataXMLElement * conceptNameElement =
        [GDataXMLNode elementWithName:@"ConceptName" stringValue:nodeItem.text];
        
        GDataXMLElement * bookTitleElement =
        [GDataXMLNode elementWithName:@"BookTitle" stringValue:nodeItem.bookTitle];
        
        GDataXMLElement * pointX =
        [GDataXMLNode elementWithName:@"PointX" stringValue:
         [NSString stringWithFormat:@"%d", nodeItem.point_x]];

        GDataXMLElement * pointY =
        [GDataXMLNode elementWithName:@"PointY" stringValue:
        [NSString stringWithFormat:@"%d", nodeItem.point_y]];
        
        GDataXMLElement * nodePageNum =
        [GDataXMLNode elementWithName:@"PageNum" stringValue:
         [NSString stringWithFormat:@"%d", nodeItem.pageNum]];
        
  
        [itemElement addChild:conceptNameElement];
        [itemElement addChild:bookTitleElement];
        [itemElement addChild:pointX];
        [itemElement addChild:pointY];
        [itemElement addChild:nodePageNum];
        [partyElement addChild: itemElement];
        NSLog(@"Add element");
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                  initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
    
}

@end
