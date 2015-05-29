//
//  QAFinderViewController.h
//  eBookReader
//
//  Created by Shang Wang on 5/21/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QAViewController;
@class CmapController;
@interface QAFinderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* fileList;
@property (strong, nonatomic) QAViewController* parentQA;
@property (strong, nonatomic) CmapController* parentCmap;
@end
