//
//  MapFinderViewController.m
//  eBookReader
//
//  Created by Shang Wang on 8/13/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "MapFinderViewController.h"
#import "CmapController.h"
#import "TrainingViewController.h"
#import "BookPageViewController.h"
@interface MapFinderViewController ()

@end

@implementation MapFinderViewController
NSArray *recipes;
@synthesize tableView;
@synthesize parentCmapController;
@synthesize fileList;
@synthesize bookLogData;
@synthesize userName;
@synthesize parentTrainingCtr;
@synthesize parentBookPageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileList=[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.center=CGPointMake(250, 360);
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 6;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    [self becomeFirstResponder];
    //tableView.dataSource=self;
    //tableView.delegate=self;
    // Do any additional setup after loading the view from its nib.
    
    recipes = [NSArray arrayWithObjects:@"Include", @"Have", @"Involve", @"Increase", @"Reduce", @"Facilitate", @"Grow", @"Control", nil];
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [parentCmapController resignFirstResponder];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)Dismiss:(id)sender {
   // parentCmapController.isFinderWindowShow=NO;
    [parentCmapController deleteLink:parentCmapController.linkJustCreated.leftNodeName SecondNode:parentCmapController.linkJustCreated.rightNodeName];
    [parentCmapController dismissLinkHint];
    [self resignFirstResponder];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

}

- (IBAction)EditLink:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [parentCmapController dismissLinkHint];
    [parentCmapController editRelationLink];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [fileList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"cmapIconShadow.png"];
    cell.imageView.frame = CGRectMake(0,0,32,32);
    
    return cell;
}

*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [parentCmapController upDateLinkText:cell.textLabel.text];
    NSString* inputString=[[NSString alloc] initWithFormat:@"%@", cell.textLabel.text];
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Update Link name from list" selection:@"new concept link" input:inputString pageNum:0];
    [bookLogData addLogs:newlog];
    [LogDataParser saveLogData:bookLogData];
    
    //[parentTrainingCtr showAlertWithString:@"Good job! Now try to delete a concept node"];
    //[parentTrainingCtr createDeleteTraining];
    
    if(parentCmapController.parentBookPageViewController.isTraining){
        UIImage *image = [UIImage imageNamed:@"Train_delete"];
        image=[self imageWithImage:image scaledToSize:CGSizeMake(300, 200)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
    [parentBookPageView showAlertWithString:@"Good job! Now try to delete a concept node":imageView];
    [parentBookPageView createDeleteTraining];
    }
    [parentCmapController dismissLinkHint];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
