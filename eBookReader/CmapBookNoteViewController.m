//
//  CmapBookNoteViewController.m
//  eBookReader
//
//  Created by Shang Wang on 6/4/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import "CmapBookNoteViewController.h"
#import "ContentViewController.h"
@interface CmapBookNoteViewController ()

@end

@implementation CmapBookNoteViewController
@synthesize parentContentView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.view.frame = CGRectMake(0, 44, 500, 500);
    
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 3;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    
    // Do any additional setup after loading the view from its nib.
    self.view.alpha=1;
    [self.view setUserInteractionEnabled:YES];
     
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 1;
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.delegate=self;
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tapDetected{
    //NSLog(@"single Tap on imageview");
    if(parentContentView.showingOverLayCmap){
        [parentContentView hideOverLayCmapView];
    }else{
    [parentContentView showOverLayCmapView];
    }
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
