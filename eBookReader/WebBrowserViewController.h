//
//  WebBrowserViewController.h
//  eBookReader
//
//  Created by Shang Wang on 4/16/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebMarkController.h"
#import "ContentViewController.h"


@interface WebBrowserViewController : UIViewController <UIWebViewDelegate>{
  // ContentViewController *parent_View;

}


@property (nonatomic, strong) IBOutlet UIWebView *webBrowserView;
@property (strong, nonatomic)  NSURL *url;//the URL link to display HTML content
@property (strong, nonatomic)  NSURLRequest *requestObj;

@property (nonatomic, strong)  ContentViewController *parent_View_Controller;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *next;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *pre;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *webAdr;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *serchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *back;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *markPage;
@property (strong, nonatomic) IBOutlet UITextField *webAdrText;
@property (strong, nonatomic) NSMutableArray *urlStack;//stack that stores the web url history
@property (nonatomic) CGPoint pvPoint;//the point where the popup note is originally evoked
@property  (nonatomic) int urlId;
-(void)setParent_View:(ContentViewController *)view;
@end

