//
//  PageControllerViewController.m
//  eBookReader
//
//  Created by Andreea Danielescu on 2/20/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "PageController.h"

@interface PageController() {
}

//May not need this in the story board...may be able to add the PageControllers and the UIWebViews programmatically as long as I have the segue set up between the LibraryViewController and the BookViewController in the storyboard.
//I may also be able to set this up separately in the storyboard...not sure which I'll do yet. 


@end

@implementation PageController

@synthesize pageView;
@synthesize pageNum;

 /*(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"in view did load of pageController");
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) loadPage:(int) num :(NSString*)content :(NSURL*)baseURL {
    [pageView loadHTMLString:content baseURL:baseURL];
    self.pageNum = num;
}

@end
