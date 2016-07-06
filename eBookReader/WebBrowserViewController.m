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
    //This function also determines how big, where webview is showing
    //530 = x, 0 = y, 511 and 768 are dimensions
    CGRect rect=CGRectMake(530, 0, 511, 768);
   // CGRect rect=CGRectMake(256, 384, 511, 768);
    [self.view setFrame:rect];
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
    

    /*
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    longpress.delegate=self;
    [webBrowserView addGestureRecognizer:longpress];*/
  /*
    //get the shared menubar.
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    //create a menu item
    CXAMenuItemSettings *markIconSettingSpeak = [CXAMenuItemSettings new];
    markIconSettingSpeak.image = [UIImage imageNamed:@"bb"];
    markIconSettingSpeak.shadowDisabled = NO;
    markIconSettingSpeak.shrinkWidth = 4; //set menu item size and picture.
    //set up the function called when user click the button
    UIMenuItem *speakItem = [[UIMenuItem alloc] initWithTitle: @"speak" action: @selector(bookMark:)];
    [speakItem cxa_setSettings:markIconSettingSpeak];
    //add the menu item to the menubar.
    [menuController setMenuItems: [NSArray arrayWithObjects: speakItem, nil]];

*/     self.view.layer.zPosition = MAXFLOAT;
    [webBrowserView setUserInteractionEnabled:YES];

}

- (void)longpressAction:(UITapGestureRecognizer *)tap
{
    NSString *selection = [webBrowserView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    pvPoint = [tap locationInView:self.view];
    [self becomeFirstResponder];
    // UIMenuController *menuController = [UIMenuController sharedMenuController];
    // [menuController setMenuVisible:YES animated:YES];
}


//Deceptive name, see addWebMark. This is for adding a concept from a string in the web browser.-----------------------------------------------
- (void)bookMark:(id)sender{

    NSLog (@"Code reaches WebBrowser Bookmark");
    NSString * strJS = @"window.getSelection().toString()";
    NSString * strSelectedText = [self.webBrowserView stringByEvaluatingJavaScriptFromString:strJS];
    NSLog(@"strSelectedText = %@", strSelectedText );
    
    if([_parentBookPageViewCtr.cmapView isNodeExist:strSelectedText]){
        NSString *msg=[[NSString alloc]initWithFormat:@"Node with name \"%@\" already exist!",strSelectedText];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [_parentBookPageViewCtr.cmapView createNodeFromBook:CGPointMake( arc4random() % 400+30, 690) withName:strSelectedText BookPos:pvPoint page:0];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void )webViewDidFinishLoad:(UIWebView *)webView{
    //update the url address text after the webview loads a new web page
    [webAdrText setText:webBrowserView.request.URL.absoluteString];
 
}

//Gives web browser permission to be first responder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

//give permission to show the menu item we added ------------------------------------------------------------------------------------------
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(bookMark:)
        ||action == @selector(search_go:)
        ||action==@selector(addWebMark:)
        ||action==@selector(backToBook:))
    {
        return NO;
    }
    if (action == @selector(copy:) || action == @selector(cut:) || action == @selector(delete:) ||
        action == @selector(paste:) || action == @selector(select:) || action == @selector(selectAll:)) {
        return NO;
    }
    if (action == @selector(define:))
    {
        return NO;
    }
    return NO;
}

//searches for contents in textfield, goes to url------------------------------------------------------------------------------------------
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



//refresh the web page ----> we no longer have a refresh button ----------------------------------------------------------------------------
- (IBAction)refreshWebPage : (id)sender {
    NSString *link= @"https://www.google.com";
    NSURL *new_url = [NSURL URLWithString:link];
    NSURLRequest *new_requestObj = [NSURLRequest requestWithURL:new_url];
    [webBrowserView loadRequest:new_requestObj];
}

//go back to book view----------------------------------------------------------------------------------------------------------------------
- (IBAction)backToBook : (id)sender {
   // [self.navigationController popViewControllerAnimated:YES ];
        [_parentBookPageViewCtr hideWebView];
}


//Saves the current url as a bookmark, this function sts up the uiactionsheet----------------------------------------------------------------
- (IBAction)addWebMark : (id)sender {
    
    UIActionSheet *bookmarkActionSheet = [[UIActionSheet alloc] initWithTitle:[[[[self webBrowserView]request] URL] absoluteString]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Favorites", @"View Favorites", nil];
    
    bookmarkActionSheet.tag = 100; //tag value distinguishes this from other potential action sheets
    [bookmarkActionSheet showInView:self.view];

   // [_parentBookPageViewCtr hideWebView];
    
  }

//Decides the actions taken for action sheets ----------------------------------------------------------------------------------------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100){ //bookmarkActionSheet
        if (buttonIndex == 0) { //top button 'Save to Favorites' has been pressed
            if (relatedNode != nil){ // relatedNode exists
                relatedNode.enterIntoUrlArray;
                UIAlertView *bookmarkAlert = [[UIAlertView alloc] initWithTitle:@"URL SAVED"
                                                                        message:@"The current url has been saved!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                [bookmarkAlert show];
            }
            else {
                NSLog (@"Problem in Web Browser, addWebMark");
            }
            
        }
        else if (buttonIndex == 1){ //second from top button 'View Favorite' has been pressed
            
        }
    }//if bookmarkActionSheet

}

//Sets relatedNode to parameter. This is so we know where to send url info ------------------------------------------------------------------
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


//Searches for selected string in Google or Wikipedia ---------------------------------------------------------------------------------------
-(void)SearchKeyWord: (NSString*) keywrod{
    NSString* searchTerm = @"";
 //   NSLog(@"Keyword = %@", keywrod);
    if (keywrod != nil){ // Keyword contains a string
        NSURL *potentialUrl = [NSURL URLWithString: keywrod];
        NSString *schemeString= potentialUrl.scheme;
        NSString *hostString= potentialUrl.host;
        if (potentialUrl && schemeString && hostString){ //if url is valid
         //   NSLog(@"Keyword is valid url %@", potentialUrl);
            [webBrowserView loadRequest : [NSURLRequest requestWithURL:potentialUrl]];
            return;
        }
        else {
            searchTerm = [keywrod stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        }
        
    }

    //For Google
    NSString* urlStr=@"https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=";
    urlStr=[urlStr stringByAppendingString:searchTerm];
    [webBrowserView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    //For Wikipedia
    /*NSString* wikiSearchToken = @"&searchToken";
    NSString* urlStrWiki= @"https://en.wikipedia.org/w/index.php?title=Special%3ASearch&profile=default&fulltext=Search&search=";
    urlStrWiki=[urlStrWiki stringByAppendingString:searchTerm];
    urlStrWiki=[urlStrWiki stringByAppendingString:wikiSearchToken];
    [webBrowserView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStrWiki]]];
    */
}



@end
