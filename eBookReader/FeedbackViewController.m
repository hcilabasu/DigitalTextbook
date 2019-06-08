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
#import "AppDelegate.h"
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
@synthesize relatedPage;
@synthesize bookLogDataWrapper;
@synthesize relatedKC;
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
    
    NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
    if( [FBType isEqualToString: FB_PROCESS]){
        
        [self TLog:@"Dismiss due to process only condition setup"];
         [parentCmapController.feedbackPV dismiss];
        return;
    }
    
    if(FBTYPE_RRR==feedbackState && (missingConceptAry.count>0)){
        [self TLog:@"Show Add Node Panel"];
        [self showAddNodePanel];
        feedbackState=3;
        return;
    }
    if(2==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Show node panel" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        
        [self showAddNodePanel];
        feedbackState=3;
        return;
    }
    if(FBTYPE_ADD==feedbackState){
        [self TLog:@"Dismiss add node panel"];
        [parentCmapController.feedbackPV dismiss];
        int page=1;
        
        for(KeyConcept * kc in  parentCmapController.parentBookPageViewController.expertModel.keyConceptsAry){
            if ([addNodeViewCtr.conceptName.lowercaseString rangeOfString: kc.name.lowercaseString].location != NSNotFound) {
                page=kc.page;
                
            }
        }
        
        [parentCmapController createNodeFromFeedback:CGPointMake( arc4random() % 400+30, 690) withName:addNodeViewCtr.conceptName BookPos:CGPointMake(0, 0) page:page];
        feedbackState=1;
        NSString* msg= [[NSString alloc]initWithFormat:@"Created node (%@) from adding node panel",addNodeViewCtr.conceptName];
        [self TLog:msg];
        
        return;
    }
    
    if(FBTYPE_NAVIGATION==feedbackState){
        NSString* inputString= [[NSString alloc]initWithFormat:@"%d",relatedPage-1];
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Navigating to related page using from feedback view" selection:@"Tutor" input:inputString pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        [parentCmapController.feedbackPV dismiss];
        [parentCmapController.parentBookPageViewController.bookView showFirstPage:relatedPage-1];
        [parentCmapController.parentBookPageViewController showLeftHLRect:relatedKC];
        feedbackState=1;
        return;
    }
    
    //compare feedback
    if(FBTYPE_COMPARE==feedbackState){
        [self TLog:@"Enter compare view"];
        NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
        if( [FBType isEqualToString: FB_PROCESS]){
            [parentCmapController.feedbackPV dismiss];
        }
        
        [parentCmapController.feedbackPV dismiss];
        [parentCmapController showDualTextbookView];
        feedbackState=1;
        return;
    }
    
    if(FBTYPE_TEMPLATE==feedbackState){
        [self TLog:@"Highlight all template nodes"];
        [parentCmapController highlightUnLinkedTemplateNoeds:YES];
        
    }
    
    if(FBTYPE_TEMPLATE_NOTAP==feedbackState){
        [self TLog:@"Highlight one template nodes"];
        [parentCmapController highlightUnLinkedTemplateNoeds:NO];
        
    }
     [parentCmapController.feedbackPV dismiss];
    return;
}

- (IBAction)clickOnRight:(id)sender {
    LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Click on cancel to dismiss feedback" selection:@"Tutor" input:addNodeViewCtr.conceptName pageNum:parentCmapController.pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
    [parentCmapController.feedbackPV dismiss];
    
    
}


-(void)upDateContent{
    leftButton.enabled=YES;
    if(addNodeViewCtr.view){
        [addNodeViewCtr.view removeFromSuperview];
        
    }
    
    
    if(FBTYPE_TEMPLATE==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger no template feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        messageView.text=@"Our template covers some of the most important concepts in the content. Try tapping on a few nodes in the template to preview what you are about to learn!";
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
    }
    
    
    if(FBTYPE_BACK==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger no back navigation feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        messageView.text=@"You've been doing great, just wanted to remind you that constantly reviewing previous concepts and make connections would be helpful!";
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
        
    }
    
    
    if(FBTYPE_RRR==feedbackState){
    LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger RRR feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
        
      messageView.text=@"Hello, I noticed you have just read 3 pages, anything interesting you would like to add to your map?";
      [leftButton setTitle:@"OK" forState:UIControlStateNormal];
        
        NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
        if( [FBType isEqualToString: FB_PROCESS]){
            return;
        }
        
      if(missingConceptAry.count>0){
          [leftButton setTitle:@"Show me some" forState:UIControlStateNormal];
      }
    }
    
    if(FBTYPE_POSITIVE==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger positive compare and link feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];

        NSString* leftNodeName= parentCmapController.linkJustAdded.leftNode.text.text;
        NSString* rightNodename= parentCmapController.linkJustAdded.righttNode.text.text;
        NSString* feedbackTxt= [[NSString alloc]initWithFormat:@"Good job! You just compared and created a  cross-link between \"%@\" and \"%@\". This can be very beneficial. Keep doing this!",leftNodeName,rightNodename];
        messageView.text=feedbackTxt;
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
        NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
        if( [FBType isEqualToString: FB_PROCESS]){
            messageView.text=@"Good job! You just compared and linked two concepts. This can be beneficial. Keep doing this!";
        }
        if(1== parentCmapController.PositiveFeedbackCount){
             messageView.text=@"Awesome job spotting this relationship! Keep going!";
        }
        if(2== parentCmapController.PositiveFeedbackCount){
            messageView.text=@"Great! You are doing better and better!";
        }
        
        
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
    }
    
    if(FBTYPE_COMPARE==feedbackState){
        int leftPage=parentCmapController.parentBookPageViewController.expertModel.comparePageLeft;
        int rightPage=parentCmapController.parentBookPageViewController.expertModel.comparePageRight;
        NSString* inputString= [[NSString alloc]initWithFormat:@"%d_%d",leftPage,rightPage];
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger low quality cross-link feedback" selection:@"Tutor" input:inputString pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        
        messageView.text=@"Good job creating the cross-link! But it looks like you haven't carefully read them yet. Would you like to compare these two concepts?";
        [leftButton setTitle:@"Compare them" forState:UIControlStateNormal];
        
        NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
        if( [FBType isEqualToString: FB_PROCESS]){
            messageView.text=@"Good job creating the cross-link! But it looks like you haven't carefully read them yet. Reading and comparing concepts are important before linking them.";
            [leftButton setTitle:@"OK" forState:UIControlStateNormal];
            return;
        }
        
    }
    
    if(FBTYPE_AAA==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger SE feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        
        messageView.text=@"I noticed that you've been adding several concept nodes. Linking the nodes you created with the existing map would be beneficial!";
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
        
        
        NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
        if( [FBType isEqualToString: FB_PROCESS]){
            return;
        }
        
        int page=[self getRelatedNodePage];
        if( page>-1 ){
            relatedPage=page;
            feedbackState=FBTYPE_NAVIGATION;
            [leftButton setTitle:@"See related concepts" forState:UIControlStateNormal];
        }
    }
    
    if(FBTYPE_NOACTION==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger no action feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        messageView.text=@"Hi, I noticed that you've been reading for a while, would you like to add some concepts and links to your map?";
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
        
        NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
        if( [FBType isEqualToString: FB_PROCESS]){
            return;
        }
        if(missingConceptAry.count>0){
            [leftButton setTitle:@"Show me some" forState:UIControlStateNormal];
            feedbackState=FBTYPE_RRR;
        }
    }//end of no action
    
    
    if(FBTYPE_POS_CROSSLINK==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger first cross link feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        NSString* leftNodeName= parentCmapController.linkJustAdded.leftNode.text.text;
        NSString* rightNodename= parentCmapController.linkJustAdded.righttNode.text.text;
        NSString* feedbackTxt= [[NSString alloc]initWithFormat:@"Good job creating a cross-link between \"%@\" and \"%@\". This can be very beneficial. Keep doing this!",leftNodeName,rightNodename];
        messageView.text=feedbackTxt;
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
        NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
        if( [FBType isEqualToString: FB_PROCESS]){
           messageView.text=@"Good job creating a cross-link. This can be very beneficial. Keep doing this!";
        }
        
    }
    
    if(FBTYPE_POS_BACKNAVI==feedbackState){
        LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:@"Trigger first back navigation feedback" selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        
        messageView.text=@"Good job! You just went back to compared concepts. This can be very beneficial. Keep doing this!";
        [leftButton setTitle:@"OK" forState:UIControlStateNormal];
    }
    
    
}



-(int)getRelatedNodePage{
    int page=-1;
    int nodeCount= (int) [parentCmapController.conceptNodeArray count];
    if(nodeCount<3){
        return -1;
    }
    
    NSString* relatedConceptName=@"";
    NodeCell* node1= [parentCmapController.conceptNodeArray objectAtIndex:nodeCount-1];
    NodeCell* node2= [parentCmapController.conceptNodeArray objectAtIndex:nodeCount-2];
    NodeCell* node3= [parentCmapController.conceptNodeArray objectAtIndex:nodeCount-3];
    NodeCell* node4=node3;
    if(parentCmapController.conceptNodeArray.count>3){
        NodeCell* node4= [parentCmapController.conceptNodeArray objectAtIndex:nodeCount-4];
    }
    NSString* node1Name=node1.text.text.lowercaseString;
    NSString* node2Name=node2.text.text.lowercaseString;
    NSString* node3Name=node3.text.text.lowercaseString;
    NSString* node4Name=node4.text.text.lowercaseString;
    for ( KeyLink* link in parentCmapController.parentBookPageViewController.expertModel.keyLinksAry ){
        if ([node1Name rangeOfString: link.leftName.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.rightname.lowercaseString;
        }
        if ([node1Name rangeOfString: link.rightname.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.leftName.lowercaseString;
        }
        
        if ([node2Name rangeOfString: link.leftName.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.rightname.lowercaseString;
        }
        if ([node2Name rangeOfString: link.rightname.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.leftName.lowercaseString;
        }
        
        if ([node3Name rangeOfString: link.leftName.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.rightname.lowercaseString;
        }
        if ([node3Name rangeOfString: link.rightname.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.leftName.lowercaseString;
        }
        
        if ([node4Name rangeOfString: link.leftName.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.rightname.lowercaseString;
        }
        if ([node4Name rangeOfString: link.rightname.lowercaseString].location != NSNotFound) {
            relatedConceptName=link.leftName.lowercaseString;
        }
    }
    if( [relatedConceptName isEqualToString:@""]){
        return -1;
    }
    
    for (KeyConcept* kc in parentCmapController.parentBookPageViewController.expertModel.keyConceptsAry){
        if ([kc.conceptName.lowercaseString rangeOfString: relatedConceptName].location != NSNotFound) {
            page=kc.page;
            relatedKC=kc;
            return page;
        }
    }

    return -1;
}



-(void)TLog: (NSString*)msg{
    
    LogData* newlog= [[LogData alloc]initWithName:@"" SessionID:@"" action:msg selection:@"Tutor" input:@"" pageNum:parentCmapController.pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
}
@end
