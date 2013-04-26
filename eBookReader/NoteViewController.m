//
//  NoteViewController.m
//  eBookReader
//
//  Created by Shang Wang on 4/19/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "NoteViewController.h"


@interface NoteViewController ()

@end

@implementation NoteViewController
@synthesize noteImage;
@synthesize oneFingerTap;
@synthesize pvPoint;
@synthesize note_text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewFrame = [self.view frame];
    viewFrame.origin.y  = 630;
     CGSize screenSize = [self screenSize];
    [self.view setFrame:CGRectMake(screenSize.width-35, 300, 25, 25)];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    [doubleTap setNumberOfTapsRequired:1];
    doubleTap.delegate=self;
    [noteImage setUserInteractionEnabled:YES];
    [noteImage addGestureRecognizer:doubleTap];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize) screenSize
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

//Need to add this function to enable note view to recognize gesture.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (void)doubleTapped:(UITapGestureRecognizer *)tap
{
    
    NSArray *popUpContent=[NSArray arrayWithObjects:@"NoteTaking", nil];
    [pv setParentViewController:self];
    pv = [PopoverView showPopoverAtPoint: pv.showPoint
                                  inView:self.view
                               withTitle:@"Take Note"
                         withStringArray:popUpContent
                                delegate:self];
    pv.noteText.text=note_text;
    
    
}

@end
