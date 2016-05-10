//
//  VideoViewController.h
//  TurkStudy
//
//  Created by Shang Wang on 11/8/15.
//  Copyright © 2015 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBookImporter.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"
@class BookPageViewController;
@interface VideoViewController : UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate >
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *teachImg;
@property (weak, nonatomic) BookPageViewController* parentBookCtr;
@property BOOL hideImg;
@property (nonatomic, strong) EBookImporter *bookImporter;
@property (nonatomic, strong) NSString *bookTitle;
@property NSTimeInterval totalCountdownInterval;
@property NSTimeInterval remainTime;
@property NSDate* startDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLable;
@property (nonatomic, retain)LogDataWrapper * logWrapper;

-(void)startTimer;
@end
