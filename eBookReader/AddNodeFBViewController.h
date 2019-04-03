//
//  AddNodeFBViewController.h
//  Study
//
//  Created by Shang Wang on 2/6/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyConcept.h"
#import "LogData.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"
NS_ASSUME_NONNULL_BEGIN
@class FeedbackViewController;
@interface AddNodeFBViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *node1;
@property (weak, nonatomic) IBOutlet UIView *node2;
@property (weak, nonatomic) IBOutlet UIView *node3;
@property (weak, nonatomic) IBOutlet UIView *node4;
@property int SelectedNodeIndex;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property NSString* conceptName;
@property (nonatomic, strong) LogDataWrapper* bookLogDataWrapper;
@property (strong, nonatomic) FeedbackViewController *parentFeedbackViewCtr;
-(void)upDateCandidateNodes: (NSMutableArray*) missingAry;
@end

NS_ASSUME_NONNULL_END
