//
//  SubNodeViewController.m
//  eBookReader
//
//  Created by Shang Wang on 10/1/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "SubNodeViewController.h"
#import <BookViewController.h>
#import "ContentViewController.h"
 #include <stdlib.h>
@interface SubNodeViewController ()

@end

@implementation SubNodeViewController
@synthesize text;
@synthesize parentController;
@synthesize parentBookViewController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.userInteractionEnabled=YES;
    text.textAlignment = NSTextAlignmentCenter;
    //[self.view setFrame:CGRectMake(showPoint.x-self.view.frame.size.width/2, showPoint.y-self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singletap:)];
    tapGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapGestureRecognizer];/*
                                                 relatedNodesArray=[[NSMutableArray alloc] init];
                                                 linkLayerArray=[[NSMutableArray alloc] init];
                                                 relationTextArray=[[NSMutableArray alloc] init];
                                                 */
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 3;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    text.delegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(singletap:)
 )
    {
        return YES;
    }
    return NO;
}


- (IBAction)singletap:(UITapGestureRecognizer *)gesture
{
    srand(time(NULL));
    int pageNum = rand() % 7;
    [parentBookViewController showFirstPage:5];
    //parentBookViewController.pageNum=pageNum+1;
    
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
