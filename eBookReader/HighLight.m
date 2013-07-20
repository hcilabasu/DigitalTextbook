//
//  Player.m
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "HighLight.h"

@implementation HighLight
@synthesize text = _text;
@synthesize page = _page;
@synthesize searchCount=_searchCount;
@synthesize color=_color;

- (id)initWithName:(NSString *)text pageNum:(int)pageNum count:(int)searchCount color:(NSString*)color {
    
    if ((self = [super init])) {
        self.text = text;
        self.page = pageNum;
        self.searchCount = searchCount;
        self.color=color;
    }
    return self;
    
}

- (void) dealloc {
    self.text = nil;
    self.page=nil;
    self.searchCount=nil;
    self.color=nil;
}

@end