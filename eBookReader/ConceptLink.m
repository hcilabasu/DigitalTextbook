//
//  ConceptLink.m
//  eBookReader
//
//  Created by Shang Wang on 6/15/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "ConceptLink.h"

@implementation ConceptLink
@synthesize leftNode;
@synthesize righttNode;
@synthesize relation;
@synthesize pageNum;

- (id)initWithName:(NodeCell*)m_leftConcept conceptName: (NodeCell*)m_rightConcept relation: (UITextView*)m_relation page:(int)m_pageNum{
    
    if ((self = [super init])) {
        leftNode=m_leftConcept;
        righttNode=m_rightConcept;
        relation=m_relation;
        pageNum=m_pageNum;
    }
    return self;
    
}

@end
