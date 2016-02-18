//
//  ShangTextField.m
//  eBookReader
//
//  Created by Shang Wang on 4/3/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "ShangTextField.h"

@implementation ShangTextField
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



- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Finish editting..");

}


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
