//
//  MyAlertView.m
//  TurkStudy
//
//  Created by Shang Wang on 2/24/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    //if (buttonIndex should not dismiss the alert)
        return;
    //[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}
@end
