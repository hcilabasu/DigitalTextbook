//
//  ConceptView.m
//  eBookReader
//
//  Created by Shang Wang on 4/15/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "ConceptViewController.h"
#import "ContentViewController.h"
@interface ConceptViewController ()

@end
@implementation ConceptViewController
@synthesize textField;
@synthesize oneFingerTap;
@synthesize pvPoint;
@synthesize iconPoint;
@synthesize parentController;

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
    [self.view setFrame:CGRectMake(0, iconPoint.y, self.view.frame.size.width, self.view.frame.size.height)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [doubleTap setNumberOfTapsRequired:1];
    doubleTap.delegate=self;
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 3;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
   // [textField setEnabled:NO];
    textField.delegate=self;
    [textField addGestureRecognizer:doubleTap];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
   return YES;
}


/*

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)singleTapped:(UITapGestureRecognizer *)tap
{
    
    parentController.firstRespondConcpet=self.textField.text;
    if(NO==parentController.isleftThumbShow){
        [parentController.ThumbScrollViewLeft setHidden:NO];
        [parentController loadThumbNailIcon:self.textField.text];
        parentController.isleftThumbShow=YES;
    }else if(YES==parentController.isleftThumbShow){
          }
   
    
}


@end


