//
//  ConceptLink.h
//  eBookReader
//
//  Created by Shang Wang on 6/15/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NodeCell;
@interface ConceptLink : NSObject
@property (strong, nonatomic) NodeCell* leftNode;
@property (strong, nonatomic) NodeCell* righttNode;
@property (strong, nonatomic) UITextView *relation;
@property int pageNum;
- (id)initWithName:(NodeCell*)m_leftConcept conceptName: (NodeCell*)m_rightConcept relation: (UITextView*)m_relation page:(int)m_pageNum;


@end
