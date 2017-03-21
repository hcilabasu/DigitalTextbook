/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */

#import "OpenQuestionViewController.h"

@interface OpenQuestionViewController ()

@end

@implementation OpenQuestionViewController
@synthesize timeLable;
@synthesize startDate;
@synthesize totalCountdownInterval;
@synthesize titleLable;
@synthesize totalQuestion;
- (id)initWithOpenQuestion:(ISOpenQuestion*)question
                  response:(ISOpenQuestionResponse*)response
                controller:(id <QuizController>)controller
{
    if (self = [super initWithNibName:@"OpenQuestionViewController" bundle:NULL])
    {
        _question = question;
        _controller = controller;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _questionTextView.text = _question.text;
    _responseField.delegate = self;
    if([_controller getQuestionIndex]!=[_controller getTotalQuestionNumber]){//display next only when its not the last question
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSString *title = [[NSString alloc] initWithFormat:@"Question %d / %d",[_controller getQuestionIndex]  , [_controller getTotalQuestionNumber]];
    [titleLable setText:title];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)viewWillDisappear:(BOOL)animated{
   // self.navigationController.navigationBar.topItem.title=@"Back";
}

- (void)viewDidAppear:(BOOL)animated
{
    [_responseField becomeFirstResponder];
   // self.navigationController.navigationBar.backItem.title=@"Back";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_controller nextQuestion];
    return true;
}

- (void)next:(id)sender
{
    [_controller nextQuestion];
}


- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
    [_controller decreaseIndex];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTimeer: (int)remainTime{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCountdown:) userInfo:nil repeats:YES];
    totalCountdownInterval=remainTime;
}

-(void) checkCountdown:(NSTimer*)_timer {
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    NSTimeInterval remainingTime = totalCountdownInterval - elapsedTime;
    int second=(int)remainingTime;
    NSString *speedLabel = [[NSString alloc] initWithFormat:@"%d ", second ];
     timeLable.text=speedLabel;
    if (remainingTime <= 0.0) {
        
        [_timer invalidate];
    }
}

@end
