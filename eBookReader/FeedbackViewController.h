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
#import "LogData.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"

#define FBTYPE_DISMISS -1
#define FBTYPE_COMPARE 5
#define FBTYPE_NAVIGATION 4
#define FBTYPE_POSITIVE 10
#define FBTYPE_RRR 1
#define FBTYPE_ADD 3
#define FBTYPE_DEFAULT 1
#define FBTYPE_AAA 6
#define FBTYPE_TEMPLATE 7
#define FBTYPE_TEMPLATE_NOTAP 16

#define FBTYPE_BACK 8
#define FBTYPE_NOACTION 9
#define FBTYPE_NOACTION_ADD 11
#define FBTYPE_NOACTION_LINK 12
#define FBTYPE_POS_CROSSLINK 13
#define FBTYPE_POS_BACKNAVI 14
#define FBTYPE_NO_CROSSLINK 15

@class CmapController;

@interface FeedbackViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageView;
@property int feedbackType;
@property int feedbackState; //1: normal ok and cancel   2:prepare to show add node view
@property AddNodeFBViewController* addNodeViewCtr;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) CmapController* parentCmapController;

@property NSMutableArray* missingConceptAry;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;
@property (weak, nonatomic) IBOutlet UISwitch *animatedSwitch;
@property (nonatomic, strong) LogDataWrapper* bookLogDataWrapper;
@property NSTimer* progressTimer;
@property int relatedPage;
@property KeyConcept* relatedKC;
@property NSString* relatedNodeName;
@property NSString* relatedNodeName2;
-(void)showAddNodePanel;
-(void)showAnimation;
-(void)animateProgressView;
-(void)upDateContent;
@end


