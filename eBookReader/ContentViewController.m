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
#import "KnowledgeModule.h"
//#import "PopoverView.h"
#define kStringArray [NSArray arrayWithObjects:@"YES", @"NO",@"Wiki",@"Google", nil]
#define kImageArray [NSArray arrayWithObjects:[UIImage imageNamed:@"success"], [UIImage imageNamed:@"error"], nil]
#define H_CONTROL_ORIGIN CGPointMake(200, 300)
#define APPID @"5163a3e1"
#define ENGINE_URL @"http://dev.voicecloud.cn/index.htm"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize webView;
@synthesize oneFingerTap;
@synthesize isMenuShow;
@synthesize pageNum;
@synthesize totalpageNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



//implement the synthesizer delegater methods
- (void)onSynthesizerEnd:(IFlySynthesizerControl *)iFlySynthesizerControl theError:(SpeechError) error
{
	NSLog(@"finishing speaking.....");
	// get the upload flow and download flow
	NSLog(@"upFlow:%d,downFlow:%d",[iFlySynthesizerControl getUpflow:FALSE],[iFlySynthesizerControl getDownflow:FALSE]);

}

// get the player buffer progress
- (void)onSynthesizerBufferProgress:(float)bufferProgress
{
    NSLog(@"the playing buffer :%f",bufferProgress);
}

// get the player progress
- (void)onSynthesizerPlayProgress:(float)playProgress
{
    NSLog(@"the playing progress :%f",playProgress);
}



- (void)viewDidLoad
{
    //disable the bounce animation in the webview
    UIScrollView* sv = nil;
	for (UIView* v in  webView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
            sv.pagingEnabled=YES;
			//sv.scrollEnabled = NO;
            [sv setShowsHorizontalScrollIndicator:NO];
            [sv setShowsVerticalScrollIndicator:NO];
			sv.bounces = NO;
		}
	}
    
    isMenuShow=NO;
    oneFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerOneTaps:)] ;
    oneFingerTap.delegate=self;
    [webView addGestureRecognizer:oneFingerTap];
    //specify the gesture recognizer
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    [doubleTap setNumberOfTapsRequired:2];
    doubleTap.delegate=self;
    [webView addGestureRecognizer:doubleTap];
    
    [self setingUpMenuItem];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //display the HTMl content by refering to the URL link
    [super viewWillAppear:animated];
    [webView loadHTMLString:_dataObject baseURL:_url];
    [self.currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageNum, totalpageNum]];
}

//refresh the book page
-(void) refresh{
    [webView loadHTMLString:_dataObject baseURL:_url];
    [self.currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageNum, totalpageNum]];
}

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
    markIconSettingsPopUp.image = [UIImage imageNamed:@"question"];
    markIconSettingsPopUp.shadowDisabled = NO;
    markIconSettingsPopUp.shrinkWidth = 4; //set menu item size and picture.
    
    CXAMenuItemSettings *markIconSettingsYelow = [CXAMenuItemSettings new];
    markIconSettingsYelow.image = [UIImage imageNamed:@"highlight_yellow"];
    markIconSettingsYelow.shadowDisabled = NO;
    markIconSettingsYelow.shrinkWidth = 4; //set menu item size and picture.
    
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
    
    
    CXAMenuItemSettings *takeNoteSetting = [CXAMenuItemSettings new];
    takeNoteSetting.image = [UIImage imageNamed:@"take_note"];
    takeNoteSetting.shadowDisabled = NO;
    takeNoteSetting.shrinkWidth = 4; //set menu item size and picture.
    
    
    UIMenuItem *getHighlightString = [[UIMenuItem alloc] initWithTitle: @"Pop" action: @selector(popUp:)];
    [getHighlightString cxa_setSettings:markIconSettingsPopUp];
    
    UIMenuItem *markHighlightedStringYellow = [[UIMenuItem alloc] initWithTitle: @"mark yellow" action: @selector(markHighlightedStringInYellow:)];
    [markHighlightedStringYellow cxa_setSettings:markIconSettingsYelow];
    
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
    
    UIMenuItem *takeNoteItem = [[UIMenuItem alloc] initWithTitle: @"take note" action: @selector(takeNote:)];
    [takeNoteItem cxa_setSettings:takeNoteSetting];
    
    
    UIMenuItem *speakItem = [[UIMenuItem alloc] initWithTitle: @"speak" action: @selector(speak:)];
    [speakItem cxa_setSettings:markIconSettingSpeak];
    
    
    [menuController setMenuItems: [NSArray arrayWithObjects:getHighlightString, markHighlightedStringYellow,markHighlightedStringGreen, markHighlightedStringBlue,markHighlightedStringPurple,markHighlightedStringRed,underLineItem,undoItem,takeNoteItem,speakItem, nil]];
    
    [menuController setMenuVisible:YES animated:YES];

}

// invoke when user tap with one finger once
- (void)oneFingerOneTaps:(UITapGestureRecognizer *)tap
{
    pvPoint = [tap locationInView:self.view];//track the last click position in order to show the popUp view
    if(!isMenuShow){  //is the menu bar is showing, disable the gesture action
    //set navigation bar animation, which uses the QuartzCore framework.
    CATransition *navigationBarAnimation = [CATransition animation];
    navigationBarAnimation.duration = 0.7;
    navigationBarAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];;
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
    [popoverView showImage:[UIImage imageNamed:@"success"] withMessage:string];
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
        webBroser.requestObj=requestObj;
        webBroser.parent_View_Controller=self;
       // [webBroser setParent_View:self];
        //push the controller to the navigation bar
        [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque; 
        [self.navigationController pushViewController:webBroser animated:YES];
    }else if (3==index){
        
        NSString *googleLink=@"https://www.google.com/search?q=";
        googleLink=[googleLink stringByAppendingString:selection];
        NSLog(@"%@",googleLink);
        //replace the " " character in the url with "%20" in order to connect the seperate words for search
        googleLink= [googleLink stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
         NSLog(@"Url Link afterf replacing %@",googleLink);
        NSURL *url = [NSURL URLWithString:googleLink];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
       WebBrowserViewController *webBroser= [[WebBrowserViewController alloc]
                                             initWithNibName:@"WebBrowserViewController" bundle:nil];
        webBroser.parent_View_Controller=self;
       //[webBroser setParent_View:self];
        webBroser.requestObj=requestObj;
        [self.parentViewController.navigationController setNavigationBarHidden: NO animated:YES];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationController pushViewController:webBroser animated:YES];
         
    }
    
    // Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}


//Need to add this function to enable web view to recognize gesture.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//give permission to show the menu item we added
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
  if (  action == @selector(markHighlightedString:)
               ||action==@selector(popUp:)
               ||action == @selector(markHighlightedStringInYellow:)
               ||action == @selector(markHighlightedStringInGreen:)
               ||action==@selector(speak:)
               ||action == @selector(markHighlightedStringInBlue:)
               ||action == @selector(markHighlightedStringInPurple:)
               ||action == @selector(markHighlightedStringInRed:)
               ||action == @selector(underLine:)
               ||action==@selector(takeNote:)
               ||action == @selector(removeFormat:)) 
    {
        return YES;
    }
    return NO;
}

//calling the function in HighlightedString.js to highlight the text in yellow
- (IBAction)markHighlightedStringInYellow : (id)sender {
    NSLog(@" Mark highlight string! ");
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"File path Nil!!!!!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedString()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
}

//calling the function in HighlightedString.js to highlight the text in green
- (IBAction)markHighlightedStringInGreen : (id)sender {
    NSLog(@" Mark highlight string! ");
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"File path Nil!!!!!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedStringGreen()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
}

//calling the function in HighlightedString.js to highlight the text in blue
- (IBAction)markHighlightedStringInBlue : (id)sender {
    NSLog(@" Mark highlight string! ");
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"File path Nil!!!!!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedStringBlue()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
}


//calling the function in HighlightedString.js to highlight the text in purple
- (IBAction)markHighlightedStringInPurple : (id)sender {
    NSLog(@" Mark highlight string! ");
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"File path Nil!!!!!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedStringPurple()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
}

//calling the function in HighlightedString.js to highlight the text in red
- (IBAction)markHighlightedStringInRed : (id)sender {
    NSLog(@" Mark highlight string! ");
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"File path Nil!!!!!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedStringRed()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
    }



//calling the function in HighlightedString.js to underline the text
- (IBAction)underLine : (id)sender {
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"File path Nil!!!!!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"underlineText()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];

}



//calling the function in HighlightedString.js to remove all the format
- (IBAction)removeFormat : (id)sender {
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"HighlightedString" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"File path Nil!!!!!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"clearFormat()"];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
}


//shows the popup view
- (IBAction)popUp : (UITapGestureRecognizer *)tap {
   
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    NSLog(@" %@",selection);
    KnowledgeModule *knowledge_module=[ [KnowledgeModule alloc] init ];
    NSString *definition=@"Textbook Definition: ";
    NSString *textBookDefinition= [knowledge_module getTextBookDefinition:selection];
    definition=[definition stringByAppendingString: textBookDefinition];

    NSString *wikiLink=@"See wikipedia definition.";
    NSString *googleLink=@"Search Google.";
    NSArray *popUpContent=[NSArray arrayWithObjects:selection, definition,wikiLink,googleLink, nil];
    pv = [PopoverView showPopoverAtPoint:pvPoint
                                  inView:self.view
                               withTitle:@"Need help?"
                         withStringArray:popUpContent
                                delegate:self];
}

//use the tts engine to speak the selected text
- (IBAction)speak : (id)sender {
    //////set up text to voice synthesizer
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
    //initial syntheaizer
    _iFlySynthesizerControl = [[IFlySynthesizerControl alloc] initWithOrigin:H_CONTROL_ORIGIN initParam:initParam];
    _iFlySynthesizerControl.delegate = self;
    [_iFlySynthesizerControl setVoiceName: @"henry"];//set up speaker choices: Catherine, henry, vimary
   //[_iFlySynthesizerControl setVoiceName: @"Catherine"];//set up speaker
    [self.parentViewController.view addSubview:_iFlySynthesizerControl];
    //get the selected text
     NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    //hide the popup view
    [_iFlySynthesizerControl setShowUI:NO];
    [_iFlySynthesizerControl setText:selection params:nil];
          NSLog(@"Speaking...");
    //speak
   [_iFlySynthesizerControl start];
    

}


- (IBAction)takeNote : (id)sender {
    
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

-(void)createWebNote : (NSURLRequest*) urlrequest  {
    WebMarkController *note= [[WebMarkController alloc]
                              initWithNibName:@"WebMarkController" bundle:nil];
    note.web_requestObj=urlrequest;
    [self addChildViewController:note];
    [self.view addSubview:note.view];
}


-(void)printNull{
    NSLog(@"Test");
}

-(void)createNote : (CGPoint) show_at_point NoteText:(NSString*) m_note_text  {

    NSLog(@"Creating note\n");
    NoteViewController *note= [[NoteViewController alloc]
                               initWithNibName:@"NoteView" bundle:nil];
    note.note_text= m_note_text;
    note.pvPoint=show_at_point;
    [self addChildViewController:note];
    [self.view addSubview: note.view ];

}


// check if the menu bar is showing
- (IBAction)didHideEditMenu : (id)sender {
    isMenuShow=NO;
}
//if the menu bar is about popup, hide the navigation bar
- (IBAction)willShowEditMenu : (id)sender {
    [self.parentViewController.navigationController setNavigationBarHidden: YES animated:YES];
    isMenuShow=YES;
}
- (IBAction)didShowEditMenu : (id)sender {
    isMenuShow=YES;
}



@end
