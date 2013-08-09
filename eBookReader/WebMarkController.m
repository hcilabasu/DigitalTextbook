//
//  WebMarkController.m
//  eBookReader
//
//  Created by Shang Wang on 4/22/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "WebMarkController.h"
#import "WebBrowserViewController.h"
@interface WebMarkController ()

@end
@implementation WebMarkController
@synthesize markImage;
@synthesize oneFingerTap;
@synthesize web_requestObj;
@synthesize pvPoint;
@synthesize iconPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize screenSize = [self screenSize];
    [self.view setFrame:CGRectMake(screenSize.width-35, iconPoint.y, 25, 25)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [doubleTap setNumberOfTapsRequired:1];
    doubleTap.delegate=self;
    [markImage setUserInteractionEnabled:YES];
    [markImage addGestureRecognizer:doubleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize) screenSize
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

//Need to add this function to enable note view to recognize gesture.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");
    }
}

- (void)singleTapped:(UITapGestureRecognizer *)tap
{
    WebBrowserViewController *webBroser= [[WebBrowserViewController alloc]
                                          initWithNibName:@"WebBrowserViewController" bundle:nil];
    webBroser.isNew=NO;
    webBroser.requestObj=web_requestObj;
    [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController pushViewController:webBroser animated:YES];
}

@end
