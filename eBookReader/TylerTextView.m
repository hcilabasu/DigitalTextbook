//
//  TylerTextView.m
//  Digital Textbook
//
//  Created by Lab User on 8/30/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//
//
//TylerTextView is a custom UITextView such that we can adjust the gesture recognizer behavior from default
//

#import "TylerTextView.h"

@implementation TylerTextView
@synthesize enableRecognizer;
@synthesize disableEditting;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization cod
    }
    return self;
}


/*
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 if(disableEditting){
 return NO;
 }else{
 return NO;
 }
 }
 */



- (void)textFieldDidEndEditing:(UITextView *)textView{
    NSLog(@"Finish editing..");
    
}

//function needed to distinguish it from default textview
- (BOOL) isTylerTextView{
    return YES;
}

//This is the important part, changes gesture recognition of default TextView
-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        gestureRecognizer.enabled = self.enableRecognizer;
        
    }
    
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        gestureRecognizer.enabled = self.enableRecognizer;
    }
    
    [super addGestureRecognizer:gestureRecognizer];
    return;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
