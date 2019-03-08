//
//  FeedbackViewController.h
//  Study
//
//  Created by Shang Wang on 2/6/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNodeFBViewController.h"
#import "AddNodeFBViewController.h"
#import "MBCircularProgressBarView.h"
#import "MBCircularProgressBarLayer.h"
@class CmapController;


@interface FeedbackViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageView;
@property int feedbackType;
@property int feedbackState; //1: normal ok and cancel   2:prepare to show add node view
@property AddNodeFBViewController* addNodeViewCtr;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) CmapController* parentCmapController;


@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;
@property (weak, nonatomic) IBOutlet UISwitch *animatedSwitch;
@property NSTimer* progressTimer;
-(void)showAddNodePanel;
-(void)showAnimation;
-(void)animateProgressView;
@end


