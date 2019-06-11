//
//  TrainingViewController.m
//  TurkStudy
//
//  Created by Shang Wang on 3/14/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import "TrainingViewController.h"
#import "BookPageViewController.h"
@interface TrainingViewController ()

@end

@implementation TrainingViewController
@synthesize cmapView;
@synthesize mywebView;
@synthesize webFocusQuestionLable;
@synthesize cmapFocusQuestionLable;
@synthesize hintImg;
@synthesize bookImporter;
@synthesize bookTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
     mywebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 512, 768)];
    // webView.delegate=self;
     [self.view addSubview:mywebView];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"training_full" ofType:@"html" inDirectory:@"WebTutorial"]];
    [mywebView loadRequest:[NSURLRequest requestWithURL:url]];
    mywebView.scrollView.scrollEnabled=NO;
    mywebView.scrollView.bounces=NO;
}



-(void)webViewDidFinishLoad:(UIWebView *)m_webView{
    [mywebView becomeFirstResponder];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
