//
//  BookViewController.m
//  eBookReader
//
//  Created by Andreea Danielescu on 2/12/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "BookViewController.h"
#import "QuizViewController.h"
#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "GDataXMLNode.h"
#import "HighLight.h"
#import "ThumbNailIcon.h"
#import "ThumbNailIconParser.h"
#import "ThumbNailIconWrapper.h"
#import "BookPageViewController.h"
#import "LibraryViewController.h"
#import "LogFileController.h"
#import "LogData.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"
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
@synthesize highlightTextArrayByIndex;
@synthesize highLight;
@synthesize thumbnailIcon;
@synthesize cmapView;
@synthesize parent_LibraryViewController;
@synthesize parent_BookPageViewController;
@synthesize logWrapper;
@synthesize userName;
@synthesize currentContentView;
@synthesize loadContentView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    highLight = [HighlightParser loadHighlight];
    thumbnailIcon=[ThumbNailIconParser loadThumbnailIcon];
    logWrapper= [LogDataParser loadLogData];
    [thumbnailIcon printAllThumbnails];

    NSArray * ary=self.view.gestureRecognizers;
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            recognizer.enabled = NO;
        }
    }
    
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers) {
        gR.delegate = self;
    }

}


-(void)viewDidAppear:(BOOL)animated{
    NSArray * ary=self.view.gestureRecognizers;
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            recognizer.enabled = NO;
        }
    }

}




-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Touch gestures below top bar should not make the page turn.
    //EDITED Check for only Tap here instead.
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (touchPoint.y > 40) {
            return NO;
        }
        else if (touchPoint.x > 50 && touchPoint.x < 430) {//Let the buttons in the middle of the top bar receive the touch
            return NO;
        }
    }
    return NO;
}




-(void)test{
    NSLog(@"Test");
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)createCmapView{
    cmapView=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
    cmapView.neighbor_BookViewController=self;
    cmapView.userName=userName;
    cmapView.dataObject=_dataObject;
    cmapView.showType=1;
    cmapView.bookTitle=bookTitle;
    [self addChildViewController:cmapView];
    //[self.navigationController.view addSubview:cmapView.view];
    //[self.parentViewController.view addSubview:cmapView.view];
    //[self.view addSubview:cmapView.view];
    [cmapView.view setUserInteractionEnabled:YES];
    cmapView.view.center=CGPointMake(700, 384);
    [cmapView.view setHidden:NO];
}


-(void)initialPageView{
    //initialize the page view by adding subviews to the BookView.
    _pageNum = 0;
    
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
    // highlightTextArrayByIndex= [[NSMutableArray alloc]init];
    
    int page_num = 0;
    
    book = [bookImporter importEBook:bookTitle];
    _totalPageNum = [book totalPages];
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    // specify page numbers
    for (int i = 1; i < _totalPageNum+1; i++)
    {
        page_num++;
        NSLog(@"creating page content for page %d \n",i);
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
    NSLog(@"Controller Index:%d",index);
    // Return the data view controller for the given index.
    if (([self.pageContent count] == 0) ||
        (index >= [self.pageContent count])) {
        return nil;
    }
    
    NSString* logStr=[[NSString alloc] initWithFormat:@"Loading page: %d", index+1];
    LogData* log= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:logStr selection:@"Textbook" input:@"null" pageNum:index];
    [logWrapper addLogs:log];
    [LogDataParser saveLogData:logWrapper];
    
    
    // Create a new view controller and pass suitable data.
    ContentViewController *dataViewController =
    [[ContentViewController alloc]
     initWithNibName:@"ContentViewController"
     bundle:nil];
    
    dataViewController.userName=userName;
    dataViewController.bookTitle=bookTitle;
    dataViewController.parent_BookViewController=self;
    dataViewController.pageNum=_pageNum+1;
    dataViewController.totalpageNum=_totalPageNum;
    dataViewController.bookHighLight=highLight;
    dataViewController.bookthumbNailIcon=thumbnailIcon;
    dataViewController.bookLogData=logWrapper;
    loadContentView=dataViewController;
   // currentContentView=dataViewController;
    
    NSLog(@"Page: %d/%d", _pageNum+1,_totalPageNum);
    dataViewController.dataObject =
    [self.pageContent objectAtIndex:index];
    // add the HTML content and the URL link.
    NSURL* baseURL = [NSURL fileURLWithPath:[book getHTMLURL]];
    dataViewController.url=baseURL;
     
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(ContentViewController *)viewController
{
    NSUInteger ind=[self.pageContent indexOfObject:viewController.dataObject];
    return ind;
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
   // self.navigationController.navigationBarHidden=YES;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    //set navigationBar style and background
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setBarStyle: UIStatusBarStyleDefault];
   // [self.navigationController setNavigationBarHidden:YES];
    NSArray * ary=self.view.gestureRecognizers;
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            recognizer.enabled = NO;
        }
    }
}



-(void)showFirstPage: (int) pageIndex
{
    
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
    [self viewControllerAtIndex:pageIndex];
    initialViewController.pageNum=pageIndex+1;
    _pageNum=pageIndex;
    
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

- (UIImage*)scaleToSize:(CGSize)size image:(UIImage*) img {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), img.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}



-(void)searchAndHighlightNode{
    [parent_BookPageViewController.cmapView highlightPageNode:loadContentView.pageNum];
    /*
    if(thumbnailIcon!=nil){
        for(ThumbNailIcon *thumbNailItem in thumbnailIcon.thumbnails){
            // if([thumbNailItem.relatedConcpet isEqualToString: concpet]){
            if(thumbNailItem.page==(_pageNum+1) && [bookTitle isEqualToString: thumbNailItem.bookTitle]){
                if (3==thumbNailItem.type){
                    //if(parent_BookPageViewController.cmapView.isInitComplete){
                   // [parent_BookPageViewController.cmapView highlightNode:thumbNailItem.text];
                    [parent_BookPageViewController.cmapView highlightPageNode:loadContentView.pageNum];
                    // }
                }
            }
            //}
        }
    }*/
}


-(void)searchAndHighlightLink{
    [parent_BookPageViewController.cmapView highlightLink: parent_BookPageViewController.cmapView.pageNum];
}



-(void)clearAllHighlightNode{
    [parent_BookPageViewController.cmapView clearAllHighlight];
}


-(void)splitScreen{
    
    CGRect rec=CGRectMake(0, 0, 512, 768);
    [self.view setFrame:rec];
    //[self createCmapView];
}


-(void)clearALlHighlight{
    [highLight clearAllData];
    [HighlightParser saveHighlight:highLight];
    
}

-(void)deleteHighlightWithWord: (NSString*)name {
    NSMutableArray* mutAry=[[NSMutableArray alloc]init];
    for(HighLight* high in highLight.highLights){
        if([high.text isEqualToString:name]){
            [mutAry addObject:high];
        }
    }
    
    for(HighLight* highToDel in mutAry){
        [highLight.highLights removeObject:highToDel];
    }
    
    //[highLight.highLights removeObject:highToDelete];
    [HighlightParser saveHighlight:highLight];
}


@end
