//
//  ZYQSphereView.h
//  SphereViewSample
//
//  Created by Zhao Yiqi on 13-12-8.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import "PFAxisDirection.h"

@interface ZYQSphereView : UIView {
	NSMutableDictionary *pointMap; 
	
	CGPoint originalLocationInView;
	CGPoint previousLocationInView;
	
	PFAxisDirection lastXAxisDirection;
	PFAxisDirection lastYAxisDirection;
	
	CGRect originalSphereViewBounds;
}

@property(nonatomic,assign)BOOL isPanTimerStart;
@property(nonatomic,getter = isTimerStart,readonly)BOOL isTimerStart;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) CAShapeLayer *shapeLayer2;

@property (strong, nonatomic) NSMutableArray*  linkArray;

- (void)setItems:(NSArray *)items;

-(void)timerStart;

-(void)timerStop;

@end
