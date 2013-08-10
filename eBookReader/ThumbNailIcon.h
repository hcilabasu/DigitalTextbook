//
//  ThumbNailIcon.h
//  eBookReader
//
//  Created by Shang Wang on 8/6/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopoverView.h"

@interface ThumbNailIcon : NSObject

@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) int page;
@property (nonatomic) CGPoint showPoint;


- (id)initWithName:(int)m_type Text: (NSString *)m_text URL: (NSString*)m_url showPoint:(CGPoint)m_showPoint pageNum:(int)m_page bookTitle: (NSString*)m_bookTitle;
@end
