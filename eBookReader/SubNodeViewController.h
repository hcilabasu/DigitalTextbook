//
//  SubNodeViewController.h
//  eBookReader
//
//  Created by Shang Wang on 10/1/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShangTextField.h"
@class ContentViewController;
@class BookViewController;
@interface SubNodeViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet ShangTextField *text;
@property (strong, nonatomic) ContentViewController* parentController;
@property (strong, nonatomic) BookViewController* parentBookViewController;
@end
