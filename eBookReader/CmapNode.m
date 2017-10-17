//
//  CmapNode.m
//  eBookReader
//
//  Created by Shang Wang on 5/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "CmapNode.h"

@implementation CmapNode
@synthesize text;
@synthesize bookPagePosition;
@synthesize relatedNodesArray;
@synthesize linkLayerArray;
@synthesize relationTextArray;
@synthesize  bookTitle;
@synthesize point_x;
@synthesize point_y;
@synthesize tag;
@synthesize pageNum;
@synthesize linkingUrl;
@synthesize linkingUrlTitle;
@synthesize savedNotesString;
@synthesize nodeType;
/*
- (id)initWithName:(NSString*)m_text ShowType: (CGPoint)m_position RelatedNodeArray: (NSMutableArray*)m_relatedNodesArray linkArray:(NSMutableArray*)m_linkArray
     linkTextArray: (NSMutableArray*)m_linkTextArray bookTitle:(NSString*)m_bookTitle
{
    if ((self = [super init])) {
        text=m_text;
        relatedNodesArray=m_relatedNodesArray;
        linkLayerArray=m_linkArray;
        relationTextArray=m_linkTextArray;
        bookTitle=m_bookTitle;
        
    }
    return self;
}
*/

- (id)initWithName:(NSString*)m_text bookTitle: (NSString*)m_bookTitle positionX:(int)m_pointX positionY: (int)m_positionY Tag: (int)m_tag page: (int) m_pageNum url: (NSURL*)m_url urlTitle: (NSString *) m_urlTitle hasNote: (BOOL)m_hasNote hasHighlight: (BOOL)m_hasHighlight hasWebLink: (BOOL)m_hasWebLink savedNotesString: (NSString *) m_noteString nodeType: (int)m_nodeType
{
    if ((self = [super init])) {
        text=m_text;
        bookTitle=m_bookTitle;
        point_x=m_pointX;
        point_y=m_positionY;
        tag=m_tag;
        pageNum=m_pageNum;
        linkingUrl =m_url;
        linkingUrlTitle = m_urlTitle;
        _hasNote = m_hasNote;
        _hasWebLink = m_hasWebLink;
        _hasHighlight = m_hasHighlight;
        savedNotesString = m_noteString;
        nodeType=m_nodeType;
        
    }
    return self;
}


@end
