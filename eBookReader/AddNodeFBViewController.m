//
//  AddNodeFBViewController.m
//  Study
//
//  Created by Shang Wang on 2/6/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import "AddNodeFBViewController.h"
#import "FeedbackViewController.h"
#import "CmapController.h"
@interface AddNodeFBViewController ()

@end

@implementation AddNodeFBViewController
@synthesize node1;
@synthesize node2;
@synthesize node3;
@synthesize node4;
@synthesize SelectedNodeIndex;
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize conceptName;
@synthesize parentFeedbackViewCtr;
@synthesize bookLogDataWrapper;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *STN1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapNode1:)];
    STN1.delegate=self;
    [node1 addGestureRecognizer:STN1];
    
    
    UITapGestureRecognizer *STN2 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapNode2:)];
    STN2.delegate=self;
    [node2 addGestureRecognizer:STN2];
    
    UITapGestureRecognizer *STN3 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapNode3:)];
    STN3.delegate=self;
    [node3 addGestureRecognizer:STN3];
    
    UITapGestureRecognizer *STN4 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapNode4:)];
    STN4.delegate=self;
    [node4 addGestureRecognizer:STN4];
}


- (void)tapNode1:(UITapGestureRecognizer *)recognizer
{
    [node1.layer setShadowColor:[UIColor redColor].CGColor];
    [node1.layer setShadowOpacity:0.8];
    [node1.layer setShadowRadius:4.0];
    [node1.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    [node2.layer setShadowOpacity:0.0];
    [node3.layer setShadowOpacity:0.0];
    [node4.layer setShadowOpacity:0.0];
    SelectedNodeIndex=1;
    conceptName=label1.text;
    parentFeedbackViewCtr.parentCmapController.feedbackCtr.leftButton.enabled=YES;
    
}

- (void)tapNode2:(UITapGestureRecognizer *)recognizer
{
    [node2.layer setShadowColor:[UIColor redColor].CGColor];
    [node2.layer setShadowOpacity:0.8];
    [node2.layer setShadowRadius:4.0];
    [node2.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    [node1.layer setShadowOpacity:0.0];
    [node3.layer setShadowOpacity:0.0];
    [node4.layer setShadowOpacity:0.0];
    SelectedNodeIndex=2;
    conceptName=label2.text;
    parentFeedbackViewCtr.parentCmapController.feedbackCtr.leftButton.enabled=YES;
}

- (void)tapNode3:(UITapGestureRecognizer *)recognizer
{
    [node3.layer setShadowColor:[UIColor redColor].CGColor];
    [node3.layer setShadowOpacity:0.8];
    [node3.layer setShadowRadius:4.0];
    [node3.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    [node1.layer setShadowOpacity:0.0];
    [node2.layer setShadowOpacity:0.0];
    [node4.layer setShadowOpacity:0.0];
    SelectedNodeIndex=3;
    conceptName=label3.text;
    parentFeedbackViewCtr.parentCmapController.feedbackCtr.leftButton.enabled=YES;
}

- (void)tapNode4:(UITapGestureRecognizer *)recognizer
{
    [node4.layer setShadowColor:[UIColor redColor].CGColor];
    [node4.layer setShadowOpacity:0.8];
    [node4.layer setShadowRadius:4.0];
    [node4.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    [node1.layer setShadowOpacity:0.0];
    [node2.layer setShadowOpacity:0.0];
    [node3.layer setShadowOpacity:0.0];
    SelectedNodeIndex=4;
    conceptName=label4.text;
    parentFeedbackViewCtr.parentCmapController.feedbackCtr.leftButton.enabled=YES;
}


-(void)upDateCandidateNodes: (NSMutableArray*) missingAry{
    [node1 setHidden:NO];
    [label1 setHidden:NO];
    [node2 setHidden:NO];
    [label2 setHidden:NO];
    [node3 setHidden:NO];
    [label3 setHidden:NO];
    [node4 setHidden:NO];
    [label4 setHidden:NO];
    
    if( [missingAry count]<1){
        return;
    }
    
    if(1== [missingAry count]){
        KeyConcept* kc1= [missingAry objectAtIndex:0];
        label1.text=kc1.conceptName;
        
        [node2 setHidden:YES];
        [label2 setHidden:YES];
        [node3 setHidden:YES];
        [label3 setHidden:YES];
        [node4 setHidden:YES];
        [label4 setHidden:YES];
    }
    
    if(2== [missingAry count]){
        KeyConcept* kc1= [missingAry objectAtIndex:0];
        label1.text=kc1.conceptName;
        KeyConcept* kc2= [missingAry objectAtIndex:1];
        label2.text=kc2.conceptName;
        
        [node3 setHidden:YES];
        [label3 setHidden:YES];
        [node4 setHidden:YES];
        [label4 setHidden:YES];
    }
    
    if(3== [missingAry count]){
        KeyConcept* kc1= [missingAry objectAtIndex:0];
        label1.text=kc1.conceptName;
        KeyConcept* kc2= [missingAry objectAtIndex:1];
        label2.text=kc2.conceptName;
        KeyConcept* kc3= [missingAry objectAtIndex:2];
        label3.text=kc3.conceptName;
        [node4 setHidden:YES];
        [label4 setHidden:YES];
    }
    
    if([missingAry count]>=4){
        NSMutableArray* tempAry=missingAry;
        
        NSUInteger count = [tempAry count];
        for (NSUInteger i = 0; i < count; ++i) {
            // Select a random element between i and end of array to swap with.
            int nElements = (int)(count - i);
            int n = (int)((arc4random() % nElements) + i);
            [tempAry exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        
        KeyConcept* kc1= [missingAry objectAtIndex:0];
        label1.text=kc1.conceptName;
        KeyConcept* kc2= [missingAry objectAtIndex:1];
        label2.text=kc2.conceptName;
        KeyConcept* kc3= [missingAry objectAtIndex:2];
        label3.text=kc3.conceptName;
        KeyConcept* kc4= [missingAry objectAtIndex:3];
        label4.text=kc4.conceptName;
    }
    
    
}

@end
