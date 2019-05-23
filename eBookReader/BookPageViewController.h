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
#import "UIMenuItem+CXAImageSupport.h"
#import "WebBrowserViewController.h"
#import "UIButton+Bootstrap.h"
#import "ExpertModel.h"
#import "QuartzCore/QuartzCore.h"
#import "MapFinderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KeyConcept.h"
@class LogDataWrapper;
@interface BookPageViewController : UIViewController <DBRestClientDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIWebViewDelegate>
@property (strong, nonatomic) CmapController *cmapView;
@property (strong, nonatomic) VideoViewController *videoView;
@property (strong, nonatomic) BookViewController *bookView;
@property (strong, nonatomic)  QAViewController *QA;
@property (strong, nonatomic) MapFinderViewController* linkNameFinder;
@property (strong, nonatomic) BookViewController *secondBookView;
@property (strong, nonatomic) UIView* overlayView;

@property (strong, nonatomic)  WebBrowserViewController *myWebView;
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, retain)LogDataWrapper * logWrapper;
@property (strong,nonatomic) UIImageView *bulbImageView;
@property (strong,nonatomic) NSString* userName;
@property BOOL ShowingQA;
@property BOOL isTraining;
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
@property int subViewType; //0:contentview 1:web brower view
@property (strong, nonatomic)  UILabel *webFocusQuestionLable;
@property (strong, nonatomic)  UILabel *cmapFocusQuestionLable;
@property (strong, nonatomic)  UIImageView *hintImg;
@property (strong, nonatomic) UIButton *compareTitleButton;
@property ExpertModel* expertModel;
@property (strong, nonatomic) UIButton *compareViewReturnButton;

@property (strong, nonatomic) UIView *HLrectLeft;
@property (strong, nonatomic) UIView *HLrectRight;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
-(void)showAlertWithString: (NSString*) str : (UIView*)imgView;
-(void)createDeleteTraining;
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
-(void)showWebhint;
-(void)showLinkingHint;
-(void)showFlipPageHint;
-(void)showAlertWithText: (NSString*) str;
-(void)showLinkingWarning;
-(void)hideLinkingWarning;
-(void)showWebView: (NSString*)conceptName atNode: (NodeCell*) relatedNode;
-(void)hideWebView;
-(void)createSecondBookView;
-(void)showSecondBookView;
-(void)showOverlay;
-(void)hideOverlay;
-(void)showLeftHLRect: (KeyConcept*) kc;
-(void)showRightHLRect: (KeyConcept*) kc;
-(void)showLinkNameFinder;
-(void)HideHighlightRects;
@end

