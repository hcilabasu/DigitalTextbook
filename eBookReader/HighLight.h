//
//  Player.h
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface HighLight : NSObject {
    NSString *_text;
    NSString *_color;
    int _page;
    int _searchCount;//if the text appears more than once in the page, this value keeps track of which text is highlighted
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int searchCount;

- (id)initWithName:(NSString *)text pageNum:(int)pageNum count:(int)searchCount color:(NSString*)color;

@end