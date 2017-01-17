/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */

#import <UIKit/UIKit.h>
#import "ISQuizKit.h"
#import "QuizController.h"

@interface TrueFalseViewController : UIViewController
{
    IBOutlet UITextView* _questionTextView;
    ISTrueFalseQuestion* _question;
    id <QuizController> _controller;
}

- (id)initWithTrueFalseQuestion:(ISTrueFalseQuestion*)question
                       response:(ISTrueFalseResponse*)response
                     controller:(id <QuizController>)controller;

-(void)startTimeer: (int)remainTime;

@property UILabel *timeLable;
@property NSTimeInterval totalCountdownInterval;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property NSDate* startDate;
@property int  totalQuestion;
@end
