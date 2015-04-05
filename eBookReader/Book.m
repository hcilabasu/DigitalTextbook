//
//  Book.m
//  eBookReader
//
//  Created by Andreea Danielescu on 2/6/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "Book.h"

@implementation Book

@synthesize title;
@synthesize author;
@synthesize coverImagePath;
@synthesize mainContentPath;
@synthesize bookPath;
@synthesize bookItems;
@synthesize itemOrder;

- (id) initWithTitleAndAuthor:(NSString*)path :(NSString*)bookTitle :(NSString*)bookAuthor {
    if (self = [super init]) {
        bookPath = path;
        title = bookTitle;
        author = bookAuthor;
        coverImagePath = nil;
    }
    
    return self;
}

//Get the filepath of the page at pageNum.
-(NSString*) getPageAt:(int)pageNum {
    if(pageNum < [itemOrder count]) {
        NSString* idPage = [itemOrder objectAtIndex:pageNum];
        NSString* page = [bookItems objectForKey:idPage];
    
        //NSString* filepath = [self.bookPath stringByAppendingString:@"/epub/"];
        //filepath = [filepath stringByAppendingString:page];
        
        NSString* filepath = [self.mainContentPath stringByAppendingString:page];
        
        NSLog(@"filepath: %@", filepath);
    
        return filepath;
    }
    return nil;
}

//This is the base URL for the book.
- (NSString*) getHTMLURL {
    NSString* idPage = [itemOrder objectAtIndex:0];
    NSString* page = [bookItems objectForKey:idPage];
    NSString* url = [self.mainContentPath stringByAppendingString:page];
    //NSString* url=[[NSBundle mainBundle] resourceURL];
    return url;
}

//Return total number of pages. 
-(NSInteger) totalPages {
    return [itemOrder count];
}
@end
