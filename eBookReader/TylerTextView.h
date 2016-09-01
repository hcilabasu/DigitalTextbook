//
//  TylerTextView.h
//  Digital Textbook
//
//  Created by Lab User on 8/30/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//
//
//TylerTextView is a custom UITextView such that we can adjust the gesture recognizer behavior from default
//
#import <UIKit/UIKit.h>

@interface TylerTextView : UITextView <UITextViewDelegate>
@property BOOL enableRecognizer;
@property BOOL disableEditting;

@end


