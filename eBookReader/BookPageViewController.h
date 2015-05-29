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
#import "QAViewController.h"
@class LogDataWrapper;
@interface BookPageViewController : UIViewController <DBRestClientDelegate>
@property (strong, nonatomic) CmapController *cmapView;
@property (strong, nonatomic) BookViewController *bookView;
@property (strong, nonatomic)  QAViewController *QA;
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, retain)LogDataWrapper * logWrapper;
@property(strong,nonatomic) UIImageView *bulbImageView;
@property BOOL ShowingQA;

-(void)test;
-(void)upLoadLogFile;
-(void)upLoadCmap;
- (IBAction)clickOnBulb : (id)sender;
- (IBAction)QAonConcpet;
@end
