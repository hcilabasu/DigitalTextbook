//
//  BookDataController.h
//  eBookReader
//
//  Created by Andreea Danielescu on 2/26/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBookImporter.h"
#import "Book.h"

@class BookViewController;

@interface BookDataController : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    EBookImporter *bookImporter;
    Book* book;
}

@property (nonatomic, strong) EBookImporter *bookImporter;
@property (nonatomic, strong) Book* book;

- (BookViewController *)viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(BookViewController *)viewController;
- (id) initWithPageViewController:(UIPageViewController*)controller :(EBookImporter*)importer :(NSString*) title;
@end
