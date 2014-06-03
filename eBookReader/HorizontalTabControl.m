//
//  HorizontalTab.m
//  LSTabs
//
//  Created by Marco Mussini on 22/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "HorizontalTabControl.h"
#import "LSTabControl_Protected.h"
#import "BadgeView.h"

#import "UIView+Addictions.h"



@implementation HorizontalTabControl


#pragma mark -
#pragma mark Accessors

- (UIView *)badgeView {
    if (badgeView == nil) {
        badgeView = [[BadgeView alloc] init];
        badgeView.backgroundColor = [UIColor clearColor];
        ((BadgeView *)badgeView).badgeColor = [UIColor colorWithRed:1.0f green:0.1f blue:0.1f alpha:0.7f];
    }
    
    return badgeView;
}


#pragma mark -

- (CGSize)sizeThatFits:(CGSize)size {
    // Force to the image size
    return CGSizeMake(200.0f, 42.0f);
}


- (void)layoutSubviews { 
    [super layoutSubviews];

	// Relocate the badge view to fit the background image
    if (CGRectIsEmpty(self.frame) == NO)
        badgeView.frame = CGRectMake(self.viewWidth - badgeView.viewWidth -35.0f, -(badgeView.viewHeight/2) + 14.0f,
                                     badgeView.viewWidth, badgeView.viewHeight);
}


#pragma mark -
#pragma mark Protected methods

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [newButton setTitle:title forState:UIControlStateNormal];
    
    newButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:13.0f];
    newButton.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 40.0f, 5.0f, 40.0f);
    newButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [newButton setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:45.0f/255.0f blue:36.0f/255.0f alpha:1.0f] 
                    forState:UIControlStateNormal];
    [newButton setTitleShadowColor:[UIColor clearColor]
                          forState:UIControlStateNormal];
    [newButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.7f]
                          forState:UIControlStateSelected];
    
    [newButton setBackgroundImage:[UIImage imageNamed:@"TabSelected"]
                         forState:UIControlStateHighlighted];
    [newButton setBackgroundImage:[UIImage imageNamed:@"TabSelected"]
                         forState:UIControlStateSelected ];
    if( [title isEqualToString:@"BookMarks"]){
    [newButton setBackgroundImage:[UIImage imageNamed:@"TabNormal_red"]
                         forState:UIControlStateNormal];
    }else if( [title isEqualToString:@"WebLinks"]){
        [newButton setBackgroundImage:[UIImage imageNamed:@"TabNormal_green"]
                             forState:UIControlStateNormal];
    }
    else if( [title isEqualToString:@"Notes"]){
        [newButton setBackgroundImage:[UIImage imageNamed:@"TabNormal_skyBlue"]
                             forState:UIControlStateNormal];
        
    }else if( [title isEqualToString:@"Q&A"]){
        [newButton setBackgroundImage:[UIImage imageNamed:@"TabNormal_purple"]
                             forState:UIControlStateNormal];
    }else{
        [newButton setBackgroundImage:[UIImage imageNamed:@"TabNormal"]
                             forState:UIControlStateNormal];
    }
    return newButton;
}


@end
