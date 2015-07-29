//
//  LogInViewController.m
//  eBookReader
//
//  Created by Shang Wang on 7/25/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

@synthesize LoginButton;
@synthesize UserNameTextView;
@synthesize PasswordTextView;
@synthesize BG;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBarHidden=YES;
     BG.layer.zPosition=-1;
    UserNameTextView.userInteractionEnabled=YES;
    PasswordTextView.userInteractionEnabled=YES;
    PasswordTextView.secureTextEntry = YES;
}


-(void)viewWillAppear:(BOOL)animated{
      self.navigationController.navigationBarHidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickLogin:(id)sender {
    
    if([UserNameTextView.text length]==0){
        [[[UIAlertView alloc]
          initWithTitle:@"Error" message:@"User name is empty!" delegate:self
          cancelButtonTitle:@"Retry" otherButtonTitles: nil, nil] show];
    }else if(![PasswordTextView.text isEqualToString:@"2sigma"]){
        [[[UIAlertView alloc]
          initWithTitle:@"Error" message:@"Incorrect password." delegate:self
          cancelButtonTitle:@"Retry" otherButtonTitles: nil, nil] show];
    }else{
       // [ self performSegueWithIdentifier:@"OpenLibrary" sender:self];
        // LibraryViewController*  library=[[LibraryViewController alloc] initWithNibName:@"LibraryViewController" bundle:nil];
       
      //  LibraryViewController*  library=[[LibraryViewController alloc] init];

        
        LibraryViewController *library =(LibraryViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LibraryViewController"];
        library.userName=UserNameTextView.text;
        [self.navigationController pushViewController:library animated:YES];
        //[self addChildViewController:library];
        //[self.view addSubview: library.view];
        
        
    }
   }



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"OpenLibrary"])
    {
        // Get reference to the destination view controller
        LibraryViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.userName=UserNameTextView.text;
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
