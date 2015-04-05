//
//  ThumbNailIconWrapper.h
//  eBookReader
//
//  Created by Shang Wang on 8/7/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ThumbNailIcon;

@interface ThumbNailIconWrapper : NSObject


@property (nonatomic, retain) NSMutableArray *thumbnails;
-(void)addthumbnail: (ThumbNailIcon*)thumbnail;
-(void)printAllThumbnails;
@end
