//
//  BookPageViewController.m
//  eBookReader
//
//  Created by Shang Wang on 6/19/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "BookPageViewController.h"

@interface BookPageViewController ()

@end

@implementation BookPageViewController
@synthesize bookView;
@synthesize cmapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)test{
    NSLog(@"Test");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createCmapView];
    bookView.parent_BookPageViewController=self;
    if( ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft)||([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)){
        [self splitScreen];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)createCmapView{
    cmapView=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
    cmapView.showType=1;
    cmapView.neighbor_BookViewController=self.bookView;
    [self addChildViewController:cmapView];
    [self.view addSubview:cmapView.view];
    [cmapView.view setUserInteractionEnabled:YES];
    cmapView.view.center=CGPointMake(777, 384);
    [cmapView.view setHidden:YES];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //when retating the device, clear the thumbnail icons and reload
    if(fromInterfaceOrientation==UIInterfaceOrientationPortrait||fromInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        [self splitScreen];
    }
    //otherwise, hide the concept map view.
    if(fromInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||fromInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
        [self resumeNormalScreen ];
    }
}


-(void)splitScreen{
    CGRect rec=CGRectMake(0, 0, 512, 768);
    [bookView.view setFrame:rec];
    [cmapView.view setHidden:NO];
   // [self createCmapView];
}

-(void)resumeNormalScreen{
    CGRect rec=CGRectMake(0, 0, 768, 1024);
    [bookView.view setFrame:rec];
     [cmapView.view setHidden:YES];
}


-(void)searchAndHighlight{
    
}


@end
