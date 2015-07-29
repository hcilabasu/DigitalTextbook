//
//  LogInViewController.h
//  eBookReader
//
//  Created by Shang Wang on 7/25/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryViewController.h"
@interface LogInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextView;

@property (weak, nonatomic) IBOutlet UIImageView *BG;

@end
