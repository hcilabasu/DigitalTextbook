//
//  Player.h
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface HighLight : NSObject {
    NSString *_bookTitle;
    NSString *_text;
    NSString *_color;
    int _page;
    int _searchCount;//if the text appears more than once in the page, this value keeps track of which text is highlighted
    int _startContainer;
    int _startOffset;
    int _endContainer;
    int _endOffset;
    
}

@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int searchCount;
@property (nonatomic, assign) int startContainer;
@property (nonatomic, assign) int startOffset;
@property (nonatomic, assign) int endContainer;
@property (nonatomic, assign) int endOffset;

- (id)initWithName:(NSString *)text pageNum:(int)pageNum count:(int)searchCount color:(NSString*)color startContainer:(int)startContainer
       startOffset:(int)startOffset endContainer:(int)endContainer endOffset: (int) endOffset bookTitle: (NSString*)booktitle;

@end