//
//  NodeViewController.m
//  eBookReader
//
//  Created by Shang Wang on 9/30/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "NodeViewController.h"
#import <ContentViewController.h>
@interface NodeViewController ()

@end

@implementation NodeViewController
@synthesize text;
@synthesize parentController;
@synthesize isSubNode;
- (void)viewDidLoad {
    [super viewDidLoad];
    if(isSubNode){
        self.view.autoresizesSubviews = NO;
        CGRect newFrame = self.view.frame;
        
        newFrame.size.width = 48;
        newFrame.size.height = 10;
        [self.view setFrame:newFrame];
        [text setFrame:newFrame];
        text.backgroundColor=[UIColor colorWithRed:218.0/255.0 green:232.0/255.0 blue:240.0/255.0 alpha:1];;
        
     //   [self.view setFrame:CGRectMake(self.view.frame.origin.x+15, self.view.frame.origin.y+30, 59, 15)];
        
    }
    
    text.textAlignment = NSTextAlignmentCenter;
    //[self.view setFrame:CGRectMake(showPoint.x-self.view.frame.size.width/2, showPoint.y-self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];/*
                                                 relatedNodesArray=[[NSMutableArray alloc] init];
                                                 linkLayerArray=[[NSMutableArray alloc] init];
                                                 relationTextArray=[[NSMutableArray alloc] init];
                                                 */
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 3;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    text.delegate=self;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tap:(UITapGestureRecognizer *)gesture
{
    [parentController expandSubNode:self.view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"begin");
    
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
