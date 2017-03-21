//
//  ConceptView.h
//  eBookReader
//
//  Created by Shang Wang on 4/15/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConceptIconTextField.h"
#import "PopoverView.h"
@class ContentViewController;
@interface ConceptViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ConceptIconTextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *noteImage; //the note icon iamge
@property (strong, nonatomic) UITapGestureRecognizer *oneFingerTap; //the one finger gesture recognizer that captures user's click
@property (nonatomic) CGPoint pvPoint;//the point where the popup note is originally evoked
@property (nonatomic) CGPoint iconPoint;//where the thumbnail icon shows
@property (strong, nonatomic) ContentViewController *parentController; //stores the reference of the parent view controller


@end
