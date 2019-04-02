//
//  TAViewController.m
//  Study
//
//  Created by Shang Wang on 2/6/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import "TAViewController.h"
#import "CmapController.h"
@interface TAViewController ()

@end

@implementation TAViewController
@synthesize parentCmapController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *singleTapOnAgent =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(singleTapAgent:)];
    singleTapOnAgent.delegate=self;
    [self.view addGestureRecognizer:singleTapOnAgent];
    
    
    UITapGestureRecognizer *doubleTapOnAgent =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(doubleTapAgent:)];
    doubleTapOnAgent.numberOfTapsRequired=2;
    doubleTapOnAgent.delegate=self;
    [self.view addGestureRecognizer:doubleTapOnAgent];
    
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAgent:)];
    [self.view addGestureRecognizer:longPress];
    
}


- (void)longPressAgent:(UITapGestureRecognizer *)recognizer
{
    [parentCmapController.feedbackPV dismiss];
    [parentCmapController showCompareFeedbackmessage];
}

- (void)doubleTapAgent:(UITapGestureRecognizer *)recognizer
{
    [parentCmapController.feedbackPV dismiss];
    //[parentCmapController showNavigationFeedbackmessage];
}

- (void)singleTapAgent:(UITapGestureRecognizer *)recognizer
{   
    [parentCmapController showFeedbackmessage];
    //[parentCmapController showDualTextbookView];
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
