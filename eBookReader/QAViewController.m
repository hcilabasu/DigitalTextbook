//
//  QAViewController.m
//  eBookReader
//
//  Created by Shang Wang on 5/18/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import "QAViewController.h"

@interface QAViewController ()

@end

@implementation QAViewController
@synthesize webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect rect=CGRectMake(530, 0, 511, 768);
    [self.view setFrame:rect];

    
    
    NSString* url =  [NSString stringWithFormat:@"http://2sigma.asu.edu/qa/index.php?qa=questions&qa_1=chapter-1&qa_2=page-%d", 1];
    webView.backgroundColor=[UIColor whiteColor];
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [webView loadRequest:request];
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 2;
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

@end
