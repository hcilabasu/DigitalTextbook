//
//  CmapLinkParser.h
//  eBookReader
//
//  Created by Shang Wang on 6/14/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmapLinkWrapper.h"
#import "CmapLink.h"
@interface CmapLinkParser : NSObject
+ (CmapLinkWrapper *)loadCmapLink;
+ (void)saveCmapLink:(CmapLinkWrapper *)CmapLink;
+ (void)saveExpertCmapLink:(CmapLinkWrapper *)wrapper;
+ (CmapLinkWrapper *)loadExpertCmapLink;


@end
