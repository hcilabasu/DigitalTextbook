//
//  WebBrowserViewController.m
//  eBookReader
//
//  Created by Shang Wang on 4/16/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "WebBrowserViewController.h"
#import "BookPageViewController.h"
#import "UIMenuItem+CXAImageSupport.h"
#import "NodeCell.h"
#import "QuartzCore/QuartzCore.h"

@interface WebBrowserViewController ()
@end
@implementation WebBrowserViewController
@synthesize webBrowserView;
@synthesize url;
@synthesize prevUrl;
@synthesize requestObj;
@synthesize next;
@synthesize pre;
@synthesize webAdr;
@synthesize serchBar;
@synthesize webAdrText;
@synthesize urlStack;
@synthesize urlId;
@synthesize refresh;
@synthesize back;
@synthesize markPage;
@synthesize pvPoint;
@synthesize isNew;
@synthesize parent_View_Controller;
@synthesize relatedNode;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [webBrowserView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]]];

    [self.navigationController setNavigationBarHidden: YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 //   [self.view setUserInteractionEnabled:YES];
    //This function also determines how big, where webview is showing
    //530 = x, 0 = y, 511 and 768 are dimensions
    //CGRect rect=CGRectMake(530, 0, 511, 768);
    CGRect rect=CGRectMake(0, 0, 513, 768);
     [self.view setFrame:rect];

   // CGRect rect=CGRectMake(256, 384, 511, 768);
   // [self.view setFrame:rect];
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 2;
    
    urlId=0;
    [webBrowserView setDelegate:self];
    //[webBrowserView setDelegate:_parentBookPageViewCtr];
    //[webBrowserView becomeFirstResponder];
    webBrowserView.scalesPageToFit=YES;
    [refresh setTarget:self];
    [refresh setAction:@selector(refreshWebPage:)];
    [markPage setTarget:self];
    [markPage setAction:@selector(addWebMark:)];
    [back setTarget:self];
    [back setAction:@selector(backToBook:)];
    

    //Long press gesture
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    longpress.delegate=self;
    [webBrowserView addGestureRecognizer:longpress];
    
    //recognizes first tap
    UITapGestureRecognizer *onetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updatePVPosition:)];
    [onetap setNumberOfTapsRequired:1];
    onetap.delegate=self;
    [webBrowserView addGestureRecognizer:onetap];
    
    self.view.layer.zPosition = MAXFLOAT;
    [webBrowserView setUserInteractionEnabled:YES];

}

-(void) updateBrowserWindow{
    CGRect rect;
    if (_parentBookPageViewCtr.bookView.currentContentView.isSplit == YES){ // split screen
        rect=CGRectMake(0, 0, 513, 768);
        [self.webAdrText setFrame: CGRectMake(200, 7, 255, 30)]; //changes size of webAdrText textfield
    }
    else{ //not split screen
        rect=CGRectMake(0, 0, 768, 1024);
        [self.webAdrText setFrame: CGRectMake(402, 7, 505, 30)]; //changes size of webAdrText textfield
    }
    
      [self.view setFrame:rect];
}

//Allows two gestures to be recognized simultaneously, in this case longpress and onetap------------------------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//actions taken when long press is recognized-----------------------------------------------------------------------
- (void)longpressAction:(UITapGestureRecognizer *)tap
{
    //Become first responder
    [self becomeFirstResponder];
}

//Needed to prevent crashing for gesture recognizer related actions------------------------------------------------
- (void)updatePVPosition:(UITapGestureRecognizer *)tap
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void )webViewDidFinishLoad:(UIWebView *)webView{
    //update the url address text after the webview loads a new web page
    [webAdrText setText:webBrowserView.request.URL.absoluteString];
    
    if (prevUrl != nil){ //A previous Url was set
        if (prevUrl == webBrowserView.request.URL){ //previousUrl is same as current
            return; //this to prevent log files from reporting the same url over and over again
        }
        else {
            //save info in logs
            LogData* log= [[LogData alloc]initWithName:parent_View_Controller.userName SessionID:@"session_id" action:@"Update URL/search web " selection:@"web browser" input:webBrowserView.request.URL.absoluteString pageNum:0];
            [_parentBookPageViewCtr.cmapView.bookLogDataWrapper addLogs:log];
            [LogDataParser saveLogData:_parentBookPageViewCtr.cmapView.bookLogDataWrapper];
            
             prevUrl = webBrowserView.request.URL; //set previous url to current
            return;
        }
    }
    
    prevUrl = webBrowserView.request.URL; //set previous url to current
 
}

//Gives web browser permission to be first responder---------------------------------------------------------
- (BOOL)canBecomeFirstResponder {
    return YES;
}

//give permission to show the menu item we added --------------------------------------------------------------
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    //long press gesture
    if (action == @selector(longpressAction:)){
        return YES;
    }
    return NO;
}

//searches for contents in textfield, goes to url-----------------------------------------------------------
- (IBAction)search_go:(id)sender {
   NSString *url_field_text = [webAdrText text];
   /* NSURL *url = [NSURL URLWithString: url_field_text];
    NSString *schemeString= url.scheme;
    NSString *hostString= url.host;
    if (url && schemeString && hostString){ //if url is valid
        [webBrowserView loadRequest : [NSURLRequest requestWithURL:url]];
    }
    else {
        [self SearchKeyWord: url_field_text];
    }*/
        [self SearchKeyWord: url_field_text];
}



//refresh the web page ----> we no longer have a refresh button -----------------------------------------------------
- (IBAction)refreshWebPage : (id)sender {
    NSString *link= @"https://www.google.com";
    NSURL *new_url = [NSURL URLWithString:link];
    NSURLRequest *new_requestObj = [NSURLRequest requestWithURL:new_url];
    [webBrowserView loadRequest:new_requestObj];
}

//go back to book view--------------------------------------------------------------------------------------
- (IBAction)backToBook : (id)sender {
   // [self.navigationController popViewControllerAnimated:YES ];
        [_parentBookPageViewCtr hideWebView];
}



//Sets relatedNode to parameter. This is so we know where to send url info ------------------------------------
-(void)setRelatedNode:(NodeCell *)givenNode{
    if (givenNode != nil){
        relatedNode = givenNode;
    }
    else {
        NSLog (@"Problem in Web Browser, setRelatedNode");
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}


//Searches for selected string in Google or Wikipedia --------------------------------------------------------
-(void)SearchKeyWord: (NSString*) keywrod{
    NSString* searchTerm = @"";
 //   NSLog(@"Keyword = %@", keywrod);
    if (keywrod != nil){ // Keyword contains a string
        NSURL *potentialUrl = [NSURL URLWithString: keywrod];
        NSString *schemeString= potentialUrl.scheme;
        NSString *hostString= potentialUrl.host;
        if (potentialUrl && schemeString && hostString){ //if url is valid
         //   NSLog(@"Keyword is valid url %@", potentialUrl);
            //go to url
            [webBrowserView loadRequest : [NSURLRequest requestWithURL:potentialUrl]];
            //save info in logs
            LogData* log= [[LogData alloc]initWithName:parent_View_Controller.userName SessionID:@"session_id" action:@"searching key word on web browser " selection:@"web browser" input:potentialUrl.absoluteString pageNum:0];
            [_parentBookPageViewCtr.cmapView.bookLogDataWrapper addLogs:log];
            [LogDataParser saveLogData:_parentBookPageViewCtr.cmapView.bookLogDataWrapper];
            return;
        }
        else {
            searchTerm = [keywrod stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"\"" withString: @"%22"];
            searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"%" withString: @"%25"];
            searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@":" withString: @"%3A%20"];
        }
        
    }

    //For Google
    NSString* urlStr=@"https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=";
    urlStr=[urlStr stringByAppendingString:searchTerm];
   // NSString *encodedUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webBrowserView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    //save info in logs
    LogData* log= [[LogData alloc]initWithName:parent_View_Controller.userName SessionID:@"session_id" action:@"searching key word on web browser " selection:@"web browser" input:searchTerm pageNum:0];
    [_parentBookPageViewCtr.cmapView.bookLogDataWrapper addLogs:log];
    [LogDataParser saveLogData:_parentBookPageViewCtr.cmapView.bookLogDataWrapper];
    
    //For Wikipedia
    /*NSString* wikiSearchToken = @"&searchToken";
    NSString* urlStrWiki= @"https://en.wikipedia.org/w/index.php?title=Special%3ASearch&profile=default&fulltext=Search&search=";
    urlStrWiki=[urlStrWiki stringByAppendingString:searchTerm];
    urlStrWiki=[urlStrWiki stringByAppendingString:wikiSearchToken];
    [webBrowserView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStrWiki]]];
    */
}



@end
