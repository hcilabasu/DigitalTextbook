//
//  CmapLink.m
//  eBookReader
//
//  Created by Shang Wang on 6/14/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "CmapLink.h"

@implementation CmapLink
@synthesize leftConceptName;
@synthesize relationName;
@synthesize rightConceptName;
@synthesize pageNum;
- (id)initWithName:(NSString*)m_leftConceptName conceptName: (NSString*)m_rightConceptName relation: (NSString*)m_relationName page: (int)m_pageNum{
    
    if ((self = [super init])) {
        leftConceptName=m_leftConceptName;
        rightConceptName=m_rightConceptName;
        relationName=m_relationName;
        pageNum=m_pageNum;
    }
    return self;
    
}

@end
