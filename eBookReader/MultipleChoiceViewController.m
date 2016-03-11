/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */

#import "MultipleChoiceViewController.h"
#import "QuizViewController.h"
@interface MultipleChoiceViewController ()

@end

@implementation MultipleChoiceViewController
@synthesize timeLable;
@synthesize startDate;
@synthesize totalCountdownInterval;
@synthesize titleLable;
@synthesize totalQuestion;
@synthesize answerA;
@synthesize answerB;
@synthesize answerC;
@synthesize answerD;
@synthesize testType;
@synthesize parentQuizController;
@synthesize fwdBtn;
@synthesize bkBtn;
@synthesize currentAnswer;

- (id)initWithMultipleChoiceQuestion:(ISMultipleChoiceQuestion*)question
                            response:(ISMultipleChoiceOption*)response
                          controller:(id <QuizController>)controller
{
    if (self = [super initWithNibName:@"MultipleChoiceViewController" bundle:NULL])
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
    _questionTextView.editable=NO;
    
    if([_controller getQuestionIndex]!=[_controller getTotalQuestionNumber]){//display next only when its not the last question
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    }
    if([_controller getQuestionIndex]!=1){
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    }else{
        [self.navigationItem setHidesBackButton:YES animated:YES]; //if its the first question, hide the back button
    }

    NSString *title = [[NSString alloc] initWithFormat:@"Question %d / 6",[_controller getQuestionIndex] ];
    [titleLable setText:title];
   
    //[answerA setImage:[UIImage imageNamed:@"LoginButton.png"] forState:UIControlStateNormal];
   // NSString* anA=[_question.options objectAtIndex:0];
    
    
    //[answerC setHidden:YES];
    [answerD setHidden:YES];
    
    if([_controller getQuestionIndex]==1){
        [bkBtn setHidden:YES];
    }
    if([_controller getQuestionIndex]==6){
        [fwdBtn setHidden:YES];
    }

    if(currentAnswer.length>1){
        [self autoChoose:currentAnswer];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    //self.navigationController.navigationBar.topItem.title=@"Back";
}

- (void)viewDidAppear:(BOOL)animated
{
   
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _question.options.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ISMultipleChoiceOption* option = [_question.options objectAtIndex:row];
    return option.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startTiming{
    
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

- (IBAction)clickonA:(id)sender {
    
    if(1==[_controller getQuestionIndex] ){
        parentQuizController.question1=@"true";
    }else if(2==[_controller getQuestionIndex] ){
        parentQuizController.question2=@"true";
    }else if(3==[_controller getQuestionIndex] ){
        parentQuizController.question3=@"true";
    }
    else if(4==[_controller getQuestionIndex] ){
        parentQuizController.question4=@"true";
    }
    else if(5==[_controller getQuestionIndex] ){
        parentQuizController.question5=@"true";
    }
    else {
        parentQuizController.question6=@"true";
    }
    if ([sender isSelected]) {
        //[sender setSelected: NO];
    } else {
        [sender setSelected: YES];
        [answerB setSelected:NO];
        [answerC setSelected:NO];
        [answerD setSelected:NO];
    }

}

- (IBAction)clickonB:(id)sender {
    if(1==[_controller getQuestionIndex] ){
        parentQuizController.question1=@"false";
    }else if(2==[_controller getQuestionIndex] ){
        parentQuizController.question2=@"false";
    }else if(3==[_controller getQuestionIndex] ){
        parentQuizController.question3=@"false";
    }
    else if(4==[_controller getQuestionIndex] ){
        parentQuizController.question4=@"false";
    }

    else if(5==[_controller getQuestionIndex] ){
        parentQuizController.question5=@"false";
    }
    else {
        parentQuizController.question6=@"false";
    }
    
    if ([sender isSelected]) {
    } else {
        [sender setSelected: YES];
        [answerA setSelected:NO];
        [answerC setSelected:NO];
        [answerD setSelected:NO];
    }

}


- (IBAction)clickonC:(id)sender {
    
    if(1==[_controller getQuestionIndex] ){
        parentQuizController.question1=@"null";
    }else if(2==[_controller getQuestionIndex] ){
        parentQuizController.question2=@"null";
    }else if(3==[_controller getQuestionIndex] ){
        parentQuizController.question3=@"null";
    }
    else if(4==[_controller getQuestionIndex] ){
        parentQuizController.question4=@"null";
    }
    else if(5==[_controller getQuestionIndex] ){
        parentQuizController.question5=@"null";
    }
    else {
        parentQuizController.question6=@"null";
    }
    if ([sender isSelected]) {
        //[sender setSelected: NO];
    } else {
        [sender setSelected: YES];
        [answerB setSelected:NO];
        [answerA setSelected:NO];
        [answerD setSelected:NO];
    }

}





-(void)autoChoose:(NSString*) answer{
    if([answer isEqualToString:@"true"]){
        [answerA setSelected:YES];
        [answerB setSelected:NO];
        [answerC setSelected:NO];
        
    }else if([answer isEqualToString:@"false"]){
        [answerA setSelected:NO];
        [answerB setSelected:YES];
        [answerC setSelected:NO];
    }else{
        [answerA setSelected:NO];
        [answerB setSelected:NO];
        [answerC setSelected:YES];
    }
}


- (IBAction)clickonD:(id)sender {
    if ([sender isSelected]) {
        [sender setSelected: NO];
    } else {
        [sender setSelected: YES];
        [answerB setSelected:NO];
        [answerC setSelected:NO];
        [answerA setSelected:NO];
    }

}

- (IBAction)nxtQuestion:(id)sender {
    [_controller nextQuestion];
}

- (IBAction)preQuestion:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [_controller decreaseIndex];
}


@end
