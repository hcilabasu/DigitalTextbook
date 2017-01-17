//
//  TrainingViewController.h
//  TurkStudy
//
//  Created by Shang Wang on 3/14/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CmapController.h"
#import "EBookImporter.h"
#import "UIMenuItem+CXAImageSupport.h"
@interface TrainingViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) CmapController *cmapView;
@property (nonatomic, strong) NSString *bookTitle;
@property (strong, nonatomic) IBOutlet UIWebView *mywebView;
@property (nonatomic, strong) EBookImporter *bookImporter;
@property (strong, nonatomic)  UILabel *webFocusQuestionLable;
@property (strong, nonatomic)  UILabel *cmapFocusQuestionLable;
@property (strong, nonatomic)  UIImageView *hintImg;
-(void)showAlertWithString: (NSString*) str;
-(void)createDeleteTraining;


@end
