//
//  BookViewController.h
//  eBookReader
//
//  Created by Andreea Danielescu on 2/12/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EbookImporter.h"
#import "Book.h"
#import "contentViewController.h"
@class HighLightWrapper;
@interface BookViewController : UIViewController
<UIPageViewControllerDataSource>{
    EBookImporter *bookImporter;
    Book* book;
    UIPageViewController *pageController;
    NSArray *pageContent;
    
}

@property (strong, nonatomic) id dataObject;
@property (nonatomic, strong) EBookImporter *bookImporter;
@property (nonatomic, strong) NSString *bookTitle;
@property (nonatomic, strong) Book* book;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@property (strong, nonatomic) NSMutableArray *highlightTextArrayByIndex;
@property (nonatomic, retain) HighLightWrapper *highLight;//highlight wrapper for the book.


- (void) loadFirstPage;
-(void) createContentPages;
-(void)initialPageView;
- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index;
-(void)showFirstPage: (int) pageIndex;//show page accoding to index number

- (NSInteger)pageNum;

@end
