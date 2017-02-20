//
//  MyTouch.h
//  TurkStudy
//
//  Created by Shang Wang on 2/14/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//
// UITouch (Synthesize)
//
// Category to allow creation and modification of UITouch objects.
//
@interface UITouch (Synthesize)

- (id)initInView:(UIView *)view;
- (void)setPhase:(UITouchPhase)phase;
- (void)setLocationInWindow:(CGPoint)location;
@end

//
// UIEvent (Synthesize)
//
// A category to allow creation of a touch event.
//
@interface UIEvent (Synthesize)

- (id)initWithTouch:(UITouch *)touch;

@end
