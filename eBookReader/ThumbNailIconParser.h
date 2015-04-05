//
//  ThumbNailIconParser.h
//  eBookReader
//
//  Created by Shang Wang on 8/7/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ThumbNailIconWrapper;

@interface ThumbNailIconParser : NSObject
+ (ThumbNailIconWrapper *)loadThumbnailIcon;
+ (void)saveThumbnailIcon:(ThumbNailIconWrapper *)ThumbnailIcon;

@end
