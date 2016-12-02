//
//  BookDataController.m
//  eBookReader
//
//  Created by Andreea Danielescu on 2/26/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "BookDataController.h"
#import "BookViewController.h"

NSUInteger _totalPages;

@implementation BookDataController

@synthesize book;
@synthesize bookImporter;

/*- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
    }
    return self;
}*/

- (id) initWithPageViewController:(UIPageViewController*)controller :(EBookImporter*)importer :(NSString*) title{
    self = [super init];
    if (self) {
        NSLog(@"in init with pageView controller of bookData Controller");
        NSLog(@"book title: %@", title);
        self.bookImporter = importer;
        //create data model.
        self.book = [bookImporter importEBook:title];
        
        if(self.book == nil)
            NSLog(@"book is nil");
        
        _totalPages = [book totalPages];
        
        //now create the first page worth of stuff...
        // kick things off by making the first page
        BookViewController *pageZero = [self viewControllerAtIndex:0];
        
        if (pageZero != nil)
        {
            controller.dataSource = self;
            controller.delegate = self;
            [controller setViewControllers:@[pageZero]
                                         direction:UIPageViewControllerNavigationDirectionForward
                                          animated:NO
                                        completion:NULL];

            NSString* page = [book getPageAt:0];
            NSLog(@"Page: %@", page);
            
            NSURL* url = [NSURL fileURLWithPath:[book getHTMLURL]];
            
            if(url == nil)
                NSLog(@"did not load baseURL");
            
            NSError *error;
            NSString* pageContents = [[NSString alloc] initWithContentsOfFile:page encoding:NSASCIIStringEncoding error:&error];
            if(error != nil)
                NSLog(@"problem loading page contents");
            else
                NSLog(@"page contents: %@", pageContents);
            
            //[pageZero loadPage:pageContents :url];
        }

    }
    return self;
}

#pragma mark - UIPageViewController delegate methods

- (BookViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    NSLog(@"totalPages: %d", _totalPages);
    
    // Return the data view controller for the given index.
    if ((_totalPages == 0) || (index >= _totalPages)) {
        NSLog(@"returning nil");
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    BookViewController *bookViewController = [[BookViewController alloc] initWithPageNum:index];
    
/*    NSString* page = [book getPageAt:index];
    NSLog(@"Page: %@", page);
    
    NSURL* url = [NSURL fileURLWithPath:[book getHTMLURL]];
    
    if(url == nil)
        NSLog(@"did not load baseURL");
    
    NSError *error;
    NSString* pageContents = [[NSString alloc] initWithContentsOfFile:page encoding:NSASCIIStringEncoding error:&error];
    if(error != nil)
        NSLog(@"problem loading page contents");
    else
        NSLog(@"page contents: %@", pageContents);
 
    [bookViewController loadPage:pageContents :url];*/

    //TODO: send data to display on web view.
    return bookViewController;
}

- (NSUInteger)indexOfViewController:(BookViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    //return [viewController pageNum];
    return NSNotFound;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(BookViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"in view controller after view controller");
    
    if(viewController == nil)
        NSLog(@"view controller is nil");
    else
        NSLog(@"page num of view controller: %d", [(BookViewController*)viewController pageNum]);
    
    NSUInteger index = [self indexOfViewController:(BookViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == _totalPages) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
