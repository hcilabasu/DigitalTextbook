//
//  WebBrowserViewController.m
//  eBookReader
//
//  Created by Shang Wang on 4/16/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "WebBrowserViewController.h"


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
@synthesize parent_View_Controller;
@synthesize pvPoint;
@synthesize isNew;

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
    [webBrowserView loadRequest:requestObj];
    //[urlStack addObject:webBrowserView.request];
    [self.navigationController setNavigationBarHidden: YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    urlId=0;
    [webBrowserView setDelegate:self];
    webBrowserView.scalesPageToFit=YES;
    [refresh setTarget:self];
    [refresh setAction:@selector(refreshWebPage:)];
    [markPage setTarget:self];
    [markPage setAction:@selector(addWebMark:)];
    [back setTarget:self];
    [back setAction:@selector(backToBook:)];
     
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

//refresh the web page
- (IBAction)refreshWebPage : (id)sender {
    NSString *link= webAdrText.text;
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
  //  if(isNew){
    [parent_View_Controller createWebNote: pvPoint
                                      URL: requestObj isWriteToFile:YES isNewIcon:YES];
    //}
   [self.navigationController popViewControllerAnimated:YES ];
}


- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(refreshWebPage:)
        ||action==@selector(addWebMark:)
        ||action==@selector(backToBook:))
    {
        return YES;
    }
    return NO;
}

@end
