//
//  MapFinderViewController.h
//  eBookReader
//
//  Created by Shang Wang on 8/13/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogDataWrapper.h"
@class CmapController;
@class TrainingViewController;
@class BookPageViewController;
@interface MapFinderViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* fileList;
@property (strong, nonatomic) CmapController* parentCmapController;
@property (nonatomic, retain) LogDataWrapper* bookLogData;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) TrainingViewController* parentTrainingCtr;
@property (strong, nonatomic) BookPageViewController* parentBookPageView;

@end
