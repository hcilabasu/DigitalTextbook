//
//  PreViewNode.h
//  eBookReader
//
//  Created by Shang Wang on 10/6/15.
//  Copyright (c) 2015 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreViewNode : UIViewController
@property NSString* name;
@property UIView* ParentPreView;
@property (weak, nonatomic) IBOutlet UIImageView *img;

-(void)createLink: (PreViewNode*)cellToLink name: (NSString*)relationName;
@end
