//
//  ConceptIconTextField.m
//  eBookReader
//
//  Created by Shang Wang on 4/15/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "ConceptIconTextField.h"

@implementation ConceptIconTextField
@synthesize enableRecognizer;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
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
