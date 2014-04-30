//
//  ThumbNailIconWrapper.m
//  eBookReader
//
//  Created by Shang Wang on 8/7/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "ThumbNailIconWrapper.h"
#import "ThumbNailIcon.h"

@implementation ThumbNailIconWrapper
@synthesize thumbnails;


- (id)init {
    if ((self = [super init])) {
        self.thumbnails = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    self.thumbnails = nil;
}


-(void)addthumbnail: (ThumbNailIcon*)thumbnail{
    [self.thumbnails addObject:thumbnail];
}


-(void)printAllThumbnails{
    NSLog(@"Print Thumbnail!\n");
    
    int i=0;
    for (ThumbNailIcon *player in thumbnails) {
        NSLog(@"No. %d",++i);
        NSLog(@"Text: %@", player.text);
        NSLog(@"type: %d", player.type);
        NSLog(@"Concept: %@",player.relatedConcpet);
    }
    if(0==i){
        NSLog(@"Highlight array empty!\n");
    }
    
}


@end
