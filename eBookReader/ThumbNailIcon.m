//
//  ThumbNailIcon.m
//  eBookReader
//
//  Created by Shang Wang on 8/6/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "ThumbNailIcon.h"

@implementation ThumbNailIcon

@synthesize type;
@synthesize text;
@synthesize url;
@synthesize page;
@synthesize showPoint;
@synthesize bookTitle;



- (id)initWithName:(int)m_type Text: (NSString *)m_text URL: (NSString*)m_url showPoint:(CGPoint)m_showPoint pageNum:(int)m_page bookTitle: (NSString*)m_bookTitle
{
    if ((self = [super init])) {
        bookTitle=m_bookTitle;
        type=m_type;
        text=m_text;
        url=m_url;
        showPoint=m_showPoint;
        page=m_page;
    }
    return self;
}




@end
