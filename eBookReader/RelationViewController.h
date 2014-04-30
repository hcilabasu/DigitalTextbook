//
//  RelationViewController.h
//  eBookReader
//
//  Created by Shang Wang on 3/17/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeCell.h"
@interface RelationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *text;
@property (strong, nonatomic)NodeCell* parent;
@property (strong, nonatomic)NodeCell* child;

@end
