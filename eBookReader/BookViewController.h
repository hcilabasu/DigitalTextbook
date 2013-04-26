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


- (void) loadFirstPage;
-(void) createContentPages;
-(void)initialPageView;

- (NSInteger)pageNum;

@end
