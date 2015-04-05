/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */


#import <UIKit/UIKit.h>
#import "ISQuizKit.h"
#import "QuizController.h"

@interface ViewController : UIViewController <QuizController, UINavigationControllerDelegate>
{
    IBOutlet UILabel* _scoreLabel;
   // __weak IBOutlet UIButton *startButton;
    ISSession* _session;
    int _questionIndex;
    ISQuiz* _quiz;
}
@property (weak, nonatomic) IBOutlet UIButton *quizButton;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property NSTimeInterval totalCountdownInterval;
@property NSTimeInterval remainTime;
@property NSDate* startDate;
@property BOOL isQiuzStart;
@property int currentQuestionId;
@property NSMutableArray* conceptIdArray;
- (IBAction)startQuiz:(id)sender;
- (void)nextQuestion;
@property BOOL isFinished;
@end
