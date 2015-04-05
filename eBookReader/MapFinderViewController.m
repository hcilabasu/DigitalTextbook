//
//  MapFinderViewController.m
//  eBookReader
//
//  Created by Shang Wang on 8/13/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "MapFinderViewController.h"
#import "CmapController.h"
@interface MapFinderViewController ()

@end

@implementation MapFinderViewController
NSArray *recipes;
@synthesize tableView;
@synthesize parentCmapController;
@synthesize fileList;

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
    
    recipes = [NSArray arrayWithObjects:@"Include", @"Have", @"Involve", @"Increase", @"Reduce", @"Facilitate", @"Help", @"Control", nil];
    
    /*
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyBook"];
    [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyBook/book"];
    NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:dataPath error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.xml'"];
    NSArray *fileList = [dirContents filteredArrayUsingPredicate:fltr];
    [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    */
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)Dismiss:(id)sender {
   // parentCmapController.isFinderWindowShow=NO;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

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
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}




@end
