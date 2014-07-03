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
@interface BookPageViewController : UIViewController
@property (strong, nonatomic) CmapController *cmapView;
@property (strong, nonatomic) BookViewController *bookView;
-(void)test;
@end
