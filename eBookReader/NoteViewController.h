//
//  NoteViewController.h
//  eBookReader
//
//  Created by Shang Wang on 4/19/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"
#import "ContentViewController.h"

@interface NoteViewController : UIViewController <UIGestureRecognizerDelegate,PopoverViewDelegate>{
    PopoverView *pv; //popOver view
    CGPoint notePoint;// position where the noteImage shows on teh side of the page
}
@property (nonatomic)BOOL isExist;
@property (strong, nonatomic) NSString *note_text;//stroe the text of the note
@property (strong, nonatomic) IBOutlet UIImageView *noteImage; //the note icon iamge
@property (strong, nonatomic) UITapGestureRecognizer *oneFingerTap; //the one finger gesture recognizer that captures user's click
@property (nonatomic) CGPoint pvPoint;//the point where the popup note is originally evoked
@property (nonatomic) CGPoint iconPoint;//where the thumbnail icon shows
@property (strong, nonatomic) ContentViewController *parentController; //stores the reference of the parent view controller
- (CGSize) screenSize;// function that returns the size of the screen, used to deteremine where the icon and the popup view is shown.
- (void)updateText:(NSString *)new_text;
@end
