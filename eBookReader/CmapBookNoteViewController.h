//
//  CmapBookNoteViewController.h
//  eBookReader
//
//  Created by Shang Wang on 6/4/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentViewController;
@interface CmapBookNoteViewController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic, retain) ContentViewController *parentContentView;
@end
