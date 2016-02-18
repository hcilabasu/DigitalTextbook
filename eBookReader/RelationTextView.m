//
//  RelationTextView.m
//  eBookReader
//
//  Created by Shang Wang on 6/15/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "RelationTextView.h"
#import "CmapController.h"
@implementation RelationTextView
@synthesize enableRecognizer;
@synthesize disableEditting;
@synthesize overlay;
@synthesize leftNodeName;
@synthesize rightNodeName;
@synthesize parentCmapCtr;
//@synthesize leftNode;
//@synthesize rightNode;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        overlay = [[GHContextMenuView alloc] init];
        overlay.dataSource = self;
        overlay.delegate = self;
        // Initialization code
        enableRecognizer=YES;
        UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
        [self addGestureRecognizer:longPressRecognizer];
        enableRecognizer=NO;
        [self setUserInteractionEnabled:YES];
    }
    return self;
}



- (IBAction)tap:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Tap\n");
    
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
    
}






-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        gestureRecognizer.enabled = self.enableRecognizer;
        
    }
    
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        gestureRecognizer.enabled = self.enableRecognizer;
    }
    
    [super addGestureRecognizer:gestureRecognizer];
    return;
}





- (NSInteger) numberOfMenuItems
{
    return 2;
}

-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"deleteConcept";
            break;
        case 1:
            imageName = @"edit";
            break;
        default:
            break;
    }
    UIImage* img=[UIImage imageNamed:imageName];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation==UIInterfaceOrientationLandscapeLeft||orientation==UIInterfaceOrientationLandscapeRight) {
        img = [[UIImage alloc] initWithCGImage: img.CGImage
                                         scale: 1.0
                                   orientation: UIImageOrientationLeft];
    }
    return img;
}


- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    NSString* msg = nil;
    switch (selectedIndex) {
        case 0:
        {
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting"
                                                                message:@"Do you want to delete this link?."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Yes", nil];
                [alert show];
            }
        }
            break;
        case 1:
            [self becomeFirstResponder];
                       break;
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        [parentCmapCtr deleteLink:leftNodeName SecondNode:rightNodeName];
    }
    
    
}

@end
