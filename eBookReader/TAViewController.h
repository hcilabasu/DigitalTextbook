//
//  TAViewController.h
//  Study
//
//  Created by Shang Wang on 2/6/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CmapController;
@interface TAViewController : UIViewController <UIGestureRecognizerDelegate>
@property CmapController* parentCmapController;
@end

NS_ASSUME_NONNULL_END
