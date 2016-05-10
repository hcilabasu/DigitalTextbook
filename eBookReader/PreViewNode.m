//
//  PreViewNode.m
//  eBookReader
//
//  Created by Shang Wang on 10/6/15.
//  Copyright (c) 2015 Shang Wang. All rights reserved.
//

#import "PreViewNode.h"

@interface PreViewNode ()

@end

@implementation PreViewNode
@synthesize name;
@synthesize ParentPreView;
@synthesize img;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor clearColor];
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createLink: (PreViewNode*)cellToLink name: (NSString*)relationName{
    if(!cellToLink){
        return;
    }
    
    CAShapeLayer* layer=layer = [CAShapeLayer layer];
    CGPoint p1=self.view.center;
    p1.x+=10;
    p1.y+=10;
    CGPoint p2=cellToLink.view.center;
    p2.x+=10;
    p2.y+=10;
    [self addLine:p1 Point2:p2 Layer:layer ];
   
}

- (void)addLine:(CGPoint)p1 Point2: (CGPoint)p2 Layer: (CAShapeLayer*) layer {
    layer.strokeColor = [[UIColor grayColor] CGColor];
    layer.lineWidth = 0.5;
    layer.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    layer.path = [path CGPath];
    [ParentPreView.layer insertSublayer:layer atIndex:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
