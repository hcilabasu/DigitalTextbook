//
//  VideoViewController.m
//  TurkStudy
//
//  Created by Shang Wang on 11/8/15.
//  Copyright © 2015 Shang Wang. All rights reserved.
//

#import "VideoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BookPageViewController.h"
#import "TrainingViewController.h"
#import "AppDelegate.h"
@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize webView;
@synthesize teachImg;
@synthesize hideImg;
@synthesize parentBookCtr;
@synthesize totalCountdownInterval;
@synthesize remainTime;
@synthesize startDate;
@synthesize timerLable;
@synthesize bookImporter;
@synthesize bookTitle;
@synthesize logWrapper;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    webView.allowsInlineMediaPlayback=YES;
    webView.delegate=self;
    
    webView.scalesPageToFit = YES;
    // Do any additional setup after loading the view from its nib.
   // [self.navigationItem setHidesBackButton:YES animated:YES];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    // [self.navigationController setNavigationBarHidden:YES animated:YES];

    [webView setFrame:[[UIScreen mainScreen] bounds]];

    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"training_full" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
  //  [webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    

    
    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"Training_FULL" ofType:@"m4v"];
    
    
    NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
    if( [FBType isEqualToString: FB_PROCESS]){
          filepath   =   [[NSBundle mainBundle] pathForResource:@"Training_PROCESS" ofType:@"m4v"];
    }
    if( [FBType isEqualToString: FB_NO]){
         filepath   =   [[NSBundle mainBundle] pathForResource:@"Training_NO" ofType:@"m4v"];
    }
    
    
    NSURL *fileURL    =   [NSURL fileURLWithPath:filepath];
    AVPlayer *player = [AVPlayer playerWithURL:fileURL];
    AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;

    
    
    
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player=player;
    
    [self addChildViewController: playerViewController];
    [self.view addSubview: playerViewController.view];
    [playerViewController.view setFrame:self.view.frame];

    [player pause];
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [parentBookCtr.expertModel startAllTimer];
    [parentBookCtr LogQuitTutorial];
}


-(void)showTutorial{

}


-(void)finishTraining{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}





@end
