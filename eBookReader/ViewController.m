/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */


#import "ViewController.h"
#import "OpenQuestionViewController.h"
#import "TrueFalseViewController.h"
#import "MultipleChoiceViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize isFinished;
@synthesize quizButton;
@synthesize myButton;
@synthesize totalCountdownInterval;
@synthesize startDate;
@synthesize remainTime;
@synthesize isQiuzStart;
@synthesize currentQuestionId;
@synthesize conceptIdArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    isQiuzStart=false;
    _scoreLabel.text = @"This quiz contains 10 question. You  have 10 minutes to finish the quiz.\n If you finish ealy, just review your answers and wait for others.";
    //isFinished=false;
    [self.navigationController setNavigationBarHidden: NO animated:YES];
     quizButton.backgroundColor = [UIColor whiteColor];
    if(isFinished){
        [quizButton setTitle:@"Finished" forState:UIControlStateNormal];
    }else{
      [quizButton setTitle:@"Start" forState:UIControlStateNormal];
    }
   totalCountdownInterval=40;//identifies the total time of the quiz.

    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCountdown:) userInfo:nil repeats:YES];
   }



-(void) checkCountdown:(NSTimer*)_timer {
    
    if(!isQiuzStart){
        NSString *speedLabel = [[NSString alloc] initWithFormat:@"Time remaining %02d : %02d ", (int)totalCountdownInterval/60, (int)totalCountdownInterval%60];
        self.navigationController.navigationBar.topItem.title=speedLabel;
        return;
    }
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    remainTime = totalCountdownInterval - elapsedTime;
    int second=(int)remainTime;
    NSString *speedLabel = [[NSString alloc] initWithFormat:@"Time remaining %02d : %02d ", second/60, second%60];
    self.navigationController.navigationBar.topItem.title=speedLabel;
    if(remainTime<=30){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    }
    
    if (remainTime <= 0.0) {
        [_timer invalidate];
        [self.navigationController popToViewController:self animated:false];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startQuiz:(id)sender

{
    isQiuzStart=true;
    startDate = [NSDate date];
    [quizButton setTitle:@"Finished" forState:UIControlStateNormal];
        if(isFinished){
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    _quiz = [ISQuizParser quizNamed:@"programming.plist"];
    
    _scoreLabel.text = @"";

    _session = [[ISSession alloc] init];
    [_session start:_quiz];
    
    _questionIndex = 0;
    [self nextQuestion];
    }


-(void)decreaseIndex{
    
    _questionIndex--;
    NSLog(@"Index: %d",_questionIndex);
}

-(int)getQuestionIndex{
    return _questionIndex;
}

-(int)getTotalQuestionNumber{
    return _quiz.questions.count;
}


- (ISSession*)session
{
    return _session;
} 

- (void)nextQuestion
{
    if (_questionIndex >= _quiz.questions.count)
    {
        
        [_session stop];
        isFinished=true;
        ISGradingResult* result = [ISQuiz gradeSession:_session quiz:_quiz];
    
        _scoreLabel.text = [NSString stringWithFormat:@"Score %i/%i, Time: %.1fs,", result.points, result.pointsPossible, _session.time];
        [self.navigationController popToViewController:self animated:false];
         
        return;
    }
    
    ISQuestion* question = [_quiz.questions objectAtIndex:_questionIndex];
    
    
    if ([question isKindOfClass:[ISOpenQuestion class]])
    {
        OpenQuestionViewController* controller = [[OpenQuestionViewController alloc] initWithOpenQuestion:(ISOpenQuestion*)question
                                                                                                 response:NULL
                                                                                               controller:self];
        controller.totalQuestion=_quiz.questions.count;
        [self.navigationController pushViewController:controller animated:NO];
       
    }
    else if ([question isKindOfClass:[ISMultipleChoiceQuestion class]])
    {
        MultipleChoiceViewController* controller = [[MultipleChoiceViewController alloc] initWithMultipleChoiceQuestion:(ISMultipleChoiceQuestion*)question
                                                                                                               response:NULL
                                                                                                             controller:self];
    
        controller.totalQuestion=_quiz.questions.count;
        [self.navigationController pushViewController:controller animated:NO];
       
    }
    else if ([question isKindOfClass:[ISTrueFalseQuestion class]])
    {
        TrueFalseViewController* controller = [[TrueFalseViewController alloc] initWithTrueFalseQuestion:(ISTrueFalseQuestion*)question
                                                                                                response:NULL
                                                                                              controller:self];
        controller.totalQuestion=_quiz.questions.count;
        [self.navigationController pushViewController:controller animated:NO];
    }
    
    _questionIndex += 1;
}


@end
