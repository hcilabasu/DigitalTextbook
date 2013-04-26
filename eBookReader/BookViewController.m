//
//  BookViewController.m
//  eBookReader
//
//  Created by Andreea Danielescu on 2/12/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "BookViewController.h"


@interface BookViewController () {
    NSUInteger _pageNum;
    NSUInteger _totalPageNum;
}

@property (nonatomic, strong) IBOutlet UIWebView *bookView;
@property (nonatomic, assign) NSUInteger _pageNum;
@end

@implementation BookViewController 

@synthesize book;
@synthesize bookTitle;
@synthesize bookImporter;
@synthesize _pageNum;
@synthesize bookView;
@synthesize pageController, pageContent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageNum = 0;
}


-(void)initialPageView{
    //initialize the page view by adding subviews to the BookView.
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
    ContentViewController *initialViewController =
    [self viewControllerAtIndex:0];
    NSArray *viewControllers =
    [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
}

//creates pages and the content 
- (void) createContentPages
{
    NSLog(@"creating page content!");
    book = [bookImporter importEBook:bookTitle];
    _totalPageNum = [book totalPages];
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    // specify page numbers
    for (int i = 1; i < _totalPageNum+1; i++)
    {
        //get the content for each page
        NSString* page = [book getPageAt:i-1];
        NSError *error;
        NSString* pageContents = [[NSString alloc] initWithContentsOfFile:page encoding:NSASCIIStringEncoding error:&error];
        NSString *contentString = [[NSString alloc] init];
        //add the html content
        if(pageContents!=nil){
        contentString=[contentString stringByAppendingString:pageContents];
                       }
        [pageStrings addObject: contentString ];
    }
    // add the html content to the pageContent array.
    pageContent = [[NSArray alloc] initWithArray:pageStrings];
}



- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.pageContent count] == 0) ||
        (index >= [self.pageContent count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    ContentViewController *dataViewController =
    [[ContentViewController alloc]
     initWithNibName:@"ContentViewController"
     bundle:nil];
    dataViewController.pageNum=_pageNum;
    dataViewController.totalpageNum=_totalPageNum;
     NSLog(@"Page: %d/%d", _pageNum,_totalPageNum);
    dataViewController.dataObject =
    [self.pageContent objectAtIndex:index];
    // add the HTML content and the URL link.
    NSURL* baseURL = [NSURL fileURLWithPath:[book getHTMLURL]];

    
    dataViewController.url=baseURL;
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(ContentViewController *)viewController
{
    return [self.pageContent indexOfObject:viewController.dataObject];
}


//function invoked when user flip to the previous page, we decrease the index and pageNumber and update the content
- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (ContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    _pageNum=index;
    return [self viewControllerAtIndex:index];
}

//function invoked when user flip to the next page, we increase the index and pageNumber and update the content

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    _pageNum=index;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //hides the navigationbar
    self.navigationController.navigationBarHidden=YES;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    //set navigationBar style and background
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setBarStyle: UIBarStyleBlackTranslucent];
}

@end
