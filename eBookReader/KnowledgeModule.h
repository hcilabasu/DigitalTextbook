//
//  KnowledgeModule.h
//  eBookReader
//
//  Created by Shang Wang on 4/24/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Concept.h"

@interface KnowledgeModule : NSObject


@property NSMutableArray *conceptList;
-(void)initConcept_Test;
-(NSString *)getTextBookDefinition: (NSString *) m_conceptName;

@end
