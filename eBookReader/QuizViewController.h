/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */


#import <UIKit/UIKit.h>
#import "ISQuizKit.h"
#import "QuizController.h"
#import "LogDataWrapper.h"
@class BookPageViewController;
@interface QuizViewController : UIViewController <QuizController, UINavigationControllerDelegate>
{
    IBOutlet UILabel* _scoreLabel;
   // __weak IBOutlet UIButton *startButton;
    ISSession* _session;
    int _questionIndex;
    ISQuiz* _quiz;
    int conceptIDList[50]; // a list that maps to each question to a specific concetp, represented in ID
}
@property (weak, nonatomic) IBOutlet UIButton *quizButton;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property NSTimeInterval totalCountdownInterval;
@property NSTimeInterval remainTime;
@property NSDate* startDate;
@property BOOL isQiuzStart;
@property int currentQuestionId;
@property int testType; //0: pre test, 1: post test
@property int questionNum;
@property NSMutableArray* conceptIdArray;
@property NSMutableArray* randomQuestionArray;
@property NSString* question1;
@property NSString* question2;
@property NSString* question3;
@property NSString* question4;
@property NSString* question5;
@property NSString* question6;

@property NSString* question1Answer;
@property NSString* question2Answer;
@property NSString* question3Answer;
@property NSString* question4Answer;
@property NSString* question5Answer;
@property NSString* question6Answer;

@property NSMutableArray* correctIndexAry;
@property NSMutableArray* wrongIndexAry;

@property (nonatomic, retain) LogDataWrapper* bookLogDataWrapper;
@property (strong, nonatomic) NSString* userName;
- (IBAction)startQuiz:(id)sender;
- (void)nextQuestion;
@property BOOL isFinished;
@property BOOL hasShowVideo;
@property (strong, nonatomic) BookPageViewController* parentBookPageViewController;

@end


