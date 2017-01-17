//
//  QAFinderViewController.m
//  eBookReader
//
//  Created by Shang Wang on 5/21/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import "QAFinderViewController.h"
#import "BookPageViewController.h"
#import "CmapController.h"
@interface QAFinderViewController ()

@end

@implementation QAFinderViewController
@synthesize parentQA;
@synthesize fileList;
@synthesize tableView;
@synthesize parentCmap;
@synthesize viewType;
@synthesize conceptName;
NSArray *recipes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileList=[[NSMutableArray alloc] init];
        viewType=0;
        conceptName=@"";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.center=CGPointMake(250, 360);
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 6;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    [self becomeFirstResponder];
    tableView.dataSource=self;
    tableView.delegate=self;
    // Do any additional setup after loading the view from its nib.
    
    recipes = [NSArray arrayWithObjects:@"What is money plant?", @"What is the axil and what is its role in reproduction?", @"What are vegetative parts?", @"Are there any plants that can reproduce without seeds?", @"What is a vegetative part?", @"Can somebody give an example for reproduction by roots?", nil];
    if(1==viewType){
        recipes = [NSArray arrayWithObjects:@"Google seach result", @"Wiki result", @"Q&A", @"Article", @"Video", nil];
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    if(1==viewType){
         return cell;
    }
    
    cell.imageView.frame=CGRectMake(0, 0, 28, 28);
    int r = arc4random_uniform(3);
    if(0==r){
        cell.imageView.image = [UIImage imageNamed:@"finish_small"];
    }
    if(1==r){
        cell.imageView.image = [UIImage imageNamed:@"alert_small"];
    }
    if(2==r){
        cell.imageView.image = [UIImage imageNamed:@"stop_small"];
    }
    if(3==r){
        cell.imageView.image = [UIImage imageNamed:@"error_small"];
    }

    
    cell.imageView.frame=CGRectMake(0, 0, 28, 28);
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [parentCmap.parentBookPageViewController clickOnBulb:nil];
    NSString* url = @"http://2sigma.asu.edu/qa/index.php?qa=questions&qa_1=chapter-1&qa_2=page-2";
    if(1==viewType){
        
        if(0==indexPath.row){
        NSString *googleLink=@"https://www.google.com/search?q=";
        NSString * concept = [conceptName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]; //repacing " " with "%20" for google search results
        url = [NSString stringWithFormat:@"%@%@", googleLink, concept];
        }else if(1==indexPath.row){
            
            NSString *wikki=@"http://en.wikipedia.org/wiki/";
            NSString * concept = [conceptName stringByReplacingOccurrencesOfString:@" " withString:@"_"]; //repacing " " with "%20" for google search results
            url = [NSString stringWithFormat:@"%@%@", wikki, concept];

        }
    }
    
    
    
    
    
    
    
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [parentCmap.parentBookPageViewController.QA.webView loadRequest:request];
    
}

- (IBAction)askQuestion:(id)sender {

    [self.view removeFromSuperview];
    [parentCmap.parentBookPageViewController clickOnBulb:nil];
    NSString* url = @"http://2sigma.asu.edu/qa/index.php?qa=ask&cat=3";
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [parentQA.webView loadRequest:request];

}




@end
