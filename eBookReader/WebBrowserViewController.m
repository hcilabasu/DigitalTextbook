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
    CGRect rect=CGRectMake(530, 0, 511, 768);
    [self.view setFrame:rect];
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 2;

    urlId=0;
    [webBrowserView setDelegate:self];
   // [webBrowserView becomeFirstResponder];
    webBrowserView.scalesPageToFit=YES;
    [refresh setTarget:self];
    [refresh setAction:@selector(refreshWebPage:)];
    [markPage setTarget:self];
    [markPage setAction:@selector(addWebMark:)];
    [back setTarget:self];
    [back setAction:@selector(backToBook:)];
    
    
    /*
    UIMenuController *menuController = [UIMenuController sharedMenuController];
        CXAMenuItemSettings *markIconSettingSpeak = [CXAMenuItemSettings new];
    markIconSettingSpeak.image = [UIImage imageNamed:@"question"];
    markIconSettingSpeak.shadowDisabled = NO;
    markIconSettingSpeak.shrinkWidth = 4; //set menu item size and picture.
    UIMenuItem *speakItem = [[UIMenuItem alloc] initWithTitle: @"speak" action: @selector(bookMark:)];
    [speakItem cxa_setSettings:markIconSettingSpeak];
    [menuController setMenuItems: [NSArray arrayWithObjects: speakItem, nil]];
*/
    /*
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    longpress.delegate=self;
    [webBrowserView addGestureRecognizer:longpress];*/
     
}


- (void)longpressAction:(UITapGestureRecognizer *)tap
{
    NSString *selection = [webBrowserView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    [self becomeFirstResponder];
    // UIMenuController *menuController = [UIMenuController sharedMenuController];
    // [menuController setMenuVisible:YES animated:YES];
    
    
    
}

- (void)bookMark:(id)sender{
    
    
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

//give permission to show the menu item we added
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(bookMark:)
        ||action == @selector(refreshWebPage:)
        ||action==@selector(addWebMark:)
        ||action==@selector(backToBook:))
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

//refresh the web page
- (IBAction)refreshWebPage : (id)sender {
    NSString *link= @"https://www.google.com";
    NSURL *new_url = [NSURL URLWithString:link];
    NSURLRequest *new_requestObj = [NSURLRequest requestWithURL:new_url];
    [webBrowserView loadRequest:new_requestObj];
}

//go back to book view
- (IBAction)backToBook : (id)sender {
    [self.navigationController popViewControllerAnimated:YES ];
}

//add a web page icon at the content view controller
- (IBAction)addWebMark : (id)sender {
    [_parentBookPageViewCtr hideWebView];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);

}



-(void)SearchKeyWord: (NSString*) keywrod{
    NSString* urlStr=@"https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=";
    urlStr=[urlStr stringByAppendingString:keywrod];
    [webBrowserView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}





@end
