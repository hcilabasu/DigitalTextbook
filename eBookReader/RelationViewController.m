//
//  RelationViewController.m
//  eBookReader
//
//  Created by Shang Wang on 3/17/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "RelationViewController.h"

@interface RelationViewController ()

@end

@implementation RelationViewController
@synthesize text;
@synthesize parent;
@synthesize child;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 200, self.view.bounds.size.width, 1)];
    self.view.backgroundColor=[UIColor blackColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
