//
//  CmapLinkWrapper.h
//  eBookReader
//
//  Created by Shang Wang on 6/14/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmapLink.h"

@interface CmapLinkWrapper : NSObject


@property (nonatomic, retain) NSMutableArray *cmapLinks;
-(void)addLinks: (CmapLink*)cmaps;
-(void)clearAllData;


@end
