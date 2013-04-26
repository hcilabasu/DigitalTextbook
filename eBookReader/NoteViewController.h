//
//  NoteViewController.h
//  eBookReader
//
//  Created by Shang Wang on 4/19/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"

@interface NoteViewController : UIViewController <UIGestureRecognizerDelegate,PopoverViewDelegate>{
    PopoverView *pv; //popOver view
    CGPoint pvPoint;// position where pop over view shows
    CGPoint notePoint;// position where the noteImage shows on teh side of the page
}
@property (nonatomic)BOOL isExist;
@property (strong, nonatomic) NSString *note_text;
@property (strong, nonatomic) IBOutlet UIImageView *noteImage;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneFingerTap;
@property (nonatomic) CGPoint pvPoint;
- (CGSize) screenSize;
@end
