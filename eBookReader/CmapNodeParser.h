//
//  CmapNodeParser.h
//  eBookReader
//
//  Created by Shang Wang on 5/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmapNodeWrapper.h"
@interface CmapNodeParser : NSObject
+ (CmapNodeWrapper *)loadCmapNode;
+ (void)saveCmapNode:(CmapNodeWrapper *)CmapNode;

+ (CmapNodeWrapper *)loadExpertCmapNode;
+ (void)saveExpertCmapNode:(CmapNodeWrapper *)wrapper;
@end
