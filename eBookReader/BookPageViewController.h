//
//  BookPageViewController.h
//  eBookReader
//
//  Created by Shang Wang on 6/19/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CmapController.h"
#import "BookViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "VideoViewController.h"
#import "QAViewController.h"
#import "DTAlertView.h"
@class LogDataWrapper;
@interface BookPageViewController : UIViewController <DBRestClientDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) CmapController *cmapView;
@property (strong, nonatomic) VideoViewController *videoView;
@property (strong, nonatomic) BookViewController *bookView;
@property (strong, nonatomic)  QAViewController *QA;
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, retain)LogDataWrapper * logWrapper;
@property (strong,nonatomic) UIImageView *bulbImageView;
@property (strong,nonatomic) NSString* userName;
@property BOOL ShowingQA;
@property BOOL enableHyperLink;
@property NSTimeInterval totalCountdownInterval; 
@property NSTimeInterval remainTime;
@property NSDate* startDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLable;
@property (weak, nonatomic) IBOutlet UIView *previewImg;
@property (strong, nonatomic)  UIView *PreviewRect;
@property CGRect originalFrame;
@property CALayer *upperBorder;
@property BOOL isShowPreView;
@property (strong, nonatomic) NSMutableArray*  conceptNodeArray;
@property BOOL isSecondShow;
@property NSTimer* CmapTimer;
-(void)test;
-(void)upLoadLogFile;
-(void)upLoadCmap;
- (IBAction)clickOnBulb : (id)sender;
- (IBAction)QAonConcpet;
-(void)startTimer;
-(void)addConceptMapPreview:(NSMutableArray*)nodeArray Links: (NSMutableArray*)linkArray CMapFrame: (CGRect)frame;
-(void)hideAndShowPreView;
-(void)startCmapTimer;
-(void)addTutorial;
-(void)showAdminPsdAlert;
@end


