//
//  BookPageViewController.m
//  eBookReader
//
//  Created by Shang Wang on 6/19/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "BookPageViewController.h"
#import "LogFileController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "NodeCell.h"
#import "ConceptLink.h"
#import "PreViewNode.h"
#import "VideoViewController.h"
#import "UIMenuItem+CXAImageSupport.h"
#import "ConditionSetup.h"
#import "AppDelegate.h"
@interface BookPageViewController ()

@end
@implementation BookPageViewController
@synthesize bookView;
@synthesize cmapView;
@synthesize restClient;
@synthesize logWrapper;
@synthesize QA;
@synthesize bulbImageView;
@synthesize ShowingQA;
@synthesize userName;
@synthesize enableHyperLink;
@synthesize totalCountdownInterval;
@synthesize remainTime;
@synthesize startDate;
@synthesize timerLable;
@synthesize previewImg;
@synthesize upperBorder;
@synthesize isShowPreView;
@synthesize conceptNodeArray;
@synthesize PreviewRect;
@synthesize  originalFrame;
@synthesize expertModel;
@synthesize isSecondShow;
@synthesize CmapTimer;
@synthesize isTraining;
@synthesize videoView;
@synthesize webFocusQuestionLable;
@synthesize cmapFocusQuestionLable;
@synthesize hintImg;
@synthesize myWebView;
@synthesize subViewType;
@synthesize secondBookView;
@synthesize compareViewReturnButton;
@synthesize overlayView;
@synthesize compareTitleButton;
@synthesize HLrectLeft;
@synthesize HLrectRight;
@synthesize linkNameFinder;
@synthesize audioPlayer;
@synthesize isInCompareView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        logWrapper= [LogDataParser loadLogData];
        // ShowingQA=true;
        conceptNodeArray=[[NSMutableArray alloc] init];
        subViewType=0;
        isInCompareView=NO;
        
    }
    return self;
}


-(void)addSwitchView{
    bulbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(498, 350, 30, 30)];
    [bulbImageView setImage:[UIImage imageNamed:@"switch.png"]];
    //bulbImageView.alpha=0.8;
    bulbImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *bulbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBulb:)];
    [self.bulbImageView addGestureRecognizer:bulbTap];
   // [self.view addSubview:bulbImageView];
    [bulbImageView setHidden:YES];
    bulbImageView.layer.shadowOpacity = 0.4;
    bulbImageView.layer.shadowRadius = 4;
    bulbImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    bulbImageView.layer.shadowOffset = CGSizeMake(2, 2);
    [self.view bringSubviewToFront:cmapView.view];
    [cmapView loadConceptMap:nil];
}

- (IBAction)clickOnBulb : (id)sender
{
    if(ShowingQA){
        [self.view bringSubviewToFront:cmapView.view];
       // [cmapView loadConceptMap:nil];
        ShowingQA=false;
    }else{
        [self.view bringSubviewToFront:QA.view];
        ShowingQA=true;
    }
    [self.view bringSubviewToFront:bulbImageView];
}


- (IBAction)QAonConcpet
{
    if(ShowingQA){
        [self.view bringSubviewToFront:cmapView.view];
        [cmapView loadConceptMap:nil];
        ShowingQA=false;
    }else{
        [self.view bringSubviewToFront:QA.view];
        ShowingQA=true;
    }
    [self.view bringSubviewToFront:bulbImageView];
}

-(void)finishTraining{
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Finish Tutorial View" selection:@"Tutorial View" input:@"null" pageNum:bookView.currentContentView.pageNum];
    [logWrapper addLogs:newlog];
    [LogDataParser saveLogData:logWrapper];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"See Tutorial"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(showTutorial)];
    self.navigationItem.rightBarButtonItem = leftButton;
    
    
    
    if(isTraining){
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Finish"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(finishTraining)];
        self.navigationItem.rightBarButtonItem = leftButton;
    }
    //[self.navigationItem setHidesBackButton:YES animated:YES];
    // [self.parentViewController.navigationController.navigationBar setHidden:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self // put here the view controller which has to be notified
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    
    //[self.navigationController setNavigationBarHidden:YES];
    // self.navigationController.navigationBar.translucent = NO;
    //self.parentViewController.navigationController.navigationBar.translucent = YES;
    // self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    // [ self.parentViewController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view from its nib.
    [self createMenuItems];
    [self createCmapView];
    [self createWebView];
    [self createSecondBookView];
    
    [self createQA];
    [self addSwitchView];
    bookView.parent_BookPageViewController=self;
    bookView.logWrapper=logWrapper;
    //[self splitScreen];
    if( ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft)||([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)){
        [self splitScreen];
    }
    upperBorder = [CALayer layer];
    [self.view bringSubviewToFront:cmapView.toolBar];
    [self.view bringSubviewToFront:previewImg];
    [self.view sendSubviewToBack:bookView.view];
    [self.view bringSubviewToFront:previewImg];
    NSString* isPreview=[[NSUserDefaults standardUserDefaults] stringForKey:@"isPreview"];
    
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if( (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)&&[isPreview isEqualToString:@"YES"]) //horizontal, split screen
    {
        [previewImg setHidden:YES];
        [PreviewRect setHidden:YES];
        
    }else{
        
        [previewImg setHidden:YES];
        [PreviewRect setHidden:YES];
        
    }
    
    //shang comment
    if([isPreview isEqualToString:@"NO"]){
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGesture.delegate=self;
        [previewImg addGestureRecognizer:panGesture];
        [previewImg setUserInteractionEnabled:YES];
        
        PreviewRect= [[UIView alloc] initWithFrame:CGRectMake(2,2,previewImg.frame.size.width-4,previewImg.frame.size.height-4)];
        PreviewRect.backgroundColor=[UIColor clearColor];
        PreviewRect.layer.borderColor = [UIColor redColor].CGColor;
        PreviewRect.tag=1;
        PreviewRect.layer.borderWidth = 1.0f;
        originalFrame=PreviewRect.frame;
        [previewImg addSubview:PreviewRect];
    }
    // [self splitScreen];
    
    if(isTraining){
        self.navigationItem.title=@"Training";
    }
    
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Application Loaded Succesfully" selection:@"Book Page View" input:@"null" pageNum:1];
    [logWrapper addLogs:newlog];
    [LogDataParser saveLogData:logWrapper];
    
    
    NSString* FBType=[[NSUserDefaults standardUserDefaults] stringForKey:@"FBTYPE"];
    if( ![FBType isEqualToString: FB_NO]){
        overlayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 3000, 3000)];
        overlayView.backgroundColor= [UIColor blackColor];
        overlayView.alpha=0.6;
        [self.view addSubview:overlayView];
        [overlayView setHidden:YES];
        expertModel= [[ExpertModel alloc]init];
        expertModel.bookLogDataWrapper=logWrapper;
        [expertModel setupKM];
        HLrectLeft=[[UIView alloc]initWithFrame:CGRectMake(100, 100, 80, 28)];
        HLrectLeft.layer.borderColor = [UIColor colorWithRed:255/255 green:90/255.0 blue:90/255.0 alpha:1].CGColor;
        HLrectLeft.layer.borderWidth = 3.0f;
        
        HLrectRight=[[UIView alloc]initWithFrame:CGRectMake(100, 100, 160, 28)];
        HLrectRight.layer.borderColor = [UIColor colorWithRed:255/255 green:90/255.0 blue:90/255.0 alpha:1].CGColor;
        HLrectRight.layer.borderWidth = 3.0f;
        [self.view addSubview:HLrectLeft];
        [self.view addSubview:HLrectRight];
    
    }
   
}//end of view did load


-(void)highlightKC: (NSString*)kcName{
    
    for(KeyConcept* kc in expertModel.keyConceptsAry){
        if ([kc.conceptName isEqualToString:kcName]){
            [self showLeftHLRect:kc];
            return;
        }
    }
    
}

-(void)showLeftHLRect: (KeyConcept*) kc{
    int RectWidth= (int)[kc.conceptName length]*8+10;
    [HLrectLeft setFrame: CGRectMake(HLrectLeft.frame.origin.x, HLrectLeft.frame.origin.y, RectWidth, HLrectLeft.frame.size.height)];
    
    if(HLrectLeft){
        [HLrectLeft setHidden:NO];
        HLrectLeft.center=kc.position;
        [self.view bringSubviewToFront:HLrectLeft];
    }
}

-(void)showRightHLRect:  (KeyConcept*) kc{
    int RectWidth= (int)[kc.conceptName length]*8+10 ;
    [HLrectRight setFrame: CGRectMake(HLrectRight.frame.origin.x, HLrectRight.frame.origin.y, RectWidth, HLrectRight.frame.size.height)];
    CGPoint rightPoint= CGPointMake(kc.position.x+515, kc.position.y);
    if(HLrectRight){
        [HLrectRight setHidden:NO];
        HLrectRight.center=rightPoint;
        [self.view bringSubviewToFront:HLrectRight];
    }
}


-(void)showOverlay{
    [overlayView setHidden:NO];
    [self.view bringSubviewToFront:overlayView];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"ring"  ofType:@"m4a"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    audioPlayer.numberOfLoops = 0; //Infinite
    [audioPlayer play];
}


-(void)hideOverlay{
    [overlayView setHidden:YES];
}

- (void)orientationChanged:(NSNotification *)notification{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //when retating the device, clear the thumbnail icons and reload
    if(orientation==UIInterfaceOrientationPortrait||orientation==UIInterfaceOrientationPortraitUpsideDown){
        //Vertical
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Changed to Vertical Orientation" selection:@"Book Page View" input:@"null" pageNum:bookView.currentContentView.pageNum];
        [logWrapper addLogs:newlog];
        [LogDataParser saveLogData:logWrapper];
        [self resumeNormalScreen ];
    }
    //otherwise, hide the concept map view.
    if(orientation==UIInterfaceOrientationLandscapeLeft||orientation==UIInterfaceOrientationLandscapeRight){
        //Horizontal
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Changed to Horizontal Orientation" selection:@"Book Page View" input:@"null" pageNum:bookView.currentContentView.pageNum];
        [logWrapper addLogs:newlog];
        [LogDataParser saveLogData:logWrapper];
        [self splitScreen];
    }
    //do stuff
    NSLog(@"Orientation changed");
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view bringSubviewToFront:previewImg];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation==UIInterfaceOrientationLandscapeLeft&&orientation==UIInterfaceOrientationLandscapeRight){
        [self splitScreen];
    }
}





-(void)viewDidAppear:(BOOL)animated{
    
    /*
    NSString* istest=[[NSUserDefaults standardUserDefaults] stringForKey:@"testMode"];
    if(![istest isEqualToString:@"YES"]){
        
        if(!isSecondShow){
            QuizViewController *quiz=[[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
            quiz.isFinished=false;
            quiz.userName=userName;
            quiz.bookLogDataWrapper=logWrapper;
            quiz.testType=0;//pre test
            quiz.parentBookPageViewController=self;
            [self.navigationController pushViewController:quiz animated:NO];
            isSecondShow=YES;
        }
        
    }
    */
    [self.view bringSubviewToFront:bulbImageView];
}


-(void)startTimer{
    //totalCountdownInterval=140;
    totalCountdownInterval=82;
    startDate = [NSDate date];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkTutorialCountdown:) userInfo:nil repeats:YES];
    });
    
}



-(void)startCmapTimer{
    totalCountdownInterval=1200;
    //totalCountdownInterval=2;
    startDate = [NSDate date];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Finish"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(showEndAlert)];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"See Tutorial"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(showTutorial)];
    self.navigationItem.leftBarButtonItem = leftButton;
    CmapTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCmapCountdown:) userInfo:nil repeats:YES];
    
    
}


-(void)showTutorial{
    VideoViewController *tutorial= [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
    tutorial.hideImg=YES;
    tutorial.bookTitle=bookView.bookTitle;
    tutorial.bookImporter=bookView.bookImporter;
    tutorial.logWrapper=logWrapper;
    ///[tutorial.teachImg removeFromSuperview];
    
    
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Go to tutorial view" selection:@"Tutorial View" input:@"null" pageNum:bookView.currentContentView.pageNum];
    [logWrapper addLogs:newlog];
    [LogDataParser saveLogData:logWrapper];
    
    
    
    [self.navigationController pushViewController:tutorial animated:NO];
}



-(void)showEndAlert{
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"attenping to finish concept mapping session" selection:@"concept map view" input:@"" pageNum:@"0"];
    [logWrapper addLogs:newlog];
    [LogDataParser saveLogData:logWrapper];
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    if( (int)elapsedTime<600   ){
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Deny finish concept map session due to insufficient time spent" selection:@"concept map view" input:@"" pageNum:@"0"];
        [logWrapper addLogs:newlog];
        [LogDataParser saveLogData:logWrapper];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Warning"
                              message:@"Please spend at least 10 minutes in this session"
                              delegate:self // <== changed from nil to self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
    }else{
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Warning"
                              message:@"Do you want to finish this session?"
                              delegate:self // <== changed from nil to self
                              cancelButtonTitle:@"NO"
                              otherButtonTitles:@"YES", nil];
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        // do something here...
    }
    if (buttonIndex == 1) {
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Student finish concept mapping view" selection:@"concept map view" input:@"" pageNum:@"0"];
        [logWrapper addLogs:newlog];
        [LogDataParser saveLogData:logWrapper];
        
        [cmapView uploadCmapCocneptAddedList];
        
        [self goToPostTest];
        // do something here...
    }
}

-(void)goToPostTest{
    
    [CmapTimer invalidate];
    [cmapView LogStudentMapNum];
    QuizViewController *quiz=[[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
    quiz.isFinished=false;
    quiz.parentBookPageViewController=self;
    quiz.testType=1; //post test
    quiz.userName=userName;
    quiz.bookLogDataWrapper=logWrapper;
    [self.navigationController pushViewController:quiz animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}


//Sets up the menu items that pop up
-(void) createMenuItems{
    //get the shared menubar.
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    //create a menu item
    CXAMenuItemSettings *markIconSettingSpeak = [CXAMenuItemSettings new];
    markIconSettingSpeak.image = [UIImage imageNamed:@"bb"];
    markIconSettingSpeak.shadowDisabled = NO;
    markIconSettingSpeak.shrinkWidth = 4; //set menu item size and picture.
    //set up the function called when user click the button
    UIMenuItem *speakItem = [[UIMenuItem alloc] initWithTitle: @"speak" action: @selector(dragAndDropConcept:)];
    [speakItem cxa_setSettings:markIconSettingSpeak];
    //add the menu item to the menubar.
    [menuController setMenuItems: [NSArray arrayWithObjects: speakItem, nil]];
}

//enables menu item buttons to perform action
-(BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(dragAndDropConcept:)){
        return YES;
    }
    return NO;
}

//Creates concept node from selections
-(void)dragAndDropConcept:(id)sender{
   // NSLog(@"dadc");
    NSString *selection = @"";
    NSString *charaterLimitString=@"These words are too long for a single node, try to summarize them!";
    BOOL isHyperLink = [[NSUserDefaults standardUserDefaults] boolForKey:@"HyperLinking"];
    if(0==subViewType){ //selection comes from content view controller
       // NSLog(@"Content View");
        selection = [self.bookView.currentContentView.webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"]; //selection is selected string in content view
        NSLog(@"Selection = %@", selection);
        if(selection.length>50){ //selection is too long
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:charaterLimitString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if([self.cmapView isNodeExist:selection]){ //selected string already exists
            NSString *msg=[[NSString alloc]initWithFormat:@"Node with name \"%@\" already exist!",selection];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self.cmapView createNodeFromBook:CGPointMake( arc4random() % 400+30, 690) withName:selection BookPos:CGPointMake(0, 0) page:self.bookView.currentContentView.pageNum];
        if(isHyperLink){//check if is group A
            [self.bookView.currentContentView saveHighlightToXML:@"#F2B36B" ];
            [self.bookView.currentContentView highlightStringWithColor:@"#F2B36B"];
            [self.cmapView highlightNode:selection];
        }
        
    }
    else if(1==subViewType){ //selection comes from web browser view controller
       // NSLog(@"Web browser");
        selection = [self.myWebView.webBrowserView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"]; //selection is selected string in web browser view
       // NSLog(@"Selection = %@", selection);
        if(selection.length>50){ //selection is too long
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:charaterLimitString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if([self.cmapView isNodeExist:selection]){ //selected string already exists
            NSString *msg=[[NSString alloc]initWithFormat:@"Node with name \"%@\" already exist!",selection];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self.cmapView createNodeFromBook:CGPointMake( arc4random() % 400+30, 690) withName:selection BookPos:CGPointMake(0, 0) page:0];
    }
    else{
        NSLog(@"Something has gone wrong in drag and drop concept");
    }
    
}


-(void)createSecondBookView{
    
    compareViewReturnButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [compareViewReturnButton dangerStyle];
    [compareViewReturnButton addTarget:self
               action:@selector(returnToCmapView)
     forControlEvents:UIControlEventTouchUpInside];
    [compareViewReturnButton setTitle:@"Back to concept map view" forState:UIControlStateNormal];
    compareViewReturnButton.frame = CGRectMake(380,700, 250, 50);
    compareViewReturnButton.alpha=0.85;
    [self.view addSubview:compareViewReturnButton];
    
    
    compareTitleButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [compareTitleButton primaryStyle];
    compareTitleButton.userInteractionEnabled=NO;
    [compareTitleButton setTitle:@"Please compare the highlighted concepts in both pages" forState:UIControlStateNormal];
    compareTitleButton.frame = CGRectMake(   [[UIScreen mainScreen] bounds].size.width/2-225 ,30, 450, 50);
    

    compareTitleButton.alpha=0.85;
    [self.view addSubview:compareTitleButton];
    
    
    secondBookView = [[BookViewController alloc]init];
    secondBookView.isSecondView=YES;
    secondBookView.userName=userName;
    secondBookView.parent_BookPageViewController=self;
    secondBookView.bookImporter = bookView.bookImporter;
    secondBookView.bookTitle = bookView.bookTitle;
    [ secondBookView createContentPages]; //create page content
    [ secondBookView initialPageView];    //initial page view
    //CGRect rect=CGRectMake(0, 0, bookPage.view.frame.size.height, bookPage.view.frame.size.width);
    //[destination.view setFrame:rect];
    CGRect rect=CGRectMake(530, 0, 511, 768);
    [secondBookView.view setFrame:rect];
    secondBookView.view.center=CGPointMake(768, 384);
    secondBookView.view.layer.borderColor = [UIColor grayColor].CGColor;
    secondBookView.view.layer.borderWidth = 3.0f;
    [self.view addSubview: secondBookView.view];
    [self addChildViewController: secondBookView];
    [secondBookView.view setHidden:YES];
    [compareViewReturnButton setHidden:YES];
    [compareTitleButton setHidden:YES];
}


-(void)showSecondBookView{
    [secondBookView.view setHidden:NO];
    [compareViewReturnButton setHidden:NO];
    [compareTitleButton setHidden:NO];
    [secondBookView showFirstPage:0];
    [self.view bringSubviewToFront:secondBookView .view];
    [self.view bringSubviewToFront:bookView.view];
    [self.view bringSubviewToFront:compareViewReturnButton];
    [self.view bringSubviewToFront:compareTitleButton];
    int currentPage=(int)[bookView getCurrentPage];

    
    if((expertModel.comparePageLeft != currentPage) && (expertModel.comparePageRight!=currentPage)){
        [bookView showFirstPage: expertModel.comparePageLeft];
        [secondBookView showFirstPage: expertModel.comparePageRight];
    }else if(expertModel.comparePageLeft == currentPage){
         [secondBookView showFirstPage: expertModel.comparePageRight];
    }else if(expertModel.comparePageRight == currentPage){
        [secondBookView showFirstPage: expertModel.comparePageLeft];
        KeyConcept* kc3=expertModel.kc1;
        expertModel.kc1=expertModel.kc2;
        expertModel.kc2=kc3;
    }
    if(expertModel.kc1){
        [self showLeftHLRect: expertModel.kc1];
    }
    if(expertModel.kc2){
        [self showRightHLRect: expertModel.kc2];
    }
    
    //KeyConcept* habitatDestruction= [[KeyConcept alloc]initWithVariable:@"habitat" Page:19 Subpage:1 Position: CGPointMake(65+530, 270)];
   // [self showRightHLRect:habitatDestruction.position];
    
    isInCompareView=YES;
}




-(void)returnToCmapView{
    [secondBookView.view setHidden:YES];
    [compareViewReturnButton setHidden:YES];
    [compareTitleButton setHidden:YES];
    [HLrectLeft setHidden:YES];
    [HLrectRight setHidden:YES];
    isInCompareView=NO;
}


-(void)HideHighlightRects{
    [HLrectLeft setHidden:YES];
    [HLrectRight setHidden:YES];
}

-(void)createCmapView{
    cmapView=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
    
    if(isTraining){
        cmapView.isTraining=YES;
    }
    cmapView.userName=userName;
    cmapView.bookLogDataWrapper=logWrapper;
    cmapView.bookLogDataWrapper.parentCmapController=cmapView;
    logWrapper.parentCmapController=cmapView;
    cmapView.showType=1;
    cmapView.enableHyperLink=enableHyperLink;
    cmapView.parentBookPageViewController=self;
    cmapView.neighbor_BookViewController=self.bookView;
    cmapView.pageNum=1;
    [self addChildViewController:cmapView];
    [self.view addSubview:cmapView.view];
    [cmapView.view setUserInteractionEnabled:YES];
    cmapView.view.center=CGPointMake(768, 384);
    [cmapView.view setHidden:YES];
    //cmapView.bookNodeWrapper 
}

-(void)createQA{
    QA=[[QAViewController alloc] initWithNibName:@"QAViewController" bundle:nil];
    [self addChildViewController:QA];
    [self.view addSubview:QA.view];
    [QA.view setUserInteractionEnabled:YES];
    QA.view.center=CGPointMake(768, 384);
    [QA.view setHidden:YES];
}

//creates our web browser view
-(void)createWebView{
    myWebView=[[WebBrowserViewController alloc] initWithNibName:@"WebBrowserViewController" bundle:nil];
    myWebView.parentBookPageViewCtr=self;
    [self addChildViewController:myWebView];
    [self.view addSubview:myWebView.view];
    [myWebView.view setUserInteractionEnabled:YES];
    //CGPoint decides where webview is showing, lookup screen resolution to ipad 2
    //if that doesn't work go to view didload in web browser.m
    //myWebView.view.center=CGPointMake(768, 384);
    myWebView.view.center=CGPointMake(256, 384);
    [myWebView.view setHidden:YES];
    myWebView.view.clipsToBounds = YES;
    
    //myWebView.view.layer.zPosition = 1;
    // [self.view bringSubviewToFront:myWebView.view];
}

-(void)webViewDidFinishLoad:(UIWebView *)m_webView{
    [bookView.loadContentView loadHghLight]; //This maintains and loads the highlights
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /*
     //when retating the device, clear the thumbnail icons and reload
     if(fromInterfaceOrientation==UIInterfaceOrientationPortrait||fromInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
     [self splitScreen];
     }
     //otherwise, hide the concept map view.
     if(fromInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||fromInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
     [self resumeNormalScreen ];
     }*/
}


//Screen splits when screen is rotated sideways. This is what happens when screen is split
-(void)splitScreen{
    CGRect rec=CGRectMake(0, 0, 512, 768);
    [bookView.view setFrame:rec];
    [cmapView.view setHidden:NO];
    //[myWebView.view setHidden:NO];
    [QA.view setHidden:NO];
    [bulbImageView setHidden:NO];
    LogFileController *logFile=[[LogFileController alloc]init];
    [logFile writeToTextFile:@"Show concept map view.\n" logTimeStampOrNot:YES];
    [self.view bringSubviewToFront:bulbImageView];
    
    
    NSString* isPreview=[[NSUserDefaults standardUserDefaults] stringForKey:@"isPreview"];
    if([isPreview isEqualToString:@"YES"]){
        [previewImg setHidden:NO];
        [self.view bringSubviewToFront: previewImg];
        
        previewImg.layer.shadowColor = [UIColor blackColor].CGColor;
        previewImg.layer.shadowOffset = CGSizeMake(2, 2);
        previewImg.layer.shadowOpacity = 0.75;
        previewImg.layer.shadowRadius = 5;
        previewImg.clipsToBounds = NO;
        
        previewImg.backgroundColor= [[UIColor whiteColor]colorWithAlphaComponent:0.3];
        previewImg.layer.borderColor = [UIColor grayColor].CGColor;
        previewImg.layer.borderWidth = 2.0f;
        
        [self.view.layer insertSublayer:upperBorder below:previewImg.layer];
        [previewImg becomeFirstResponder];
        isShowPreView=YES;
        
    }
}


-(void)resumeNormalScreen{
    CGRect rec=CGRectMake(0, 0, 768, 1024);
    [bookView.view setFrame:rec];
    [cmapView.view setHidden:YES];
    [QA.view setHidden:YES];
    [bulbImageView setHidden:YES];
    LogFileController *logFile=[[LogFileController alloc]init];
    [logFile writeToTextFile:@"Show book view.\n" logTimeStampOrNot:YES];
    [previewImg setHidden:YES];
    isShowPreView= NO;
    [upperBorder removeFromSuperlayer];
    
}

- (IBAction)pan:(UIPanGestureRecognizer *)gesture
{
    static CGPoint originalCenter;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        originalCenter = gesture.view.center;
        gesture.view.layer.shouldRasterize = YES;
    }
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [gesture translationInView:gesture.view.superview];
        gesture.view.center = CGPointMake(originalCenter.x + translate.x, originalCenter.y + translate.y);
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        upperBorder.position = CGPointMake(originalCenter.x + translate.x, originalCenter.y + translate.y);
        [CATransaction commit];
    }
    
    
}


-(void)hideAndShowPreView{
    if(YES==isShowPreView){
        [previewImg setHidden:YES];
        [upperBorder removeFromSuperlayer];
        isShowPreView=NO;
        
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Hide Preview" selection:@"Concept Map" input:@"null" pageNum: cmapView.pageNum];
        [logWrapper addLogs:newlog];
        [LogDataParser saveLogData:logWrapper];
        
        
    }else{
        [previewImg setHidden:NO];
        
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Show Preview" selection:@"Concept Map" input:@"null" pageNum: bookView.cmapView.pageNum];
        [logWrapper addLogs:newlog];
        [LogDataParser saveLogData:logWrapper];
        
        
        upperBorder.backgroundColor = [[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.7f]CGColor];
        upperBorder.frame=previewImg.frame;
        previewImg.layer.borderColor = [UIColor grayColor].CGColor;
        previewImg.layer.borderWidth = 2.0f;
        
        [self.view.layer insertSublayer:upperBorder below:previewImg.layer];
        
        //[previewImg becomeFirstResponder];
        [cmapView updatePreviewLocation];
        isShowPreView=YES;
        
    }
    
}

-(void)searchAndHighlight{
    
}


-(void)upLoadLogFile{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LogData.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSString *filename = @"LogData.xml";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
}


-(void)uploadCmapLink{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/ExpertCmapLinkList.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSString *text = content;
    NSString *filename = @"ExpertCmapLinkList.xml";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    
}

-(void)uploadCmapNode{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/ExpertCmapNodeList.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    NSString *text = content;
    NSString *filename = @"ExpertCmapNodeList.xml";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    
    
}

-(void)upLoadCmap{
    
    [self uploadCmapNode];
    [self uploadCmapLink];
}


- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}


- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}


/*
 -(void) checkCmapCountdown:(NSTimer*)_timer {
 
 NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
 remainTime = totalCountdownInterval - elapsedTime;
 int second=(int)remainTime;
 NSString *speedLabel = [[NSString alloc] initWithFormat:@"Time remaining %02d : %02d ", second/60, second%60];
 timerLable.text=speedLabel;
 self.navigationController.navigationBar.topItem.title=speedLabel;
 if(remainTime<=30){
 [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
 }
 
 if (remainTime <= 0.0) {
 [_timer invalidate];
 //[cmapView upLoad:nil];
 
 QuizViewController *quiz=[[QuizViewController alloc] initWithNibName:@"ViewController" bundle:nil];
 quiz.isFinished=false;
 quiz.parentBookPageViewController=self;
 quiz.testType=1;
 quiz.userName=userName;
 quiz.bookLogDataWrapper=logWrapper;
 [self.navigationController pushViewController:quiz animated:YES];
 
 /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time is up."
 message:@"Your data has been uploaded. Thank you for your participation!"
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 */
// [alert show];
// }
//}



-(void) checkCmapCountdown:(NSTimer*)_timer {
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    remainTime = totalCountdownInterval - elapsedTime;
    int second=(int)remainTime;
    NSString *speedLabel = [[NSString alloc] initWithFormat:@"Concept Mapping time remaining %02d : %02d ", second/60, second%60];
    timerLable.text=speedLabel;
    self.navigationController.navigationBar.topItem.title=speedLabel;
    if(remainTime<=30){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    }
    
    if (remainTime <= 0.0) {
        [_timer invalidate];
        //[cmapView upLoad:nil];
        
        //  [cmapView uploadCMapImg];//upload concetp map image
        
        [cmapView uploadCmapCocneptAddedList];
        
        [cmapView LogStudentMapNum];
        
        QuizViewController *quiz=[[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        quiz.isFinished=false;
        quiz.parentBookPageViewController=self;
        quiz.testType=1; //post test
        quiz.userName=userName;
        quiz.bookLogDataWrapper=logWrapper;
        [self.navigationController pushViewController:quiz animated:YES];
        
        /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time is up."
         message:@"Your data has been uploaded. Thank you for your participation!"
         delegate:self
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         */
        // [alert show];
    }
}




-(void) checkTutorialCountdown:(NSTimer*)_timer {
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    remainTime = totalCountdownInterval - elapsedTime;
    int second=(int)remainTime;
    NSString *speedLabel = [[NSString alloc] initWithFormat:@"Tutorial time remaining %02d : %02d ", second/60, second%60];
    timerLable.text=speedLabel;
    self.navigationController.navigationBar.topItem.title=speedLabel;
    if(remainTime<=30){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    }
    if (remainTime <= 0.0) {
        [_timer invalidate];
        NSLog(@"%@",self.navigationController.viewControllers);
        [self.navigationController popToViewController:self animated:false];
        
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Student start concept mapping" selection:@"concept map view" input:@"" pageNum:@"0"];
        [logWrapper addLogs:newlog];
        [LogDataParser saveLogData:logWrapper];
        [self splitScreen];
        [self startCmapTimer];
    }
}

/*
 - (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
 // the user clicked OK
 if (buttonIndex == 0) {
 [self.navigationController popToRootViewControllerAnimated:YES];
 }
 }*/


-(void)addConceptMapPreview:(NSMutableArray*)nodeArray Links: (NSMutableArray*)linkArray CMapFrame: (CGRect)frame{
    conceptNodeArray=[[NSMutableArray alloc] init];
    CGRect previewFrame=previewImg.frame;
    
    float xRatio=previewFrame.size.width/frame.size.width;
    float yRatio=previewFrame.size.height/frame.size.height;
    
    float sizeRatiox=cmapView.conceptMapView.frame.size.width/cmapView.conceptMapView.contentSize.width;
    float sizeRatioy=cmapView.conceptMapView.frame.size.height/cmapView.conceptMapView.contentSize.height;
    if(sizeRatiox>100){
        sizeRatiox=1;
    }
    if(sizeRatioy>100){
        sizeRatioy=1;
    }
    
    NSArray *viewsToRemove = [previewImg subviews];
    for (UIView *v in viewsToRemove) {
        if(1==v.tag){
            continue;
        }
        [v removeFromSuperview];
    }
    [PreviewRect removeFromSuperview];
    previewImg.layer.sublayers = nil;
    
    [PreviewRect setFrame:CGRectMake(originalFrame.origin.x*sizeRatiox+2, originalFrame.origin.y*sizeRatioy+2,  originalFrame.size.width*sizeRatiox-4, originalFrame.size.height*sizeRatioy-4)];
    
    [previewImg addSubview:PreviewRect];
    for(NodeCell* cell in nodeArray){
        NSString* str=cell.text.text;
        PreViewNode *pNode=[[PreViewNode alloc]initWithNibName:@"PreViewNode" bundle:nil];
        [pNode.view setFrame:CGRectMake(cell.showPoint.x*xRatio, cell.showPoint.y*yRatio,6, 6)];
        pNode.ParentPreView=previewImg;
        pNode.name=cell.text.text;
        //if the cell's page number = current page
        if(cell.pageNum+1==(bookView.loadContentView.pageNum)){
            NSLog (@"Activate");
            UIImage* orgImg =[UIImage imageNamed:@"orangeRec"]; //highlight node in preview
            orgImg=[self imageWithImage:orgImg scaledToSize:CGSizeMake(20, 20)];
            UIImageView *dot =[[UIImageView alloc]initWithImage:orgImg];
            [pNode.img setImage:orgImg];
        }
        
        [conceptNodeArray addObject:pNode];
        [previewImg addSubview:pNode.view];
    }
    
    for(ConceptLink* link in linkArray){
        
        PreViewNode* c1, *c2;
        
        for(PreViewNode* pNnode in conceptNodeArray){
            
            if([link.leftNode.text.text isEqualToString:pNnode.name]){
                c1=pNnode;
            }
            if([link.righttNode.text.text isEqualToString:pNnode.name]){
                c2=pNnode;
            }
        }
        [c1 createLink:c2 name:@"x"];
    }
    
}

-(void)updatePrevireRect{
    
}


-(void)addTutorial{
    VideoViewController *tutorial= [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
    tutorial.parentBookCtr=self;
    self.videoView=tutorial;
    [tutorial startTimer];
    [self.navigationController pushViewController:tutorial animated:NO];
    // [self startTimer];
}

-(void)showAdminPsdAlert{
    DTAlertView *alertView  = [DTAlertView alertViewWithTitle:@"Please Input Password!!" message:@"Password is \"1234567890\"" delegate:self cancelButtonTitle:@"Cancel" positiveButtonTitle:@"OK"];
    [alertView setAlertViewMode:DTAlertViewModeTextInput];
    [alertView setPositiveButtonEnable:NO];
    
    [alertView setTextFieldDidChangeBlock:^(DTAlertView *_alertView, NSString *text) {
        [_alertView setPositiveButtonEnable:(text.length >= 5)];
    }];
    
    [alertView showForPasswordInputWithAnimation:DTAlertViewAnimationDefault];
    
    // Set text field to secure text mode after show.
    [alertView.textField setSecureTextEntry:YES];
    
}

////////////////////functions for tutorial///////////////////////

-(void)showWebhint{
    webFocusQuestionLable = [[UILabel alloc] initWithFrame:CGRectMake(350, 55, 350, 33)];
    webFocusQuestionLable.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
    webFocusQuestionLable.text=@"Long press on the word you want to add";
    webFocusQuestionLable.alpha=0.8;
    webFocusQuestionLable.textAlignment = NSTextAlignmentCenter;
    webFocusQuestionLable.layer.shadowOpacity = 0.4;
    webFocusQuestionLable.layer.shadowRadius = 3;
    webFocusQuestionLable.layer.shadowColor = [UIColor blackColor].CGColor;
    webFocusQuestionLable.layer.shadowOffset = CGSizeMake(2, 2);
    [self.view addSubview:webFocusQuestionLable];
    UIImage *image = [UIImage imageNamed:@"hintbulb"];
    image=[self imageWithImage:image scaledToSize:CGSizeMake(26, 36)];
    
    hintImg = [[UIImageView alloc] initWithFrame:CGRectMake(310, 55, 28, 35)];
    [hintImg setImage:image];
    
    [self.view addSubview: hintImg];
}


-(void)showLinkingHint{
    UIImage *image = [UIImage imageNamed:@"Train_link"];
    image=[self imageWithImage:image scaledToSize:CGSizeMake(400, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showAlertWithString:@"Good job! Now link the concept you created with the node named link me": imageView];
    [ webFocusQuestionLable setFrame: CGRectMake(90, 35, 430, 50)];
    webFocusQuestionLable.text=@"Long click on a concept and drag to the linking option. When the node is blinking, click on the node you want to link it with.";
    webFocusQuestionLable.font=[webFocusQuestionLable.font fontWithSize:14];
    webFocusQuestionLable.lineBreakMode = NSLineBreakByWordWrapping;
    webFocusQuestionLable.numberOfLines = 0;
    webFocusQuestionLable.center=CGPointMake(780, 73);
    hintImg.center=CGPointMake(530, 75);
}

-(void)showLinkingWarning{
    webFocusQuestionLable = [[UILabel alloc] initWithFrame:CGRectMake(350, 55, 350, 33)];
    webFocusQuestionLable.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
    webFocusQuestionLable.alpha=0.8;
    webFocusQuestionLable.textAlignment = NSTextAlignmentCenter;
    webFocusQuestionLable.layer.shadowOpacity = 0.4;
    webFocusQuestionLable.layer.shadowRadius = 3;
    webFocusQuestionLable.layer.shadowColor = [UIColor blackColor].CGColor;
    webFocusQuestionLable.layer.shadowOffset = CGSizeMake(2, 2);
    UIImage *image = [UIImage imageNamed:@"Train_link"];
    image=[self imageWithImage:image scaledToSize:CGSizeMake(400, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [ webFocusQuestionLable setFrame: CGRectMake(90, 35, 430, 50)];
    webFocusQuestionLable.text=@"Click on the node you want to link with. Click on the node itself to cancel linking";
    webFocusQuestionLable.font=[webFocusQuestionLable.font fontWithSize:14];
    webFocusQuestionLable.lineBreakMode = NSLineBreakByWordWrapping;
    webFocusQuestionLable.numberOfLines = 0;
    webFocusQuestionLable.center=CGPointMake(780, 73);
    hintImg.center=CGPointMake(530, 75);
    [self.view addSubview:webFocusQuestionLable];
    [self.view addSubview: hintImg];
    //[webFocusQuestionLable setHidden:NO];
    //[hintImg setHidden:NO];
}



-(void)hideLinkingWarning{
    [webFocusQuestionLable removeFromSuperview];
    [hintImg removeFromSuperview];
    //[webFocusQuestionLable setHidden:YES];
    //[hintImg setHidden:YES];
}


-(void)showExpertHighlightWarning{
    webFocusQuestionLable = [[UILabel alloc] initWithFrame:CGRectMake(350, 55, 350, 50)];
    webFocusQuestionLable.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
    webFocusQuestionLable.textAlignment = NSTextAlignmentCenter;
    webFocusQuestionLable.layer.shadowOpacity = 0.4;
    webFocusQuestionLable.layer.shadowRadius = 3;
    webFocusQuestionLable.layer.shadowColor = [UIColor blackColor].CGColor;
    webFocusQuestionLable.layer.shadowOffset = CGSizeMake(2, 2);
    UIImage *image = [UIImage imageNamed:@"Train_link"];
    image=[self imageWithImage:image scaledToSize:CGSizeMake(400, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [ webFocusQuestionLable setFrame: CGRectMake(90, 35, 430, 75)];
    webFocusQuestionLable.text=@"I highlighted the template nodes that needs to be expanded. Try to see if you can connect or expanded these nodes!";
    webFocusQuestionLable.font=[webFocusQuestionLable.font fontWithSize:14];
    webFocusQuestionLable.lineBreakMode = NSLineBreakByWordWrapping;
    webFocusQuestionLable.numberOfLines = 0;
    webFocusQuestionLable.center=CGPointMake(500, 50);
    hintImg.center=CGPointMake(530, 75);
    [self.view addSubview:webFocusQuestionLable];
    //[self.view addSubview: hintImg];
    [self startTHintTimer];
}


-(void)startTHintTimer{
  NSTimer*  hintTimer = [NSTimer scheduledTimerWithTimeInterval: 6
                                                           target: self
                                                         selector:@selector(disMissHint:)
                                                         userInfo: nil repeats:NO];
}
-(void)disMissHint:(NSTimer *)timer {
    [webFocusQuestionLable removeFromSuperview];
    [hintImg removeFromSuperview];
}







-(void)showFlipPageHint{
    UIImage *image = [UIImage imageNamed:@"Train_pageflip"];
    image=[self imageWithImage:image scaledToSize:CGSizeMake(250, 250)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.cmapView.isNavigateTraining=YES;
    [self showAlertWithString:@"Good job! Now try to go to next page":imageView];
    [webFocusQuestionLable setFrame: CGRectMake(90, 35, 430, 50)];
    webFocusQuestionLable.text=@"Drag a page to the left to go to next page.";
    webFocusQuestionLable.font=[webFocusQuestionLable.font fontWithSize:14];
    webFocusQuestionLable.lineBreakMode = NSLineBreakByWordWrapping;
    webFocusQuestionLable.numberOfLines = 0;
    webFocusQuestionLable.center=CGPointMake(580, 73);
    hintImg.center=CGPointMake(330, 75);
    
    NSString *savedPage=[[NSString alloc]initWithFormat:@"%d",bookView.currentContentView.pageNum];
    [[NSUserDefaults standardUserDefaults] setObject:savedPage forKey:@"savedPage"];
    cmapView.isAddNodeTraining=NO;
    
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)showAlertWithString: (NSString*) str : (UIView*)imgView{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"To do"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    //UIImage *image = [UIImage imageNamed:@"Train_AddNode"];
    //image=[self imageWithImage:image scaledToSize:CGSizeMake(300, 200)];
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    [alert setValue:imgView forKey:@"accessoryView"];
    [alert show];
    
}


-(void)showAlertWithText: (NSString*) str {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

-(void)createDeleteTraining{
    for (NodeCell *cell in cmapView.conceptNodeArray)
    {
        [cell removeLink];
        [cell.view removeFromSuperview];
    }
    
    [cmapView.conceptNodeArray removeAllObjects];
    [cmapView.conceptLinkArray removeAllObjects];
    NodeCell* cell= [cmapView createNodeFromBookForLink:CGPointMake( 250, 300) withName:@"delete me" BookPos:CGPointMake(0, 0) page:1];
    cell.text.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
    webFocusQuestionLable.text=@"Long click on a concept and drag to the delete option.";
}

//Displays webview and sets related node
-(void)showWebView: (NSString*)conceptName atNode:(NodeCell *)relatedNode  {
    [myWebView.view setHidden:NO];
    subViewType=1;
    [myWebView SearchKeyWord:conceptName];
    [myWebView setRelatedNode:relatedNode];
   // [previewImg setHidden:YES];
    [self.view bringSubviewToFront:myWebView.view];
}
//hides webview
-(void)hideWebView{
    subViewType=0;
    [myWebView.view setHidden:YES];
    //[previewImg setHidden:NO];
    [self.view sendSubviewToBack:myWebView.view];
}


-(void)showLinkNameFinder{
    linkNameFinder=[[MapFinderViewController alloc]initWithNibName:@"MapFinderViewController" bundle:nil];
    linkNameFinder.parentCmapController=cmapView;
    [linkNameFinder.tableView setUserInteractionEnabled:YES];
    [linkNameFinder becomeFirstResponder];
    linkNameFinder.bookLogData=logWrapper;
    [self.view addSubview:linkNameFinder.view];
    [self addChildViewController:linkNameFinder];
}

@end
