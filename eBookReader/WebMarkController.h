//
//  WebMarkController.h
//  eBookReader
//
//  Created by Shang Wang on 4/22/13.
//  Controls the 
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

@property (strong, nonatomic)NSURLRequest *web_requestObj;// web link
@property (strong, nonatomic) IBOutlet UIImageView *markImage;// web icon image
@property (strong, nonatomic) UITapGestureRecognizer *oneFingerTap; //one finger tap recognizer
@property (nonatomic) CGPoint pvPoint;//the point where the web icon should locate
@property (nonatomic) CGPoint iconPoint;//where the thumbnail icon shows
@property (strong, nonatomic) ContentViewController *parentController;
- (CGSize) screenSize;
@end
