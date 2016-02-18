//
//  NodeViewController.h
//  eBookReader
//
//  Created by Shang Wang on 9/30/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShangTextField.h"
@class ContentViewController;
@interface NodeViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet ShangTextField *text;
@property (strong, nonatomic) ContentViewController* parentController;
@property BOOL isSubNode;
@end
