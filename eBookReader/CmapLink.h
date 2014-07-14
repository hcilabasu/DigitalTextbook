//
//  CmapLink.h
//  eBookReader
//
//  Created by Shang Wang on 6/14/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmapLink : NSObject

@property (strong, nonatomic) NSString*  leftConceptName;
@property (strong, nonatomic) NSString*  rightConceptName;
@property (strong, nonatomic) NSString*  relationName;
@property int pageNum;
- (id)initWithName:(NSString*)m_leftConceptName conceptName: (NSString*)m_rightConceptName relation: (NSString*)m_relationName page: (int)m_pageNum;


@end
