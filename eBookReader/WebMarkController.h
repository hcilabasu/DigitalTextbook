//
//  WebMarkController.h
//  eBookReader
//
//  Created by Shang Wang on 4/22/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"
@interface WebMarkController : UIViewController<UIGestureRecognizerDelegate>
{
    PopoverView *pv; //popOver view
    CGPoint pvPoint;// position where pop over view shows
    CGPoint notePoint;// position where the noteImage shows on teh side of the page
}

@property (strong, nonatomic)NSURLRequest *web_requestObj;
@property (strong, nonatomic) IBOutlet UIImageView *markImage;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneFingerTap;
- (CGSize) screenSize;
@end
