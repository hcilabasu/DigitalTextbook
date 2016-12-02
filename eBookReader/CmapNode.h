//
//  CmapNode.h
//  eBookReader
//
//  Created by Shang Wang on 5/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmapNode : NSObject

@property (assign)CGPoint showPoint;

@property (strong, nonatomic)  NSString *text;
@property int pageNum;
@property int point_x;
@property int point_y;
@property CGPoint bookPagePosition;
@property (strong, nonatomic) NSMutableArray*  relatedNodesArray;
@property (strong, nonatomic) NSMutableArray*  linkLayerArray;
@property (strong, nonatomic) NSMutableArray*  relationTextArray;
@property (strong, nonatomic) NSURL* linkingUrl; // linking url for web browser
@property (strong, nonatomic) NSString* linkingUrlTitle; //title of linking url
@property (assign, nonatomic) BOOL* hasNote; // Made manually
@property (assign, nonatomic) BOOL* hasWebLink; // Made from web browser
@property (assign, nonatomic) BOOL* hasHighlight; // Made from book
@property (strong, nonatomic) NSString* savedNotesString; //for taking notes on the concept
//@property (nonatomic, retain) HighLightWrapper *bookHighLight;//the highlight wrapper pased from the bookviewcontroller to control the highlight info in the book
//@property (nonatomic, retain) ThumbNailIconWrapper *bookthumbNailIcon;
@property (strong, nonatomic) NSString *bookTitle;
@property int tag;
//- (id)initWithName:(NSString*)m_text ShowType: (CGPoint)m_position RelatedNodeArray: (NSMutableArray*)m_relatedNodesArray linkArray:(NSMutableArray*)m_linkArray
 //    linkTextArray: (NSMutableArray*)m_linkTextArray bookTitle:(NSString*)m_bookTitle;
- (id)initWithName:(NSString*)m_text bookTitle: (NSString*)m_bookTitle positionX:(int)m_pointX positionY: (int)m_positionY Tag: (int)m_tag page: (int) m_pageNum url: (NSURL*)m_url urlTitle: (NSString *) m_urlTitle hasNote: (BOOL)m_hasNote hasHighlight: (BOOL)m_hasHighlight hasWebLink: (BOOL)m_hasWebLink savedNotesString: (NSString *) m_noteString ;
@end
