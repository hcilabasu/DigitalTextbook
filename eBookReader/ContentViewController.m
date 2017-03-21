//
//  ContentViewController.m
//  eBookReader
//
//  Created by Shang Wang on 3/19/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "ContentViewController.h"
#import "UIMenuItem+CXAImageSupport.h"
#import "OCDaysView.h"
#import "WebBrowserViewController.h"
#import "NoteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BookViewController.h"
#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "GDataXMLNode.h"
#import "HighLight.h"
#import "ThumbNailIcon.h"
#import "ThumbNailIconParser.h"
#import "ThumbNailIconWrapper.h"
#import "LSHorizontalScrollTabViewDemoViewController.h"
#import "SampleViewController.h"
#import "ZYQSphereView.h"
#import "AWCollectionViewDialLayout.h"
#import "BookPageViewController.h"
#import "LogFileController.h"
#import "PopoverView.h"
#import "NodeViewController.h"
#import "SubNodeViewController.h"
#import "CmapBookNoteViewController.h"
#import "BookPageViewController.h"
//#import <KIF/KIF.h>
//#import "TouchSynthesis.h"
// for the "quick help" feature, we haven't decided what interaction we want to add after user clicks the button so we define this array to display some default word.
#define kStringArray [NSArray arrayWithObjects:@"YES", @"NO",@"Wiki",@"Google",@"Concept Map", nil]
#define H_CONTROL_ORIGIN CGPointMake(200, 300)

@interface ContentViewController ()
@end

static NSString *cellId = @"cellId";
static NSString *cellId2 = @"cellId2";

@implementation ContentViewController{
    NSMutableDictionary *thumbnailCache;
    BOOL showingSettings;
    UIView *settingsView;
    UILabel *radiusLabel;
    UISlider *radiusSlider;
    UILabel *angularSpacingLabel;
    UISlider *angularSpacingSlider;
    UILabel *xOffsetLabel;
    UISlider *xOffsetSlider;
    UISegmentedControl *exampleSwitch;
    AWCollectionViewDialLayout *dialLayout;
    
    int type;
}
@synthesize webView;
@synthesize isMenuShow;
@synthesize pageNum;
@synthesize totalpageNum;
@synthesize parent_BookViewController;
@synthesize highlightTextArray;
@synthesize knowledge_module;
@synthesize thumbNailController;
@synthesize logFileController;
@synthesize bookHighLight;
@synthesize bookthumbNailIcon;
@synthesize bookTitle;
@synthesize ThumbScrollViewLeft;
@synthesize lmGenerator;
@synthesize syn;
@synthesize CmapStart;
@synthesize bulbImageView;
@synthesize conceptNamesArray;
@synthesize linkCollectionView;
@synthesize linkItems;
@synthesize isCollectionShow;
@synthesize ThumbScrollViewRight;
@synthesize isleftThumbShow;
@synthesize firstRespondConcpet;
@synthesize isSplit;
@synthesize bookLogData;
@synthesize overLayCmapView;
@synthesize showingOverLayCmap;
@synthesize userName;
@synthesize totalCountdownInterval;
@synthesize remainTime;
@synthesize startDate;
@synthesize timerLable;



-(void)viewDidAppear:(BOOL)animated{
    //[self refresh];
    [self.currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageNum, totalpageNum]];
    //[self loadThumbNailIcon];

    
    [self loadThumbNailIcon:firstRespondConcpet];
    
    if( ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft)||([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)){
        //[ThumbScrollViewRight setHidden:YES];
        [self hideAllSubview:ThumbScrollViewRight];
        isSplit=YES;
        //when loading, at least
    }
    
    [parent_BookViewController clearAllHighlightNode];
    [parent_BookViewController searchAndHighlightNode];
    [parent_BookViewController searchAndHighlightLink];
    [parent_BookViewController.parent_BookPageViewController.cmapView getPreView:nil];
    [parent_BookViewController.parent_BookPageViewController.cmapView updatePreviewLocation];
    
    [webView setFrame:self.view.frame];
    [webView becomeFirstResponder];
    
    parent_BookViewController.parent_BookPageViewController.cmapView.parent_ContentViewController=self;
    parent_BookViewController.currentContentView=self;
    
    NSString* logStr=[[NSString alloc] initWithFormat:@"Turned tos page: %d", index+1];
    LogData* log= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:logStr selection:@"Textbook" input:@"null" pageNum:index];
    [bookLogData addLogs:log];
    [LogDataParser saveLogData:bookLogData];
   // [self.parentViewController.navigationController setNavigationBarHidden: YES animated:YES];
    //[self.navigationController setNavigationBarHidden: YES animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [webView setFrame:self.view.frame];
    
    [ThumbScrollViewRight setHidden:YES];
     startDate = [NSDate date];
    //[webView setDelegate:self];
    [webView setDelegate:parent_BookViewController.parent_BookPageViewController];
    [linkCollectionView setDataSource:self];
    [linkCollectionView setDelegate:self];
    linkCollectionView.backgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    [linkCollectionView setHidden:YES];
    conceptNamesArray=[[NSMutableArray alloc] init];
    isCollectionShow=NO;
    //disable the bounce animation in the webview
    UIScrollView* sv = [webView scrollView];
    [sv setShowsHorizontalScrollIndicator:NO];
    [sv setShowsVerticalScrollIndicator:NO];
    sv.scrollEnabled=NO;
    sv.delegate=self;
    isMenuShow=NO;
    syn=[[AVSpeechSynthesizer alloc]init];
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerOneTaps:)];
    [twoTap setNumberOfTapsRequired:2];
    twoTap.delegate=self;
    NSString* isPreview=[[NSUserDefaults standardUserDefaults] stringForKey:@"isPreview"];
    if([isPreview isEqualToString:@"YES"]){
    [webView addGestureRecognizer:twoTap];
    }
    UITapGestureRecognizer *onetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updatePVPosition:)];
    [onetap setNumberOfTapsRequired:1];
    onetap.delegate=self;
    [webView addGestureRecognizer:onetap];
     
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    longpress.delegate=self;
    [webView addGestureRecognizer:longpress];

    
    
    webView.scrollView.tag=0;
    NSString* previewBtn=[[NSUserDefaults standardUserDefaults] stringForKey:@"isPreview"];
    if([previewBtn isEqualToString:@"YES"]){
        self.currentPageLabel.center=CGPointMake(self.currentPageLabel.center.x, self.currentPageLabel.center.y+50);
    }

    /*
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    [doubleTap setNumberOfTapsRequired:2];
    doubleTap.delegate=self;
    [webView addGestureRecognizer:doubleTap];
     */
    //set up menu items, icons and methods
   // [self setingUpMenuItem];
   
    //specify the javascript file path
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"JavaScriptFunctions" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"Javascript file path null!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    // [webView loadHTMLString:_dataObject baseURL:_url];
    thumbNailController= [[ThumbNailController alloc]
                          initWithNibName:@"ThumbNailController" bundle:nil];
    logFileController= [[LogFileController alloc]
                        initWithNibName:@"LogFileController" bundle:nil];
    //load page highlights
    
    [webView loadHTMLString:_dataObject baseURL:_url];
   // [self refresh];
    
    ThumbScrollViewLeft.showsHorizontalScrollIndicator=NO;
    ThumbScrollViewLeft.showsVerticalScrollIndicator=NO;
    ThumbScrollViewLeft.pagingEnabled=YES;
    ThumbScrollViewLeft.delegate=self;
    ThumbScrollViewLeft.contentSize = CGSizeMake(40, self.view.frame.size.height*2);
    ThumbScrollViewLeft.tag=1;
    ThumbScrollViewLeft.scrollEnabled=NO;
    ThumbScrollViewRight.contentSize = CGSizeMake(80, self.view.frame.size.height-50);
    //[self.currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageNum, totalpageNum]];
    //[self loadThumbNailIcon];
    // [self loadThumbNailIcon:firstRespondConcpet];
    
    //  UIBarButtonItem *conceptButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    // self.parentViewController. navigationItem.rightBarButtonItem=conceptButton;
    UIImage* image3 = [UIImage imageNamed:@"idea"];

    
    
    CGRect frameimg = CGRectMake(0, 0, 40, 40);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(ConceptCloud:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.parent_BookViewController.navigationItem.rightBarButtonItem=mailbutton;
    /*
     if( ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft)||([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)){
     //[ThumbScrollViewRight setHidden:YES];
     [self hideAllSubview:ThumbScrollViewRight];
     isSplit=YES;
     }
     */
    // [parent_BookViewController clearAllHighlightNode];
    //// [parent_BookViewController searchAndHighlightNode];
    // [parent_BookViewController searchAndHighlightLink];
   /*
    CmapBookNoteViewController *cmapNote=[[CmapBookNoteViewController alloc] initWithNibName:@"CmapBookNoteViewController" bundle:nil];
    cmapNote.view.frame = CGRectMake(230, 341, 55, 20);
    [self.view addSubview:cmapNote.view];
    [self addChildViewController:cmapNote];
    cmapNote.parentContentView=self;
    */
    /////set up overlay Cmap view
   // overLayCmapView=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
    //overLayCmapView.bookLogDataWrapper=logWrapper;
    //overLayCmapView.showType=1;
    //overLayCmapView.neighbor_BookViewController=self.bookView;
   // [self addChildViewController:overLayCmapView];
    //[self.view addSubview:overLayCmapView.view];
    [overLayCmapView.view setUserInteractionEnabled:NO];
    overLayCmapView.view.center=CGPointMake(384, 384);
    overLayCmapView.view.backgroundColor= [UIColor clearColor];
    overLayCmapView.view.layer.borderWidth = 0;
    [overLayCmapView.toolBar removeFromSuperview];
    [overLayCmapView.bulbImageView removeFromSuperview];
    [overLayCmapView.focusQuestionLable removeFromSuperview];
    [overLayCmapView.view setHidden:YES];
    //[overLayCmapView.view setHidden:YES];
    // [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
    // [self.navigationController setNavigationBarHidden: NO animated:YES];
    [self.webView becomeFirstResponder];
    

    NSString *str=[[NSString alloc]initWithFormat:@"Page %d did load.",pageNum];
    NSLog(str);
    //[self performTouchInView:webView];
    

}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//after the webview loads page, load highlight content
-(void)webViewDidFinishLoad:(UIWebView *)m_webView{
    [self loadHghLight];
    [parent_BookViewController.parent_BookPageViewController.cmapView updatePreviewLocation];
    [webView becomeFirstResponder];
    NSString* istest=[[NSUserDefaults standardUserDefaults] stringForKey:@"isHyperLinking"];
    BOOL ishyperlinking;
    if([istest isEqualToString:@"YES"]){
        ishyperlinking=YES;
    }
    
    NSString* savedPageString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedPage"];
    int PagetoGo=[savedPageString intValue]+1;
    
    if(parent_BookViewController.parent_BookPageViewController.cmapView.isNavigateTraining&&pageNum==PagetoGo&&ishyperlinking){
        
        UIImage *image = [UIImage imageNamed:@"Train_HyperNavi"];
        image=[self imageWithImage:image scaledToSize:CGSizeMake(300, 200)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [parent_BookViewController.parent_BookPageViewController showAlertWithString:@"Good job! Now you can click on the node to go to where the node is created":imageView];
        parent_BookViewController.parent_BookPageViewController.cmapView.isHyperlinkTraining=YES;
    }else if(parent_BookViewController.parent_BookPageViewController.cmapView.isNavigateTraining&&pageNum==PagetoGo){
        [parent_BookViewController.parent_BookPageViewController showLinkingHint];
        NodeCell* cell= [parent_BookViewController.parent_BookPageViewController.cmapView createNodeFromBookForLink:CGPointMake( 250, 300) withName:@"link me" BookPos:CGPointMake(0, 0) page:1];
        cell.text.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
        parent_BookViewController.parent_BookPageViewController.cmapView.isNavigateTraining=NO;

    }
    
    if( ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft)||([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)){
        CGRect rec=CGRectMake(0, webView.frame.origin.y, 512, 768);
        [webView setFrame:rec];
        
       // NSString *jsString2 = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",96];
       // [webView stringByEvaluatingJavaScriptFromString:jsString2];
    }else{
        //NSString *jsString2 = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",118];
  //  NSString *jsString2 = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",96];
    //[webView stringByEvaluatingJavaScriptFromString:jsString2];
    }
    
   // [self settingUpParentMenu];

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


//refresh the book page
-(void) refresh{
    [webView loadHTMLString:_dataObject baseURL:_url];
    [self.currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageNum, totalpageNum]];
}



//Sets up the menu items that pop up
-(void) setingUpMenuItem{ //set the menu items in the content view
    // use notification to check if the menu is showing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowEditMenu:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowEditMenu:) name:UIMenuControllerDidShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideEditMenu:) name:UIMenuControllerDidHideMenuNotification object:nil];
    
    // Menu Controller, controls the manu list which will pop up when the user click a selected word or string
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    //add menu items to the menu list
    CXAMenuItemSettings *markIconSettingSpeak = [CXAMenuItemSettings new];
    markIconSettingSpeak.image = [UIImage imageNamed:@"speak"];
    markIconSettingSpeak.shadowDisabled = NO;
    markIconSettingSpeak.shrinkWidth = 4; //set menu item size and picture.
    
    CXAMenuItemSettings *markIconSettingsPopUp = [CXAMenuItemSettings new];
    markIconSettingsPopUp.image = [UIImage imageNamed:@"bb"];
    markIconSettingsPopUp.shadowDisabled = NO;
    markIconSettingsPopUp.shrinkWidth = 4; //set menu item size and picture.
    
    CXAMenuItemSettings *markIconSettingsConcpet = [CXAMenuItemSettings new];
    markIconSettingsConcpet.image = [UIImage imageNamed:@"bb"];
    NSString* isPreviewShow=[[NSUserDefaults standardUserDefaults] stringForKey:@"isPreview"];
    if([isPreviewShow isEqualToString:@"YES"]){
        //markIconSettingsConcpet.image = [UIImage imageNamed:@"CmapIcon"];
    }
    
    
    markIconSettingsConcpet.shadowDisabled = NO;
    markIconSettingsConcpet.shrinkWidth = 4; //set menu item size and picture
    
    CXAMenuItemSettings *markIconSettingsYelow = [CXAMenuItemSettings new];
    markIconSettingsYelow.image = [UIImage imageNamed:@"highlight_yellow"];
    markIconSettingsYelow.shadowDisabled = NO;
    markIconSettingsYelow.shrinkWidth = 4; //set menu item size and picture.
    
    /*
     CXAMenuItemSettings *markIconSettingsGreeen = [CXAMenuItemSettings new];
     markIconSettingsGreeen.image = [UIImage imageNamed:@"highlight_green"];
     markIconSettingsGreeen.shadowDisabled = NO;
     markIconSettingsGreeen.shrinkWidth = 4; //set menu item size and picture.
     
     CXAMenuItemSettings *markIconSettingsBlue = [CXAMenuItemSettings new];
     markIconSettingsBlue.image = [UIImage imageNamed:@"highlight_blue"];
     markIconSettingsBlue.shadowDisabled = NO;
     markIconSettingsBlue.shrinkWidth = 4; //set menu item size and picture.
     
     CXAMenuItemSettings *markIconSettingsPurple = [CXAMenuItemSettings new];
     markIconSettingsPurple.image = [UIImage imageNamed:@"highlight_purple"];
     markIconSettingsPurple.shadowDisabled = NO;
     markIconSettingsPurple.shrinkWidth = 4; //set menu item size and picture.
     
     CXAMenuItemSettings *markIconSettingsRed = [CXAMenuItemSettings new];
     markIconSettingsRed.image = [UIImage imageNamed:@"highlight_red"];
     markIconSettingsRed.shadowDisabled = NO;
     markIconSettingsRed.shrinkWidth = 4; //set menu item size and picture.
     
     
     CXAMenuItemSettings *underLineSet = [CXAMenuItemSettings new];
     underLineSet.image = [UIImage imageNamed:@"underline2"];
     underLineSet.shadowDisabled = NO;
     underLineSet.shrinkWidth = 4; //set menu item size and picture.
     
     CXAMenuItemSettings *undoSet = [CXAMenuItemSettings new];
     undoSet.image = [UIImage imageNamed:@"undo"];
     undoSet.shadowDisabled = NO;
     undoSet.shrinkWidth = 4; //set menu item size and picture.
     */

    CXAMenuItemSettings *takeNoteSetting = [CXAMenuItemSettings new];
    takeNoteSetting.image = [UIImage imageNamed:@"take_note"];
    takeNoteSetting.shadowDisabled = NO;
    takeNoteSetting.shrinkWidth = 4; //set menu item size and picture.
    
    
    UIMenuItem *getHighlightString = [[UIMenuItem alloc] initWithTitle: @"Pop" action: @selector(popUp:)];
    [getHighlightString cxa_setSettings:markIconSettingsPopUp];
    
    UIMenuItem *concept = [[UIMenuItem alloc] initWithTitle: @"concept" action: @selector(dragAndDrop:)];
    [concept cxa_setSettings:markIconSettingsConcpet];
    
    UIMenuItem *markHighlightedStringYellow = [[UIMenuItem alloc] initWithTitle: @"mark yellow" action: @selector(markHighlightedStringInYellow:)];
    [markHighlightedStringYellow cxa_setSettings:markIconSettingsYelow];
    /*
     UIMenuItem *markHighlightedStringGreen = [[UIMenuItem alloc] initWithTitle: @"mark green" action: @selector(markHighlightedStringInGreen:)];
     [markHighlightedStringGreen cxa_setSettings:markIconSettingsGreeen];
     
     UIMenuItem *markHighlightedStringBlue = [[UIMenuItem alloc] initWithTitle: @"mark blue" action: @selector(markHighlightedStringInBlue:)];
     [markHighlightedStringBlue cxa_setSettings:markIconSettingsBlue];
     
     UIMenuItem *markHighlightedStringPurple = [[UIMenuItem alloc] initWithTitle: @"mark purple" action: @selector(markHighlightedStringInPurple:)];
     [markHighlightedStringPurple cxa_setSettings:markIconSettingsPurple];
     
     UIMenuItem *markHighlightedStringRed = [[UIMenuItem alloc] initWithTitle: @"mark red" action: @selector(markHighlightedStringInRed:)];
     [markHighlightedStringRed cxa_setSettings:markIconSettingsRed];
     
     UIMenuItem *underLineItem = [[UIMenuItem alloc] initWithTitle: @"underline" action: @selector(underLine:)];
     [underLineItem cxa_setSettings:underLineSet];
     
     UIMenuItem *undoItem = [[UIMenuItem alloc] initWithTitle: @"undo" action: @selector(removeFormat:)];
     [undoItem cxa_setSettings:undoSet];
     */
    UIMenuItem *takeNoteItem = [[UIMenuItem alloc] initWithTitle: @"take note" action: @selector(takeNote:)];
    [takeNoteItem cxa_setSettings:takeNoteSetting];
    
    UIMenuItem *speakItem = [[UIMenuItem alloc] initWithTitle: @"speak" action: @selector(speak:)];
    [speakItem cxa_setSettings:markIconSettingSpeak];
    
    
    [menuController setMenuItems: [NSArray arrayWithObjects: concept, nil]];
}


- (IBAction)ConceptCloud : (id)sender
{
    /*
    SampleViewController* conceptCloud= [[SampleViewController alloc]init];
    conceptCloud.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"blurWallPaper"] ];
    [self.navigationController pushViewController:conceptCloud animated:YES];
    [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
    self.parentViewController.navigationController.navigationBar.translucent = YES;
     */
}

- (IBAction)goToQuiz : (id)sender
{
    QuizViewController *quiz=[[QuizViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    quiz.isFinished=false;
    [self.navigationController pushViewController:quiz animated:YES];
}

- (void)updatePVPosition:(UITapGestureRecognizer *)tap
{
    // [self becomeFirstResponder];
    pvPoint = [tap locationInView:self.view];
  
}


- (void)longpressAction:(UITapGestureRecognizer *)tap
{
     NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
      pvPoint = [tap locationInView:self.view];
     [self becomeFirstResponder];
   // UIMenuController *menuController = [UIMenuController sharedMenuController];
   // [menuController setMenuVisible:YES animated:YES];
   
  
    
}

// invoke when user tap with one finger once
- (void)oneFingerOneTaps:(UITapGestureRecognizer *)tap
{
    [self becomeFirstResponder];
    // [self becomeFirstResponder];
    pvPoint = [tap locationInView:self.view];//track the last click position in order to show the popUp view
    
    if(!isMenuShow){  //is the menu bar is showing, disable the gesture action
        //set navigation bar animation, which uses the QuartzCore framework.
        self.parentViewController.navigationController.navigationBar.translucent = YES;
        [ self.parentViewController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        CATransition *navigationBarAnimation = [CATransition animation];
        navigationBarAnimation.duration = 0.6;
        navigationBarAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        navigationBarAnimation.type = kCATransitionMoveIn;
        navigationBarAnimation.subtype = kCATransitionFromBottom;
        navigationBarAnimation.removedOnCompletion = YES;
        [self.parentViewController.navigationController.navigationBar.layer addAnimation:navigationBarAnimation forKey:nil];
        //click with one finger to show or hind the navigaion bar.
        BOOL navBarState = [self.parentViewController.navigationController isNavigationBarHidden];
        if(!navBarState ){
            [self.parentViewController.navigationController setNavigationBarHidden: YES animated:YES];
        }else {
            [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
        }
    }else{
        [self.parentViewController.navigationController setNavigationBarHidden: YES animated:YES];
    }
     
    
}

//invoke when user double tap with one finger
- (void)doubleTapped:(UITapGestureRecognizer *)tap
{
    pvPoint = [tap locationInView:self.view];
    pv = [PopoverView showPopoverAtPoint:pvPoint
                                  inView:self.view
                               withTitle:@"Need help?"
                         withStringArray:kStringArray
                                delegate:self];
}

//invoke when user select one item in the PopOver menu.
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s item:%d", __PRETTY_FUNCTION__, index);
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    
    // Figure out which string was selected, store in "string"
    NSString *string = [kStringArray objectAtIndex:index];
    // Show a success image, with the string from the array
    if(0==index){
        NSString* h_text=[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
        [self createConceptIcon:pvPoint NoteText:h_text isWriteToFile:YES];
        //firstRespondConcpet=h_text;
    }else if(1==index){
        [popoverView showImage:[UIImage imageNamed:@"error"] withMessage:string];
    }else if(2==index){
        NSString *wikiLink=@"http://en.wikipedia.org/wiki/";
        wikiLink=[wikiLink stringByAppendingString:selection];
        wikiLink= [wikiLink stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSURL *url = [NSURL URLWithString:wikiLink];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        //create a new UIwebview to display the wiki page
        WebBrowserViewController *webBroser= [[WebBrowserViewController alloc]
                                              initWithNibName:@"WebBrowserViewController" bundle:nil];
        webBroser.isNew=YES;
        webBroser.requestObj=requestObj;
        webBroser.parent_View_Controller=self;
        webBroser.pvPoint=pvPoint;
        //push the controller to the navigation bar
        [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationController pushViewController:webBroser animated:YES];
    }else if (3==index){
        NSString *googleLink=@"https://www.google.com/search?q=";
        googleLink=[googleLink stringByAppendingString:selection];
        //replace the " " character in the url with "%20" in order to connect the seperate words for search
        googleLink= [googleLink stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"Url Link afterf replacing %@",googleLink);
        NSURL *url = [NSURL URLWithString:googleLink];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        WebBrowserViewController *webBroser= [[WebBrowserViewController alloc]
                                              initWithNibName:@"WebBrowserViewController" bundle:nil];
        webBroser.parent_View_Controller=self;
        webBroser.requestObj=requestObj;
        webBroser.pvPoint=pvPoint;
        [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationController pushViewController:webBroser animated:YES];
    }
    else if (4==index){//starting concetp map
        CmapController *cmapView2=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
        cmapView2.dataObject=_dataObject;
        cmapView2.url=_url;
        cmapView2.showType=0;
        cmapView2.bookHighlight=bookHighLight;
        cmapView2.bookThumbNial=bookthumbNailIcon;
        cmapView2.bookTitle=bookTitle;
        cmapView2.parent_ContentViewController=self;
        [self.navigationController pushViewController:cmapView2 animated:YES];
    }
    // Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}


//Need to add this function to enable web view to recognize gesture.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}


//give permission to show the menu item we added
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(markHighlightedString:)
        ||action == @selector(dragAndDrop:)
        ||action == @selector(popUp:)
        ||action == @selector(markHighlightedStringInYellow:)
        ||action == @selector(markHighlightedStringInGreen:)
        ||action == @selector(speak:)
        ||action == @selector(markHighlightedStringInBlue:)
        ||action == @selector(markHighlightedStringInPurple:)
        ||action == @selector(markHighlightedStringInRed:)
        ||action == @selector(underLine:)
        ||action == @selector(takeNote:)
        ||action == @selector(ConceptCloud:)
        ||action == @selector(removeFormat:))
    {
        return YES;
    }
    
    if (action == @selector(copy:))
    {
        return NO;
    }
    if (action == @selector(define:))
    {
        return NO;
    }
    return NO;
}

//function that adds a node with name, not in use, but keep it in case we need its contents
- (void)dragAndDrop:(id)sender{
    if(parent_BookViewController.parent_BookPageViewController.cmapView.isReadyToLink){
        [parent_BookViewController.parent_BookPageViewController showAlertWithText:@"There is a concept waiting to be linked!"];
        return;
    }

    BOOL isHyperLink = [[NSUserDefaults standardUserDefaults] boolForKey:@"HyperLinking"];
    //Gets string
    //web view not our web browser
    NSString* h_text=[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    if(YES==isSplit){
        if(h_text.length>25){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You can not add concepts that have more than 25 charaters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
            return;
        }
        
        if([parent_BookViewController.parent_BookPageViewController.cmapView isNodeExist:h_text]){
            NSString *msg=[[NSString alloc]initWithFormat:@"Node with name \"%@\" already exist!",h_text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [parent_BookViewController.parent_BookPageViewController.cmapView createNodeFromBook:CGPointMake( arc4random() % 400+30, 690) withName:h_text BookPos:pvPoint page:pageNum];
        
        [self createConceptIcon:pvPoint NoteText:h_text isWriteToFile:YES];
        [self hideAllSubview:ThumbScrollViewRight];

        if(isHyperLink){//check if is group A
                [self saveHighlightToXML:@"#F2B36B" ];
        [self highlightStringWithColor:@"#F2B36B"];
        [parent_BookViewController.parent_BookPageViewController.cmapView highlightNode:h_text];
        }
    }
    
    if(parent_BookViewController.parent_BookPageViewController.isTraining&&parent_BookViewController.parent_BookPageViewController.cmapView.isAddNodeTraining){
       [parent_BookViewController.parent_BookPageViewController showFlipPageHint];
    }
    if(NO==isSplit){
    }
}


-(void)createConceptThumb: (NSString*)name{//creates concpet nodes in the verticle reading mode
    NodeViewController *node=[[NodeViewController alloc]initWithNibName:@"NodeViewController" bundle:nil];
    node.parentController=self;
    int y=[thumbNailController getIconPos:pvPoint type:1];
    [node.view setFrame:CGRectMake(6, y,node.view.frame.size.width, node.view.frame.size.height)];
    [self addChildViewController:node];
    [ThumbScrollViewRight addSubview: node.view ];
    node.text.text=name;
    node.text.disableEditting=YES;//disable editting
}

- (void)highlightStringWithColor:(NSString*)color{
    // Invoke the javascript function
    NSString *startSearch   = [NSString stringWithFormat:@"highlightStringWithColor(\""];
    startSearch=[startSearch stringByAppendingString:color];
    startSearch=[startSearch stringByAppendingString:@"\")"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
}

- (void)callJavaScriptMethod:(NSString*)method{
    // Invoke the javascript function
    NSString *startSearch   = [NSString stringWithFormat:@""];
    startSearch=[startSearch stringByAppendingString:method];
    startSearch=[startSearch stringByAppendingString:@"()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
}

//calling the function in HighlightedString.js to highlight the text in yellow
- (IBAction)markHighlightedStringInYellow : (id)sender {
    [self saveHighlightToXML:@"#ffffcc" ];
    [self highlightStringWithColor:@"#FFFFCC"];
    //shake the bulb image to indicate that there is new conpcet detected in the highlighted content
    if([self searchConceptCount]>0){
        [self shakeImage:nil];
    }
}

//calling the function in HighlightedString.js to highlight the text in green
- (IBAction)markHighlightedStringInGreen : (id)sender {
    [self saveHighlightToXML:@"#C5FCD6" ];
    [self highlightStringWithColor:@"#C5FCD6"];
    if([self searchConceptCount]>0){
        [self shakeImage:nil];
    }
}


//calling the function in HighlightedString.js to highlight the text in blue
- (IBAction)markHighlightedStringInBlue : (id)sender {
    [self saveHighlightToXML:@"#C2E3FF"];
    [self highlightStringWithColor:@"#C2E3FF"];
    if([self searchConceptCount]>0){
        [self shakeImage:nil];
    }
}

//calling the function in HighlightedString.js to highlight the text in purple
- (IBAction)markHighlightedStringInPurple : (id)sender {
    [self saveHighlightToXML:@"#E8CDFA"];
    [self highlightStringWithColor:@"#E8CDFA"];
    if([self searchConceptCount]>0){
        [self shakeImage:nil];
    }
}

//calling the function in HighlightedString.js to highlight the text in red
- (IBAction)markHighlightedStringInRed : (id)sender {
    [self saveHighlightToXML:@"#FFBABA"];
    [self highlightStringWithColor:@"#FFBABA"];
    if([self searchConceptCount]>0){
        [self shakeImage:nil];
    }
}

//calling the function in HighlightedString.js to underline the text
- (IBAction)underLine : (id)sender {
    [self callJavaScriptMethod:@"underlineText"];
    if([self searchConceptCount]>0){
        [self shakeImage:nil];
    }
}

//calling the function in HighlightedString.js to remove all the format
- (IBAction)removeFormat : (id)sender {
    [self callJavaScriptMethod:@"clearFormat"];
    if([self searchConceptCount]>0){
        [self shakeImage:nil];
    }
}


-(void)showPageAtINdex:(int)pageNumber{
    [parent_BookViewController showFirstPage:pageNumber];
}

//shows the popup view
- (IBAction)popUp : (UITapGestureRecognizer *)tap {
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    NSLog(@" %@",selection);
    NSString *definition=@"Textbook Definition: ";
  //  NSString *textBookDefinition= [knowledge_module getTextBookDefinition:selection];
   // definition=[definition stringByAppendingString: textBookDefinition];
    NSString *wikiLink=@"See wikipedia definition.";
    NSString *googleLink=@"Search Google.";
    NSArray *popUpContent=[NSArray arrayWithObjects:selection, definition,wikiLink,googleLink, nil];
    pv = [PopoverView showPopoverAtPoint:pvPoint
                                  inView:self.view
                               withTitle:@"Need help?"
                         withStringArray:popUpContent
                                delegate:self];
}


-(void)saveHighlightToXML:(NSString*)color_string {
    NSString* h_text=[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    int s_Container=[[webView stringByEvaluatingJavaScriptFromString:@"myGetNodeCount(document.body,window.getSelection().getRangeAt(0).startContainer)"] intValue];
    int e_Container= [[webView stringByEvaluatingJavaScriptFromString:@"myGetNodeCount(document.body,window.getSelection().getRangeAt(0).endContainer)"] intValue];
    int s_offSet= [[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).startOffset"] intValue];
    int e_offSet= [[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).endOffset"] intValue];
    HighLight *temp_highlight = [[HighLight alloc] initWithName:h_text pageNum:pageNum count:1 color:color_string startContainer:s_Container startOffset:s_offSet endContainer:e_Container endOffset:e_offSet bookTitle:bookTitle];
    if([self ifHighlightCollapse:temp_highlight]!=-1){
        [bookHighLight addHighlight:temp_highlight];
    }
    [HighlightParser saveHighlight:bookHighLight];
}



//handle situations when two hihglights collapse with each other
-(int)ifHighlightCollapse: (HighLight*) temp_highlight{
    if (bookHighLight != nil) {
        for (HighLight *highLightText in bookHighLight.highLights) {
            if(highLightText.startContainer==temp_highlight.startContainer&& highLightText.endContainer==(temp_highlight.endContainer-1)&&highLightText.page==pageNum){
                temp_highlight.endContainer--;
                int temp=highLightText.startOffset;
                highLightText.startOffset+=temp_highlight.endOffset;
                temp_highlight.endOffset+=temp;
                return 0;
            }
            
            else if(highLightText.startContainer==(temp_highlight.startContainer-1)&& highLightText.endContainer==(temp_highlight.endContainer-2)&&highLightText.page==pageNum){
                temp_highlight.startContainer++;
                
                int temp=highLightText.endOffset;
                int temp_startOffset=temp_highlight.startOffset;
                highLightText.endOffset=highLightText.startOffset+ temp_highlight.startOffset;
                temp_highlight.startOffset=0;
                temp_highlight.endOffset+=temp-highLightText.startOffset-temp_startOffset;
                return 0;
            }
            if (highLightText.startContainer==temp_highlight.startContainer&&highLightText.endContainer<temp_highlight.endContainer&&highLightText.page==pageNum) {
                highLightText.text=temp_highlight.text;
                highLightText.startOffset=temp_highlight.startOffset;
                highLightText.endOffset+=temp_highlight.endOffset;
                highLightText.color=temp_highlight.color;
                temp_highlight=nil;
                return -1;
            }
        }
    }
    return 0;
}


//use the tts engine to speak the selected text
- (IBAction)speak : (id)sender {
    
    //get the selected text
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    AVSpeechUtterance *utterance_English= [[AVSpeechUtterance alloc]initWithString:selection];
    utterance_English.rate = AVSpeechUtteranceMaximumSpeechRate/7;
    utterance_English.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"es-us"];
    [syn speakUtterance:utterance_English];
}

- (IBAction)takeNote : (id)sender {
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    firstRespondConcpet=selection;
    NSArray *popUpContent=[NSArray arrayWithObjects:@"NoteTaking", nil];
    pv = [PopoverView showPopoverAtPoint:pvPoint
                                  inView:self.view
                               withTitle:@"Take Note"
                         withStringArray:popUpContent
                                delegate:self];
    pv.parent_View_Controller=self;
    pv.showPoint=pvPoint;
    pv.parentViewController=self;
}


-(void)createWebNote : (CGPoint) show_at_point URL:(NSURLRequest*) urlrequest isWriteToFile:(BOOL)iswrite isNewIcon: (BOOL)isNew  {
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    firstRespondConcpet=selection;
    WebMarkController *note= [[WebMarkController alloc]
                              initWithNibName:@"WebMarkController" bundle:nil];
    note.web_requestObj=urlrequest;
    note.pvPoint=show_at_point;
    note.parentController=self;
    CGPoint newPos;
    newPos.x=show_at_point.x;
    newPos.y=[thumbNailController getIconPos:show_at_point type:0];
    note.iconPoint=newPos;
    [self addChildViewController:note];
    [ThumbScrollViewLeft addSubview:note.view];
    
    NSString *urlString= [[urlrequest URL] absoluteString];
    
    if([firstRespondConcpet isEqualToString:@""]){
        firstRespondConcpet=@"Cell";
    }
    ThumbNailIcon *temp_thumbnail = [[ThumbNailIcon alloc] initWithName: 2 Text: @"" URL:urlString showPoint:show_at_point pageNum:pageNum bookTitle:bookTitle relatedConcept:firstRespondConcpet];
    if(iswrite){
        [bookthumbNailIcon addthumbnail:temp_thumbnail];
        [ThumbNailIconParser saveThumbnailIcon:bookthumbNailIcon];
    }
}


-(NoteViewController*)createNote : (CGPoint) show_at_point NoteText:(NSString*) m_note_text isWriteToFile:(BOOL)iswrite  {
    NoteViewController *note= [[NoteViewController alloc]
                               initWithNibName:@"NoteView" bundle:nil];
    note.note_text= m_note_text;
    note.pvPoint=show_at_point;
    note.parentController=self;
    CGPoint newPos;
    newPos.x=show_at_point.x;
    newPos.y=[thumbNailController getIconPos:show_at_point type: 0];
    note.iconPoint=newPos;
    [self addChildViewController:note];
    [ThumbScrollViewLeft addSubview: note.view ];
    
    if([firstRespondConcpet isEqualToString:@""]){
        firstRespondConcpet=@"Cell";
    }
    ThumbNailIcon *temp_thumbnail = [[ThumbNailIcon alloc] initWithName: 1 Text: m_note_text URL:@"" showPoint:show_at_point pageNum:pageNum bookTitle:bookTitle relatedConcept:firstRespondConcpet];
    if(iswrite){
        NSLog(@"True Node");
        [bookthumbNailIcon addthumbnail:temp_thumbnail];
        [bookthumbNailIcon printAllThumbnails];
        
        [ThumbNailIconParser saveThumbnailIcon:bookthumbNailIcon];
    }
    return note;
}


-(NodeViewController*)createConceptIcon : (CGPoint) show_at_point NoteText:(NSString*) m_note_text isWriteToFile:(BOOL)iswrite{
    NodeViewController *node=[[NodeViewController alloc]initWithNibName:@"NodeViewController" bundle:nil];
    node.parentController=self;
    /*
     node.nodeType=1;
     node.isInitialed=YES;
     node.text.enabled=NO;
     node.parentContentViewController=self;
     */
    int y=[thumbNailController getIconPos:show_at_point type:0];
    [node.view setFrame:CGRectMake(6, y,node.view.frame.size.width, node.view.frame.size.height)];
    [self addChildViewController:node];
    [ThumbScrollViewRight addSubview: node.view ];
    node.text.text=m_note_text;
    node.text.disableEditting=YES;//disable editting
    ThumbNailIcon *temp_thumbnail = [[ThumbNailIcon alloc] initWithName: 3 Text: m_note_text URL:@"" showPoint:show_at_point pageNum:pageNum bookTitle:bookTitle relatedConcept:nil];
    if(iswrite){
        [bookthumbNailIcon addthumbnail:temp_thumbnail];
        [bookthumbNailIcon printAllThumbnails];
        [ThumbNailIconParser saveThumbnailIcon:bookthumbNailIcon];
    }
    return node;
}


-(void)updateNoteText:(CGPoint) show_at_point PreText: (NSString*)pre_text NewText: (NSString *)new_text
{
    NSLog(@"Update!!");
    for(ThumbNailIcon *icon in bookthumbNailIcon.thumbnails ){
        if(icon.showPoint.x== show_at_point.x && icon.showPoint.y==show_at_point.y&& [icon.text isEqualToString:pre_text]){
            icon.text=new_text;
        }
    }
    [ThumbNailIconParser saveThumbnailIcon:bookthumbNailIcon];
}


- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    NSString *startSearch = [NSString stringWithFormat:@"MyApp_HighlightAllOccurencesOfString('%@')",str];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"MyApp_SearchResultCount"];
    return [result integerValue];
}


-(void)loadHghLight{
    if (bookHighLight != nil) {
        for (HighLight *highLightText in bookHighLight.highLights) {
            if(pageNum== highLightText.page && [bookTitle isEqualToString: highLightText.bookTitle]){
                NSString *methodString=[NSString stringWithFormat:@"highlightRangeByOffset(document.body,%d,%d,%d,%d,'%@')",highLightText.startContainer,highLightText.startOffset,
                                        highLightText.endContainer,highLightText.endOffset,highLightText.color];
                [webView stringByEvaluatingJavaScriptFromString:methodString];
            }
        }
    }
}

-(void)loadThumbNailIcon: (NSString*)concpet{
    if(bookthumbNailIcon!=nil){
        for(ThumbNailIcon *thumbNailItem in bookthumbNailIcon.thumbnails){
            // if([thumbNailItem.relatedConcpet isEqualToString: concpet]){
            
            if(thumbNailItem.page==pageNum && [bookTitle isEqualToString: thumbNailItem.bookTitle]){
                if(1==thumbNailItem.type){
                    [self createNote:thumbNailItem.showPoint NoteText:thumbNailItem.text isWriteToFile:NO];
                }else if(2==thumbNailItem.type){
                    [self createWebNote:thumbNailItem.showPoint URL:   [NSURLRequest requestWithURL:[NSURL URLWithString:thumbNailItem.url]] isWriteToFile:NO isNewIcon:YES ];
                }else if (3==thumbNailItem.type){//thumb nail concepts at the right side bar
                   // [self createConceptIcon:thumbNailItem.showPoint NoteText:thumbNailItem.text isWriteToFile:NO];
                }
            }
            //}
        }
    }
    
    //initialize bulb image vie
    self.bulbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [self.bulbImageView setImage:[UIImage imageNamed:@"idea"]];
    self.bulbImageView.alpha=0.8;
    self.bulbImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *bulbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToQuiz:)];
    
    [self.bulbImageView addGestureRecognizer:bulbTap];
    
   // [ThumbScrollViewLeft addSubview:self.bulbImageView]; //hide the quiz view button for the turk study
}


-(void)autoGerenateConceptNode{
    int conceptId=0;
    if ( bookHighLight!= nil) {
        for (HighLight *highLightText in bookHighLight.highLights) {
            NSString *methodString=highLightText.text;
            for (  Concept *cell in knowledge_module.conceptList) {
                if([methodString rangeOfString:cell.conceptName].location != NSNotFound){
                    /*
                     if(![conceptNamesArray containsObject: cell.conceptName]){
                     [conceptNamesArray addObject:cell.conceptName];
                     CGPoint position= [self calculateNodePosition:conceptId];
                     conceptId++;
                     //[self createNode:position withName:cell.conceptName];
                     }*/
                    
                }
            }
        }
    }
}

-(UIImage*)getScreenShot{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[snapshotImage CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@40 forKey:kCIInputRadiusKey];
    
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    CGRect rect          = [outputImage extent];
    
    // these three lines ensure that the final image is the same size
    
    rect.origin.x        += (rect.size.width  - snapshotImage.size.width ) / 2;
    rect.origin.y        += (rect.size.height - snapshotImage.size.height) / 2;
    rect.size            = snapshotImage.size;
    
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];
    UIImage *image       = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return image;
}

// check if the menu bar is showing
- (IBAction)didHideEditMenu : (id)sender {
    isMenuShow=NO;
}
//if the menu bar is about popup, hide the navigation bar
- (IBAction)willShowEditMenu : (id)sender {
   //[self.parentViewController.navigationController setNavigationBarHidden: YES animated:YES];
    isMenuShow=YES;
}
- (IBAction)didShowEditMenu : (id)sender {
    isMenuShow=YES;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(0==scrollView.tag){
        LogData* log= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"scroll page" selection:@"null" input:@"null" pageNum:pageNum];
        [bookLogData addLogs:log];
        [LogDataParser saveLogData:bookLogData];
    }
}


-(void)shakeImage:(id)sender {
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:-0.3];
    shake.toValue = [NSNumber numberWithFloat:+0.3];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 3;
    [self.bulbImageView.layer addAnimation:shake forKey:@"imageView"];
    // self.bulbImageView.alpha = 1.0;
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
}


- (UIImage*)scaleToSize:(CGSize)size image:(UIImage*) img {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), img.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(int)searchConceptCount{
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    int conceptId=0;
    
    for (  Concept *cell in knowledge_module.conceptList) {
        if([selection rangeOfString:cell.conceptName].location != NSNotFound){
            if(![conceptNamesArray containsObject: cell.conceptName]){
                [conceptNamesArray addObject:cell.conceptName];
                conceptId++;
            }
        }
    }
    return conceptId;
}




-(BOOL)prefersStatusBarHidden{
    return YES;
}



-(void)showCmapFullScreen{
    //isSplit=NO;
    //[self resumeNormalScreenLandscape];
    
}

-(void)showRecourseFullScreen{
    isSplit=NO;
    //[self resumeNormalScreenLandscape];
    LSHorizontalScrollTabViewDemoViewController *tabView=[[LSHorizontalScrollTabViewDemoViewController alloc] initWithNibName:@"LSHorizontalScrollTabViewDemoViewController" bundle:nil];
    tabView.highlightWrapper=bookHighLight;
    tabView.thumbNailWrapper=bookthumbNailIcon;
    tabView.bookTitle=bookTitle;
    tabView.showType=0;
    tabView.parentContentViewController=self;
    [self.navigationController pushViewController:tabView animated:NO];
    //[self addChildViewController:tabView];
    //[self.view addSubview:tabView.view];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    //when retating the device, clear the thumbnail icons and reload
    if(fromInterfaceOrientation==UIInterfaceOrientationPortrait||fromInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        CGRect rec=CGRectMake(10, 8, 485, 760);
        [webView setFrame:rec];
        //[ThumbScrollViewRight setHidden:YES];
        //[self hideAllSubview:ThumbScrollViewRight];
        //[self hideAllSubview:ThumbScrollViewLeft];
        isSplit=YES;
            [self.parent_BookViewController.parent_BookPageViewController.myWebView updateBrowserWindow];
        //When rotate
        
       // NSString *jsString2 = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",96];
        //[webView stringByEvaluatingJavaScriptFromString:jsString2];
    }
    //otherwise, hide the concept map view.
    if(fromInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||fromInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
        [self showAllSubview:ThumbScrollViewRight];
         [self showAllSubview:ThumbScrollViewLeft];
        [self deleteAllSubview:ThumbScrollViewLeft];
        [self deleteAllSubview:ThumbScrollViewRight];
        [self refresh];

        [self loadThumbNailIcon:firstRespondConcpet];
        isSplit=NO;
        [self.parent_BookViewController.parent_BookPageViewController.myWebView updateBrowserWindow];

        //when rotate
        
    }
    
}

-(void)hideAllSubview: (UIView*)parentView{
    for (UIView *subview in parentView.subviews){
        [subview setHidden:YES];
    }
}
-(void)deleteAllSubview:(UIView*)parentView{
    NSArray *viewsToRemove = [parentView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

-(void)showAllSubview: (UIView*)parentView{
    for (UIView *subview in parentView.subviews){
        [subview setHidden:NO];
    }
}

-(void)expandSubNode:(UIView*)node {
    for(UIView* subnode in ThumbScrollViewRight.subviews){
        if(node==subnode){
            if(subnode.tag!=1){
                for(UIView* snode in ThumbScrollViewRight.subviews){
                    if(snode.frame.origin.y>subnode.frame.origin.y){
                        [snode setFrame:CGRectMake(snode.frame.origin.x,snode.frame.origin.y+200,snode.frame.size.width,snode.frame.size.height)];
                    }
                }
                
                for(int i=0; i<5; i++){
                    
                    SubNodeViewController *newNode=[[SubNodeViewController alloc]initWithNibName:@"SubNodeViewController" bundle:nil];
                    newNode.parentController=self;
                    newNode.parentBookViewController=parent_BookViewController;
                    //newNode.isSubNode=YES;
                    //int y=[thumbNailController getIconPos:pvPoint type:1];
                    [newNode.view setFrame:CGRectMake(node.frame.origin.x+15,node.frame.origin.y+35*(i+1), node.frame.size.width-20, node.frame.size.height-20)];
                    [self addChildViewController:newNode];
                    [ThumbScrollViewRight addSubview: newNode.view ];
                    newNode.text.text=@"Sub";
                    newNode.text.disableEditting=YES;//disable editting
                    newNode.view.tag=2;
                    
                }
                
                
                subnode.tag=1;//mark the node, indicating that it's been expanded
            }//end if
            
            else if(subnode.tag==1){
                for(UIView* snode in ThumbScrollViewRight.subviews){
                    if(snode.frame.origin.y>subnode.frame.origin.y){
                        [snode setFrame:CGRectMake(snode.frame.origin.x,snode.frame.origin.y-200,snode.frame.size.width,snode.frame.size.height)];
                    }
                }
                
                for(UIView *subview in [ThumbScrollViewRight subviews]) {
                    if(subview.tag==2) {
                        [subview removeFromSuperview];
                    } else {
                        // Do nothing - not a UIButton or subclass instance
                    }
                }
                subnode.tag=0;//mark the node back to unexpanded
            }
            
        }
    }
    
}







-(void)showOverLayCmapView{

    [overLayCmapView.view setHidden:NO];
    showingOverLayCmap=YES;
    
}

-(void)hideOverLayCmapView{
    
    [overLayCmapView.view setHidden:YES];
    showingOverLayCmap=NO;
    
}

@end


