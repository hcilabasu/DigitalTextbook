//
//  FeedbackViewController.m
//  Study
//
//  Created by Shang Wang on 2/6/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CmapController.h"
#import "BookPageViewController.h"
#import "BookViewController.h"
@interface FeedbackViewController ()
@property float time;
@end

@implementation FeedbackViewController
@synthesize addNodeViewCtr;
@synthesize parentCmapController;
@synthesize messageView;
@synthesize leftButton;
@synthesize rightButton;
@synthesize feedbackState;
@synthesize progressBar;
@synthesize animatedSwitch;
@synthesize progressTimer;
@synthesize missingConceptAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    feedbackState=1;
    // Do any additional setup after loading the view from its nib.
   [messageView setBackgroundColor:[UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:0.95f]];
    [progressBar setHidden:YES];
}

-(void)showAnimation{
    if(addNodeViewCtr.view){
        [addNodeViewCtr.view removeFromSuperview];
    }
   progressTimer= [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(theAction)
                                   userInfo:nil
                                    repeats:YES];
}



-(void)updateProgressBar
{
    //NSLog(@"Time is %f",_time);
    if(_time <= 0.0f)
    {
        [progressTimer invalidate];
        [progressBar setHidden:YES];
        [leftButton setHidden:NO];
        [rightButton setHidden:NO];
        
    }
    else
    {
        _time -= 0.05;
         progressBar.value = (4-_time)*100/4;
    }
}

-(void)animateProgressView
{
 
    [progressBar setHidden:NO];
    [leftButton setHidden:YES];
    [rightButton setHidden:YES];
    progressBar.value = 0;
    _time = 4;
    progressTimer = [NSTimer scheduledTimerWithTimeInterval: 0.05f
                                             target: self
                                           selector: @selector(updateProgressBar)
                                           userInfo: nil
                                            repeats: YES];
}



-(void)showAddNodePanel{
    addNodeViewCtr=[[AddNodeFBViewController alloc]initWithNibName:@"AddNodeFBViewController" bundle:nil];
    addNodeViewCtr.parentFeedbackViewCtr=self;
    [addNodeViewCtr.view setBackgroundColor:[UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1]];
    [addNodeViewCtr.view setFrame:messageView.frame];
    [self.view addSubview:addNodeViewCtr.view];
    [leftButton setTitle:@"Add Node" forState:UIControlStateNormal];
    leftButton.enabled=NO;
    [addNodeViewCtr upDateCandidateNodes:missingConceptAry];
}



- (IBAction)clickOnLeft:(id)sender {
    if(1==feedbackState && (missingConceptAry.count>0)){
        [self showAddNodePanel];
        feedbackState=3;
        return;
    }
    if(2==feedbackState){
        [self showAddNodePanel];
        feedbackState=3;
        return;
    }
    if(3==feedbackState){
        [parentCmapController.feedbackPV dismiss];
        [parentCmapController createNodeFromBook:CGPointMake( arc4random() % 400+30, 690) withName:addNodeViewCtr.conceptName BookPos:CGPointMake(0, 0) page:1];
        feedbackState=1;
        return;
    }
    if(4==feedbackState){
        [parentCmapController.feedbackPV dismiss];
        [parentCmapController.parentBookPageViewController.bookView showFirstPage:4];
        feedbackState=1;
        return;
    }
    if(5==feedbackState){
        [parentCmapController.feedbackPV dismiss];
        [parentCmapController showDualTextbookView];
        feedbackState=1;
        return;
    }
     [parentCmapController.feedbackPV dismiss];
    return;
}

- (IBAction)clickOnRight:(id)sender {
    [parentCmapController.feedbackPV dismiss];
}


-(void)upDateContent{
  leftButton.enabled=YES;
    if(addNodeViewCtr.view){
        [addNodeViewCtr.view removeFromSuperview];
    }
    
  if(1==feedbackState){
      messageView.text=@"I notied that you've been reading for a while, would you like to consider adding some nodes to your map?";
      [leftButton setTitle:@"OK" forState:UIControlStateNormal];
      
      if(missingConceptAry.count>0){
          [leftButton setTitle:@"Show me some" forState:UIControlStateNormal];
      }
      
  }
    
    if(10==feedbackState){
        messageView.text=@"Good job! You just compared related concepts and created cross-links. Behaviors like this will help you understand the content more!";
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
    }
    
    
}

@end
