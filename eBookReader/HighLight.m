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
@synthesize startContainer=_startContainer;
@synthesize startOffset=_startOffset;
@synthesize endContainer=_endContainer;
@synthesize endOffset=_endOffset;
@synthesize bookTitle=_bookTitle;


- (id)initWithName:(NSString *)text pageNum:(int)pageNum count:(int)searchCount color:(NSString*)color startContainer:(int)startContainer
startOffset:(int)startOffset endContainer:(int)endContainer endOffset: (int) endOffset bookTitle: (NSString*)booktitle
{
    if ((self = [super init])) {
        self.bookTitle=booktitle;
        self.text = text;
        self.page = pageNum;
        self.searchCount = searchCount;
        self.color=color;
        self.startContainer=startContainer;
        self.startOffset=startOffset;
        self.endContainer=endContainer;
        self.endOffset=endOffset;
    }
    return self;
}

- (void) dealloc {
    self.bookTitle=nil;
    self.text = nil;
    self.page=nil;
    self.searchCount=nil;
    self.color=nil;
    self.startContainer=nil;
    self.startOffset=nil;
    self.endContainer=nil;
    self.endOffset=nil;
}

@end