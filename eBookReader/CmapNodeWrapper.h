//
//  CmapNodeWrapper.h
//  eBookReader
//
//  Created by Shang Wang on 5/6/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmapNode.h"
@interface CmapNodeWrapper : NSObject


@property (nonatomic, retain) NSMutableArray *cmapNodes;
-(void)addthumbnail: (CmapNode*)cmaps;
-(void)clearAllData;
@end
