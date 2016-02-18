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
#import <MediaPlayer/MediaPlayer.h>
#import "BookPageViewController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    
    UITapGestureRecognizer *onetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updatePVPosition:)];
    [onetap setNumberOfTapsRequired:1];
    onetap.delegate=self;
   // [self.view addGestureRecognizer:onetap];
    
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
      webView.allowsInlineMediaPlayback=YES;
    webView.delegate=self;
    
    webView.scalesPageToFit = YES;
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(orientation==UIInterfaceOrientationLandscapeLeft&&orientation==UIInterfaceOrientationLandscapeRight){
        [teachImg setHidden:YES];
    }
    
    if(hideImg){
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(Goback)];
        self.navigationItem.leftBarButtonItem = leftButton;
        
        [teachImg setHidden:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    
    
    
    UIDeviceOrientation Devorientation = [[UIDevice currentDevice] orientation];
    NSURL *url = [NSURL URLWithString:@"https://invis.io/JN5N1N9WK"];
    switch (Devorientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            // do something for landscape orientation
            [teachImg setHidden:YES];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
            
        default:
            break;
    }

    
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

/*
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSInteger height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %ld);", (long)height];
    [self.webView stringByEvaluatingJavaScriptFromString:javascript];
    
    
    CGPoint bottomOffset = CGPointMake(0, self.webView.scrollView.contentSize.height - self.webView.scrollView.bounds.size.height);
    [self.webView.scrollView setContentOffset:bottomOffset animated:YES];

}*/



/*
-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    
     // [webView setFrame:self.view.frame];
    //[self.navigationController.navigationBar setHidden:YES];
    
    self.navigationController.navigationBar.translucent = YES;
     self.parentViewController.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}


 
 */
 


-(void)Goback{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}


- (void) didRotate:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
     NSURL *url = [NSURL URLWithString:@"https://invis.io/JN5N1N9WK"];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            // do something for portrait orientation
            if(hideImg){
                break;
            }
             [teachImg setHidden:NO];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            // do something for landscape orientation
             [teachImg setHidden:YES];
             [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
            
        default:
            break;
    }
}


-(void)startTimer{
    totalCountdownInterval=140;
  // totalCountdownInterval=6;
    startDate = [NSDate date];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCount:) userInfo:nil repeats:YES];
}


-(void) checkCount:(NSTimer*)_timer {
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    remainTime = totalCountdownInterval - elapsedTime;
    int second=(int)remainTime;
    NSString *speedLabel = [[NSString alloc] initWithFormat:@"Tutorial time remaining %02d : %02d ", second/60, second%60];
    timerLable.text=speedLabel;
    self.navigationController.navigationBar.topItem.title=speedLabel;
    if(remainTime<=30){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    }
    if (remainTime <= 0.0) {
        [_timer invalidate];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
       // [self.navigationController popToRootViewControllerAnimated:YES];
        NSLog(@"Controller Queue");
        NSLog(@"%@",self.navigationController.viewControllers);
        //[self.navigationController popToViewController:self animated:false];
        //[self.navigationController popToViewController:self.parentViewController animated:false];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        [parentBookCtr startCmapTimer];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
