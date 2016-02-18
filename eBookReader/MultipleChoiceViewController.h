/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */

#import <UIKit/UIKit.h>
#import "ISQuizKit.h"
#import "QuizController.h"
@class QuizViewController;
@interface MultipleChoiceViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>
{
    IBOutlet UITextView* _questionTextView;
    IBOutlet UIPickerView* _pickerView;
    ISMultipleChoiceQuestion* _question;
    id <QuizController> _controller;
}

- (id)initWithMultipleChoiceQuestion:(ISMultipleChoiceQuestion*)question
                            response:(ISMultipleChoiceOption*)response
                          controller:(id <QuizController>)controller;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)startTimeer: (int)remainTime;
@property UILabel *timeLable;
@property NSTimeInterval totalCountdownInterval;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property NSDate* startDate;
@property (strong,nonatomic) QuizViewController* parentQuizController;
@property int  totalQuestion;
@property (weak, nonatomic) IBOutlet UIButton *answerA;
@property (weak, nonatomic) IBOutlet UIButton *answerB;
@property (weak, nonatomic) IBOutlet UIButton *answerC;
@property (weak, nonatomic) IBOutlet UIButton *answerD;
@property int testType;
@property (weak, nonatomic) IBOutlet UIButton *fwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *bkBtn;


@property(strong,nonatomic)NSString* currentAnswer;
-(void)autoChoose:(NSString*) answer;

@end
