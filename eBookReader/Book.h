//
//  Book.h
//  eBookReader
//
//  Created by Andreea Danielescu on 2/6/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject {
    NSString *title;
    NSString *author;
    NSString *coverImagePath;
    NSString *bookPath; //root path of the book:/Documents/<Author Folder>/<Book Folder>
    NSString *mainContentPath; //the root path of where the content is stored. 
    NSDictionary *bookItems; //manifest items read in from opf file. The key is the id and the object is the href.
    NSMutableArray *itemOrder; //array that keeps track of the order the items should appear in. Stores the ids in order of the hrefs in bookItems.
}

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *author;
@property (nonatomic, strong) NSString *coverImagePath;
@property (nonatomic, strong) NSString *bookPath;
@property (nonatomic, strong) NSString* mainContentPath;
@property (nonatomic, strong) NSDictionary *bookItems;
@property (nonatomic, strong) NSMutableArray *itemOrder;

- (id) initWithTitleAndAuthor:(NSString*)path :(NSString*)bookTitle :(NSString*)bookAuthor;
- (NSString*) getPageAt:(int)pageNum;
- (NSString*) getHTMLURL;
- (NSInteger)totalPages;

@end
