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
@synthesize parentController;
@synthesize iconPoint;

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
    //set up the note view frame, size, icon image and gesture recognizer.
    CGSize screenSize = [self screenSize];
    [self.view setFrame:CGRectMake(15, iconPoint.y, 25, 25)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
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

//get the screen sie
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


//when user clicks the icon, show the note view with the saved text at the saved pupup position.
- (void)singleTapped:(UITapGestureRecognizer *)tap
{
    NSArray *popUpContent=[NSArray arrayWithObjects:@"NoteTaking", nil];
    pv = [PopoverView showPopoverAtPoint: pvPoint
                                  inView:self.parentViewController.view
                               withTitle:@"Take Note"
                         withStringArray:popUpContent
                                delegate:self];
    pv.showPoint=pvPoint;
    pv.noteIcon=self;
    //set the popup note view uneditable when the user is viewing the note
    pv.noteText.editable=NO;
    pv.noteText.text=note_text;
    pv.parent_View_Controller=self.parentController;
    //set the gesture recognizer to the text of the noteview, when user clicks the text of the view, set the textview as editable.
    UITapGestureRecognizer *noteTextClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(note_text_tap:)];
    [noteTextClick setNumberOfTapsRequired:1];
    noteTextClick.delegate=self;
    [pv.noteText setUserInteractionEnabled:YES];
    [pv.noteText addGestureRecognizer:noteTextClick];
    pv.isNew=NO;
    
}

//gestrue recognizer that sets the textvirew editable.
- (void)note_text_tap:(UITapGestureRecognizer *)tap
{
    pv.noteText.editable=YES;
    [pv.noteText becomeFirstResponder];
}

//update the text when the note has been changed
- (void)updateText:(NSString *)new_text 
{
  
    [parentController updateNoteText: pvPoint PreText:note_text  NewText:new_text];
      note_text=new_text;
}


@end
