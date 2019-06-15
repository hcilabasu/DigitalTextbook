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
#import "ConditionSetup.h"
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
    self.view.center=CGPointMake(780, 360);
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 6;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    // Do any additional setup after loading the view from its nib.
    
    recipes = [NSArray arrayWithObjects:@"Cause",@"Example",@"Have",@"Major",@"Include", @"Increase", @"Reduce", @"None",  nil];
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.tableView setUserInteractionEnabled:YES];
    
}



-(void)viewDidAppear:(BOOL)animated{
    tableView.delegate=parentCmapController;
    //tableView.dataSource=parentCmapController;
    
    
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    if( [cell.textLabel.text isEqualToString:@"None"]){
        cell.textLabel.textColor= [UIColor redColor];
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* linkName=cell.textLabel.text;
    
    if( [linkName isEqualToString:@"None"]){
        linkName=@"";
    }
    
    
    
    [parentCmapController upDateLinkText:linkName];
    NSString* selectionString=[[NSString alloc] initWithFormat:@"%@***%@",parentCmapController.linkJustAdded.leftNode.text.text, parentCmapController.linkJustAdded.righttNode.text.text];
    
    NSString* inputString=[[NSString alloc] initWithFormat:@"%@", cell.textLabel.text];
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:[[ConditionSetup sharedInstance] getSessionID] action:@"Update Link name from list" selection:selectionString input:inputString pageNum:parentCmapController.pageNum];
    [bookLogData addLogs:newlog];
    [LogDataParser saveLogData:bookLogData];
    
    [parentCmapController dismissLinkHint];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}







@end
