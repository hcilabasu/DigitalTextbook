//
//  ContentViewController.h
//  eBookReader
//
//  Created by Shang Wang on 3/19/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "BookViewController.h"
#import "iFlyMSC/IFlySynthesizerControl.h"
#import "PopoverView.h"
#ifndef CONTENTVIEWCONTROLLER_H
#define CONTENTVIEWCONTROLLER_H



@interface ContentViewController : UIViewController<IFlySynthesizerControlDelegate, PopoverViewDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
{
    PopoverView *pv; //popOver view
    CGPoint pvPoint;// position where pop over view shows
    IFlySynthesizerControl			*_iFlySynthesizerControl; //voice to text synthesizer
   // int pageNum;
    //int totalpageNum;
}
#endif


@property (strong, nonatomic) IBOutlet UIWebView *webView; // the webview which displays the content
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneFingerTap; //gesture recognizer
@property (strong, nonatomic) id dataObject;// sotres the HTML data
@property (strong, nonatomic) id url; //the URL link to display HTML content
@property (nonatomic) BOOL isMenuShow;
@property (nonatomic, retain) IBOutlet UILabel *currentPageLabel; //indicates the current page number
@property (nonatomic) int pageNum;
@property (nonatomic) int totalpageNum;


-(void)setingUpMenuItem;
-(void)refresh;
-(void)createWebNote : (NSURLRequest*) urlrequest;
-(void)createNote : (CGPoint) show_at_point NoteText:(NSString*) m_note_text;
-(void)printNull;
@end