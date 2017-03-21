/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */


#import "QuizViewController.h"
#import "OpenQuestionViewController.h"
#import "TrueFalseViewController.h"
#import "MultipleChoiceViewController.h"
#import "BookPageViewController.h"
#import "LogData.h"
#import "VideoViewController.h"
@interface QuizViewController ()

@end

@implementation QuizViewController
@synthesize isFinished;
@synthesize quizButton;
@synthesize myButton;
@synthesize totalCountdownInterval;
@synthesize startDate;
@synthesize remainTime;
@synthesize isQiuzStart;
@synthesize currentQuestionId;
@synthesize conceptIdArray;
@synthesize parentBookPageViewController;
@synthesize testType;
@synthesize questionNum;
@synthesize randomQuestionArray;
@synthesize question1;
@synthesize question2;
@synthesize question3;
@synthesize question4;
@synthesize question5;
@synthesize question6;


@synthesize question1Answer;
@synthesize question2Answer;
@synthesize question3Answer;
@synthesize question4Answer;
@synthesize question5Answer;
@synthesize question6Answer;


@synthesize correctIndexAry;
@synthesize wrongIndexAry;
@synthesize bookLogDataWrapper;
@synthesize userName;
@synthesize hasShowVideo;
- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom stuff
        questionNum=30;
        randomQuestionArray=[[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self)
    {
        // Custom stuff
        questionNum=6;
        randomQuestionArray=[[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    if(0==testType&&!hasShowVideo){
        VideoViewController *tutorial= [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
        [self.navigationController pushViewController:tutorial animated:NO];
        hasShowVideo=YES;
    }*/
    
    correctIndexAry=[[NSMutableArray alloc]init];
    wrongIndexAry=[[NSMutableArray alloc]init];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.navigationController.delegate = self;
    isQiuzStart=false;
    _scoreLabel.text = @"This quiz contains 6 questions. You  have 90 seconds to finish the quiz.\n If you finish early, just review your answers.";
    //isFinished=false;
    [self.navigationController setNavigationBarHidden: NO animated:YES];
    self.parentViewController.navigationController.navigationBar.translucent = YES;
    
     quizButton.backgroundColor = [UIColor whiteColor];
    if(isFinished){
        [quizButton setTitle:@"Finished" forState:UIControlStateNormal];
    }else{
      [quizButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    //totalCountdownInterval=90;//identifies the total time of the quiz.
    totalCountdownInterval=5;//identifies the total time of the quiz.

   // NSString *speedLabel = [[NSString alloc] initWithFormat:@"Time remaining %02d : %02d ", (int)totalCountdownInterval/60, (int)totalCountdownInterval%60];
   // self.navigationController.navigationBar.topItem.title=speedLabel;
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCountdown:) userInfo:nil repeats:YES];
    
    for(int i=0; i<50;i++)//initialize the concept Id list.
        conceptIDList[i]=1;
    
    int r1 = arc4random_uniform(10);
    int r2,r3,r4,r5,r6;
    
    do{r2=arc4random_uniform(10);}
    while(r2==r1);
    
    
    do{r3=arc4random_uniform(10);}
    while(r3==r1||r3==r2);
    
    do{r4=arc4random_uniform(10);}
    while(r4==r1||r4==r2||r4==r3);
    
    do{r5=arc4random_uniform(10);}
    while(r5==r1||r5==r2||r5==r3||r5==r4);
    
    do{r6=arc4random_uniform(10);}
    while(r6==r1||r6==r2||r6==r3||r6==r4||r6==r5);
    
    
    question1Answer=[self getQuestionAnswerById:r1];
    question2Answer=[self getQuestionAnswerById:r2];
    question3Answer=[self getQuestionAnswerById:r3];
    question4Answer=[self getQuestionAnswerById:r4];
    question5Answer=[self getQuestionAnswerById:r5];
    question6Answer=[self getQuestionAnswerById:r6];
    
    
    NSNumber* wrapR1 = [NSNumber numberWithInt:r1];
    NSNumber* wrapR2 = [NSNumber numberWithInt:r2];
    NSNumber* wrapR3 = [NSNumber numberWithInt:r3];
    NSNumber* wrapR4 = [NSNumber numberWithInt:r4];
    NSNumber* wrapR5 = [NSNumber numberWithInt:r5];
    NSNumber* wrapR6 = [NSNumber numberWithInt:r6];
    
    [randomQuestionArray addObject:wrapR1];
    [randomQuestionArray addObject:wrapR2];
    [randomQuestionArray addObject:wrapR3];
    [randomQuestionArray addObject:wrapR4];
    [randomQuestionArray addObject:wrapR5];
    [randomQuestionArray addObject:wrapR6];
    
    
    NSString* inputString=[[NSString alloc] initWithFormat:@"%d, %d, %d, %d, %d, %d", r1,r2,r3,r4,r5, r6];
    
    NSLog(@"Test questions ID:");
    NSLog(inputString);
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Generating test questions" selection:@"quiz view" input:inputString pageNum:0];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
}


-(NSString*)getQuestionAnswerById: (int) index{
    switch ( index )
    {
        case 0:
            return @"false";
        case 1:
            return @"true";
        case 2:
            return @"true";
        case 3:
            return @"true";
        case 4:
            return @"false";
        case 5:
            return @"true";
        case 6:
            return @"false";
        case 7:
            return @"true";
        case 8:
            return @"true";
        case 9:
            return @"false";
        default:
            ;
    }
    return @"";
}


-(void) checkCountdown:(NSTimer*)_timer {
    
    if(!isQiuzStart){
        remainTime = totalCountdownInterval;
    }else{
        NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
        remainTime = totalCountdownInterval - elapsedTime;
    }
    int second=(int)remainTime;
    NSString *speedLabel = [[NSString alloc] initWithFormat:@"Time remaining %02d : %02d ", second/60, second%60];
    self.navigationController.navigationBar.topItem.title=speedLabel;
    if(remainTime<=30){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    }
    if (remainTime <= 0.0) {
        isFinished=YES;
        [_timer invalidate];
        if(0==testType){
            [self.navigationController popToViewController:self animated:false];
            NSString *speedLabel = [[NSString alloc] initWithFormat:@"Finished"];
            self.navigationController.navigationBar.topItem.title=speedLabel;
            
            NSString* inputString=[[NSString alloc] initWithFormat:@"Q1 Answer:%@, Q2 Answer:%@, Q3 Answer:%@, Q4 Answer:%@, Q5 Answer:%@, Q6 Answer:%@.", question1,question2,question3,question4,question5,question6];
            LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Finish Pre Test" selection:@"quiz view" input:inputString pageNum:0];
            [bookLogDataWrapper addLogs:newlog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            
            NSString* inputString2=[[NSString alloc] initWithFormat:@"Pretest Correct Answers: %@, %@, %@, %@,%@, %@", question1Answer,question2Answer,question3Answer,question4Answer,question5Answer,question6Answer];
            LogData* newlog2= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Getting answer" selection:@"quiz view" input:inputString2 pageNum:0];
            [bookLogDataWrapper addLogs:newlog2];
            [LogDataParser saveLogData:bookLogDataWrapper];
    
            int total=[self getTotalScore:question1 Q2:question2 Q3:question3 Q4:question4 Q5:question5 Q6:question6 A1:question1Answer A2:question2Answer A3:question3Answer A4:question4Answer A5:question5Answer A6:question6Answer];
            NSString* scoreSring=[[NSString alloc] initWithFormat:@"Pretest Score: %d", total];
            LogData* scoreLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Getting answer" selection:@"quiz view" input:scoreSring pageNum:0];
            [bookLogDataWrapper addLogs:scoreLog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            
            NSString* testSmary=@"";
            for(NSNumber* num in correctIndexAry){
                testSmary=[testSmary stringByAppendingString:[num stringValue]];
                testSmary=[testSmary stringByAppendingString:@", "];
            }
            
            LogData* smryLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Correct Questions in PreTest" selection:@"quiz view" input:testSmary pageNum:0];
            [bookLogDataWrapper addLogs:smryLog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            
            
            NSString* wrongtestSmary=@"";
            for(NSNumber* num in wrongIndexAry){
                wrongtestSmary=[wrongtestSmary stringByAppendingString:[num stringValue]];
                wrongtestSmary=[wrongtestSmary stringByAppendingString:@", "];
            }
            
            parentBookPageViewController.cmapView.correctIndexAry=correctIndexAry;
            [parentBookPageViewController.cmapView loadConceptMap:nil];
            
            
            LogData* wrongsmryLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Wrong Questions in PreTest" selection:@"quiz view" input:wrongtestSmary pageNum:0];
            [bookLogDataWrapper addLogs:wrongsmryLog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            
            
        }else{
            [self.navigationController popToViewController:self animated:false];
             NSString* inputString=[[NSString alloc] initWithFormat:@"Q1 Answer:%@, Q2 Answer:%@, Q3 Answer:%@, Q4 Answer:%@.", question1,question2,question3,question4];
            LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Finish Posts Test" selection:@"quiz view" input:inputString pageNum:0];
            [bookLogDataWrapper addLogs:newlog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            [parentBookPageViewController upLoadLogFile];
            
             int total=[self getTotalScore:question1 Q2:question2 Q3:question3 Q4:question4 Q5:question5 Q6:question6 A1:question1Answer A2:question2Answer A3:question3Answer A4:question4Answer A5:question5Answer A6:question6Answer];
            NSString* scoreSring=[[NSString alloc] initWithFormat:@"Posttest Score: %d", total];
            LogData* scoreLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Getting answer" selection:@"quiz view" input:scoreSring pageNum:0];
            [bookLogDataWrapper addLogs:scoreLog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            
            NSString* testSmary=@"";
            for(NSNumber* num in correctIndexAry){
                testSmary=[testSmary stringByAppendingString:[num stringValue]];
                testSmary=[testSmary stringByAppendingString:@", "];
            }
            
            LogData* smryLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Correct Questions in PostTest" selection:@"quiz view" input:testSmary pageNum:0];
            [bookLogDataWrapper addLogs:smryLog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            
            
            NSString* wrongtestSmary=@"";
            for(NSNumber* num in wrongIndexAry){
                wrongtestSmary=[wrongtestSmary stringByAppendingString:[num stringValue]];
                wrongtestSmary=[wrongtestSmary stringByAppendingString:@", "];
            }
            
            
            
            LogData* wrongsmryLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Wrong Questions in PostTest" selection:@"quiz view" input:wrongtestSmary pageNum:0];
            [bookLogDataWrapper addLogs:wrongsmryLog];
            [LogDataParser saveLogData:bookLogDataWrapper];
            
            
            
            
            [self upLoadLogFiletoDropBox];
            [parentBookPageViewController.cmapView uploadExpertCMapImg];
            [parentBookPageViewController.cmapView uploadCMapImg];
            UIImage *dogimg = [UIImage imageNamed:@"Dog"];
            UIImageView *someImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
            someImageView.image = dogimg;
        
            self.navigationController.navigationBar.topItem.title=@"Finished!";
            
            [self.view addSubview:someImageView];
            // [self upLoadLogFiletoDropBox];
            // [self.view bringSubviewToFront:someImageView];
            
            // [self.parentBookPageViewController.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}



-(int)getTotalScore: (NSString*)q1 Q2:(NSString*)q2 Q3:(NSString*)q3 Q4:(NSString*)q4 Q5:(NSString*)q5 Q6:(NSString*)q6   A1:(NSString*)a1 A2:(NSString*)a2 A3:(NSString*)a3 A4:(NSString*)a4 A5:(NSString*)a5 A6:(NSString*)a6{
    int total=0;
    if([q1 isEqualToString:a1]) {
        total++;
        [correctIndexAry addObject:[randomQuestionArray objectAtIndex:0]];
    }else{
        [wrongIndexAry addObject:[randomQuestionArray objectAtIndex:0]];
    }
    
    if([q2 isEqualToString:a2]) {
        total++;
        [correctIndexAry addObject:[randomQuestionArray objectAtIndex:1]];
    }else{
        [wrongIndexAry addObject:[randomQuestionArray objectAtIndex:1]];
    }
    if([q3 isEqualToString:a3]) {
        total++;
        [correctIndexAry addObject:[randomQuestionArray objectAtIndex:2]];
    }else{
        [wrongIndexAry addObject:[randomQuestionArray objectAtIndex:2]];
    }
    if([q4 isEqualToString:a4]) {
        [correctIndexAry addObject:[randomQuestionArray objectAtIndex:3]];
        total++;
    }else{
        [wrongIndexAry addObject:[randomQuestionArray objectAtIndex:3]];
    }
    if([q5 isEqualToString:a5]) {
        [correctIndexAry addObject:[randomQuestionArray objectAtIndex:4]];
        total++;
    }else{
        [wrongIndexAry addObject:[randomQuestionArray objectAtIndex:4]];
    }
    if([q6 isEqualToString:a6]) {
        [correctIndexAry addObject:[randomQuestionArray objectAtIndex:5]];
        total++;
    }else{
        [wrongIndexAry addObject:[randomQuestionArray objectAtIndex:5]];
    }
    
    
    return total;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)startQuiz:(id)sender
{
    isQiuzStart=true;
    startDate = [NSDate date];
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Start Pre Test" selection:@"null" input:@"null" pageNum:0];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
    [quizButton setTitle:@"Finished" forState:UIControlStateNormal];
    if(isFinished){//fnish quiz and go to cmap view
        NSString* inputString=[[NSString alloc] initWithFormat:@"Q1 Answer:%@, Q2 Answer:%@.", question1,question2];
         LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Finish Pre Test" selection:@"null" input:inputString pageNum:0];
         [bookLogDataWrapper addLogs:newlog];
         [LogDataParser saveLogData:bookLogDataWrapper];
         // [parentBookPageViewController upLoadLogFile];
        [parentBookPageViewController startTimer];
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
*/

- (IBAction)startQuiz:(id)sender
{
 
    
    isQiuzStart=true;
    startDate = [NSDate date];
    
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Start Pre Test" selection:@"quiz view" input:@"null" pageNum:0];
    
     if(1==testType){
         newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Start Post Test" selection:@"quiz view" input:@"null" pageNum:0];
     }
    
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    [quizButton setTitle:@"Finished" forState:UIControlStateNormal];
    if(isFinished){//fnish quiz and go to cmap view
        /*
        NSString* inputString=[[NSString alloc] initWithFormat:@"Q1 Answer:%@, Q2 Answer:%@.", question1,question2];
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Finish Pre Test" selection:@"null" input:inputString pageNum:0];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];*/
        // [parentBookPageViewController upLoadLogFile];
       // [parentBookPageViewController startTimer];
       // [parentBookPageViewController startCmapTimer];
        /*
        VideoViewController *tutorial= [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
        tutorial.parentBookCtr=parentBookPageViewController;
        parentBookPageViewController.videoView=tutorial;
        [tutorial startTimer];
        [self.navigationController pushViewController:tutorial animated:NO];
         */
        
         [self.navigationController popViewControllerAnimated:NO];
        [parentBookPageViewController startCmapTimer];
       // [parentBookPageViewController addTutorial];
       

        
        // [self.view removeFromSuperview];
       // [self removeFromParentViewController];
        return;
    }
    _quiz = [ISQuizParser quizNamed:@"programming.plist"];
    
    _scoreLabel.text = @"Now you will be reading a chapter of a textbook and creating a concept map. We have a template ready for you to start with. To show the concept mapping panel, you need to use the button on the top to rotate the iPad.";
    
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
    //return _quiz.questions.count;
    return questionNum;
}


- (ISSession*)session
{
    return _session;
} 

- (void)nextQuestion
{
    if (_questionIndex >= questionNum)
    {
        [_session stop];
        isFinished=true;
        ISGradingResult* result = [ISQuiz gradeSession:_session quiz:_quiz];
        _scoreLabel.text = [NSString stringWithFormat:@"Score %i/%i, Time: %.1fs,", result.points, result.pointsPossible, _session.time];
        [self.navigationController popToViewController:self animated:false];
        return;
    }
    int QZindex=0;
    if(0==testType){
        NSNumber* ran1= [randomQuestionArray objectAtIndex:_questionIndex];
        QZindex=[ran1 intValue];
    }else{
        NSNumber* ran1= [randomQuestionArray objectAtIndex:(_questionIndex)];
        QZindex=[ran1 intValue];
    }
    
    //ISQuestion* question = [_quiz.questions objectAtIndex:_questionIndex];
    
    ISQuestion* question = [_quiz.questions objectAtIndex:QZindex];

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
        NSString* currentAnswer;
        switch (_questionIndex) {
            case 0:
                currentAnswer=question1;
                break;
            case 1:
                currentAnswer=question2;
                break;
            case 2:
                currentAnswer=question3;
                break;
            case 3:
                currentAnswer=question4;
                break;
            case 4:
                currentAnswer=question5;
                break;

            case 5:
                currentAnswer=question6;
                break;

            default:
                break;
        }
        controller.currentAnswer=currentAnswer;
               
        
    
        controller.totalQuestion=_quiz.questions.count;
        controller.parentQuizController=self;
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


-(void)upLoadLogFiletoDropBox{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    //make a file name to write the data to using the documents directory:
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory
                          stringByAppendingPathComponent:@"LogData.xml"];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSString *filename = @"TurkLogfile/LogData_";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    filename=[filename stringByAppendingString:usrName];
    filename=[filename stringByAppendingString:@".xml"];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/auto/%@?overwrite=false",filename]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    [request setTimeoutInterval:1000];
    
    NSURLSessionDataTask *doDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"WORKED!!!!");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    [doDataTask resume];
    
}

@end
