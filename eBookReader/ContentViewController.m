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
// for the "quick help" feature, we haven't decided what interaction we want to add after user clicks the button so we define this array to display some default word.
#define kStringArray [NSArray arrayWithObjects:@"YES", @"NO",@"Wiki",@"Google", nil]
#define H_CONTROL_ORIGIN CGPointMake(200, 300)
 

@interface ContentViewController ()
@end
@implementation ContentViewController
@synthesize webView;
@synthesize isMenuShow;
@synthesize pageNum;
@synthesize totalpageNum;
@synthesize parent_BookViewController;
@synthesize highlightTextArray;
@synthesize fliteController;
@synthesize slt;
@synthesize knowledge_module;
@synthesize thumbNailController;
@synthesize logFileController;
@synthesize bookHighLight;

//initial methods for the open ears tts instance
- (FliteController *)fliteController { if (fliteController == nil) {
    fliteController = [[FliteController alloc] init]; }
    return fliteController;
}
//initial methods for the open ears tts instance
- (Slt *)slt {
    if (slt == nil) {
        slt = [[Slt alloc] init]; }
    return slt;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [webView setDelegate:self];
    
    //disable the bounce animation in the webview
    UIScrollView* sv = [webView scrollView];
    sv.pagingEnabled=YES;
    [sv setShowsHorizontalScrollIndicator:NO];
    [sv setShowsVerticalScrollIndicator:NO];
    sv.bounces = NO;
    isMenuShow=NO;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerOneTaps:)];
    [singleTap setNumberOfTapsRequired:1];
    singleTap.delegate=self;
    [webView addGestureRecognizer:singleTap];
    
    //initialize the knowledge module
    knowledge_module=[ [KnowledgeModule alloc] init ];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    [doubleTap setNumberOfTapsRequired:2];
    doubleTap.delegate=self;
    [webView addGestureRecognizer:doubleTap];
    //set up menu items, icons and methods
    [self setingUpMenuItem];

    //specify the javascript file path
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"JavaScriptFunctions" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"Javascript file path null!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    NSLog(@"Load Java script file.\n");
   // [webView loadHTMLString:_dataObject baseURL:_url];
    thumbNailController= [[ThumbNailController alloc]
                              initWithNibName:@"ThumbNailController" bundle:nil];
    logFileController= [[LogFileController alloc]
                          initWithNibName:@"LogFileController" bundle:nil];
    //load page highlights
    [bookHighLight printAllHighlight];
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
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"JavaScriptFunctions" ofType:@"js" inDirectory:@""];
    if(filePath==nil){
        NSLog(@"Javascript file path null!");
    }
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    [webView loadHTMLString:_dataObject baseURL:_url];
    [self.currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageNum, totalpageNum]];
}

//after the webview loads page, load highlight content
-(void)webViewDidFinishLoad:(UIWebView *)m_webView{
    [self loadHghLight];
    NSString* htmlt=[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
   // NSLog(htmlt);
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
    
    
    [menuController setMenuItems: [NSArray arrayWithObjects:getHighlightString, markHighlightedStringYellow,markHighlightedStringGreen, markHighlightedStringBlue,
                                   markHighlightedStringPurple,markHighlightedStringRed,underLineItem,undoItem,takeNoteItem,speakItem, nil]];
    
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
}

//calling the function in HighlightedString.js to highlight the text in green
- (IBAction)markHighlightedStringInGreen : (id)sender {
    [self saveHighlightToXML:@"#C5FCD6" ];
    [self highlightStringWithColor:@"#C5FCD6"];
}


//calling the function in HighlightedString.js to highlight the text in blue
- (IBAction)markHighlightedStringInBlue : (id)sender {
    [self saveHighlightToXML:@"#C2E3FF"];
      [self highlightStringWithColor:@"#C2E3FF"];
}

//calling the function in HighlightedString.js to highlight the text in purple
- (IBAction)markHighlightedStringInPurple : (id)sender {
    [self saveHighlightToXML:@"#E8CDFA"];
    [self highlightStringWithColor:@"#E8CDFA"];
}

//calling the function in HighlightedString.js to highlight the text in red
- (IBAction)markHighlightedStringInRed : (id)sender {
    [self saveHighlightToXML:@"#FFBABA"];
    [self highlightStringWithColor:@"#FFBABA"];
}

//calling the function in HighlightedString.js to underline the text
- (IBAction)underLine : (id)sender {
    [self callJavaScriptMethod:@"underlineText"];
}

//calling the function in HighlightedString.js to remove all the format
- (IBAction)removeFormat : (id)sender {
    [self callJavaScriptMethod:@"clearFormat"];
}


//shows the popup view
- (IBAction)popUp : (UITapGestureRecognizer *)tap {
    NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    NSLog(@" %@",selection);
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


-(void)saveHighlightToXML:(NSString*)color_string {
    
   NSString* htmlt=[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
   // NSLog(htmlt);
    NSString* h_text=[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    int s_Container=[[webView stringByEvaluatingJavaScriptFromString:@"myGetNodeCount(document.body,window.getSelection().getRangeAt(0).startContainer)"] intValue];
    int e_Container= [[webView stringByEvaluatingJavaScriptFromString:@"myGetNodeCount(document.body,window.getSelection().getRangeAt(0).endContainer)"] intValue];
    int s_offSet= [[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).startOffset"] intValue];
    int e_offSet= [[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).endOffset"] intValue];
    HighLight *temp_highlight = [[HighLight alloc] initWithName:h_text pageNum:pageNum count:1 color:color_string startContainer:s_Container startOffset:s_offSet endContainer:e_Container endOffset:e_offSet];
    NSLog([webView stringByEvaluatingJavaScriptFromString:@"myGetNodeCount(document.body,window.getSelection().getRangeAt(0).startContainer)"] );
    NSLog([webView stringByEvaluatingJavaScriptFromString:@"myGetNodeCount(document.body,window.getSelection().getRangeAt(0).endContainer)"]);
    NSLog([webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).startOffset"]);
    NSLog([webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).endOffset"]);
    if([self ifHighlightCollapse:temp_highlight]){
       // NSLog(@"End OFfset: %d",temp_highlight.endOffset);
    }
    [bookHighLight addHighlight:temp_highlight];
[HighlightParser saveHighlight:bookHighLight];
}

-(BOOL)ifHighlightCollapse: (HighLight*) temp_highlight{
    if (bookHighLight != nil) {
        for (HighLight *highLightText in bookHighLight.highLights) {
            if(highLightText.startContainer==temp_highlight.startContainer&& highLightText.endContainer==(temp_highlight.endContainer-1)&&highLightText.page==pageNum){
                temp_highlight.endContainer--;
                int temp=highLightText.startOffset;
                highLightText.startOffset+=temp_highlight.endOffset;
                temp_highlight.endOffset+=temp;
                return YES;
            }
            
            else if(highLightText.startContainer==(temp_highlight.startContainer-1)&& highLightText.endContainer==(temp_highlight.endContainer-2)&&highLightText.page==pageNum){
                temp_highlight.startContainer++;
                
                int temp=highLightText.endOffset;
                int temp_startOffset=temp_highlight.startOffset;
                NSLog(@"temp startOffset: %d",temp);
                 NSLog(@"temp Endoffset %d",temp_highlight.endOffset);
                NSLog(@"origin startOffset: %d",highLightText.startOffset);
                NSLog(@"origin Endoffset %d",highLightText.endOffset);
                highLightText.endOffset=highLightText.startOffset+ temp_highlight.startOffset;
                NSLog(@"origin endoffset after%d",highLightText.endOffset);
                temp_highlight.startOffset=0;
                temp_highlight.endOffset+=temp-highLightText.startOffset-temp_startOffset;
                NSLog(@"after endoffset %d",temp_highlight.endOffset);

                return YES;
            }
            
            
        }
    }
    return NO;
}


//use the tts engine to speak the selected text
- (IBAction)speak : (id)sender {
    
     //get the selected text
     NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
        [self.fliteController say:selection withVoice:self.slt];
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


-(void)createWebNote : (CGPoint) show_at_point URL:(NSURLRequest*) urlrequest  {
    WebMarkController *note= [[WebMarkController alloc]
                              initWithNibName:@"WebMarkController" bundle:nil];
    note.web_requestObj=urlrequest;
    note.pvPoint=show_at_point;
    CGPoint newPos;
    newPos.x=show_at_point.x;
    newPos.y=[thumbNailController getIconPos:pvPoint];
    note.iconPoint=newPos;
    [self addChildViewController:note];
    [self.view addSubview:note.view];
}


-(NoteViewController*)createNote : (CGPoint) show_at_point NoteText:(NSString*) m_note_text  {
    NoteViewController *note= [[NoteViewController alloc]
                               initWithNibName:@"NoteView" bundle:nil];
    note.note_text= m_note_text;
    note.pvPoint=show_at_point;
    CGPoint newPos;
    newPos.x=show_at_point.x;
    newPos.y=[thumbNailController getIconPos:pvPoint];
    note.iconPoint=newPos;
    [self addChildViewController:note];
    [self.view addSubview: note.view ];
    return note;
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
            if(pageNum== highLightText.page){
                NSString *methodString=[NSString stringWithFormat:@"highlightRangeByOffset(document.body,%d,%d,%d,%d,'%@')",highLightText.startContainer,highLightText.startOffset,
                                    highLightText.endContainer,highLightText.endOffset,highLightText.color];
                [webView stringByEvaluatingJavaScriptFromString:methodString];            
            }
        }
    }
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
