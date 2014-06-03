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


@end
