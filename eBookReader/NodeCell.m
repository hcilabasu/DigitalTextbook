//
//  NodeCell.m
//  eBookReader
//
//  Created by Shang Wang on 3/3/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "NodeCell.h"
#import "CmapController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+i7Rotate360.h"
#import "LSHorizontalScrollTabViewDemoViewController.h"
@implementation NodeCell
@synthesize showPoint;
@synthesize text;
@synthesize parentCmapController;
@synthesize pressing;
@synthesize longPressRecognizer;
@synthesize isInitialed;
@synthesize relatedNodesArray;
@synthesize linkLayerArray;
@synthesize relationTextArray;
@synthesize bookHighLight;
@synthesize bookthumbNailIcon;
@synthesize bookTitle;
@synthesize showType;
@synthesize bookPagePosition;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         isInitialed=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set up the note view frame, size, icon image and gesture recognizer.
    text.textAlignment = NSTextAlignmentCenter;
    [self.view setFrame:CGRectMake(showPoint.x-self.view.frame.size.width/2, showPoint.y-self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGesture.delegate=self;
    [self.view addGestureRecognizer:panGesture];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];
    relatedNodesArray=[[NSMutableArray alloc] init];
    linkLayerArray=[[NSMutableArray alloc] init];
    relationTextArray=[[NSMutableArray alloc] init];
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 3;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    text.delegate=self;
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    longPressRecognizer.delegate=self;
    //    Attaching it to textfield
    text.enableRecognizer=YES;
    [text addGestureRecognizer:longPressRecognizer];
    text.enableRecognizer=NO;
    if(NO==isInitialed){
        NSLog(@"become first responder!\n");
        [text becomeFirstResponder];
    }
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]&&[otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        return YES;
    }
    return NO;
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    text.backgroundColor = [UIColor greenColor];
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGSize screenSZ=[self screenSize];
    CGFloat offSet=(textField.superview.frame.size.height+ textField.superview.frame.origin.y)-(screenSZ.height-352);
   // NSLog(@"Offset: %f",offSet);
    if(offSet>0){
       // NSLog(@"Blocked by keyboard!!");
        [parentCmapController scrollCmapView:offSet];
    }
}


- (IBAction)pan:(UIPanGestureRecognizer *)gesture
{
    static CGPoint originalCenter;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        originalCenter = gesture.view.center;
        gesture.view.layer.shouldRasterize = YES;
    }
    
    if(gesture.state==UIGestureRecognizerStateEnded){
     
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [gesture translationInView:gesture.view.superview];
        gesture.view.center = CGPointMake(originalCenter.x + translate.x, originalCenter.y + translate.y);
     
        [self updateLink];
    }
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateFailed ||
        gesture.state == UIGestureRecognizerStateCancelled)
    {
       // gesture.view.layer.shouldRasterize = NO;
    }
    
}


- (IBAction)tap:(UIPanGestureRecognizer *)gesture
{
    if(YES==parentCmapController.isReadyToLink){
        [relatedNodesArray addObject:parentCmapController.nodesToLink];
        [parentCmapController.nodesToLink.relatedNodesArray addObject:self];
        CAShapeLayer* layer = [CAShapeLayer layer];
        UITextView* relation= [[UITextView alloc]initWithFrame:CGRectMake(40, 40, 60, 35)];
        relation.textAlignment=NSTextAlignmentCenter;
        relation.scrollEnabled=NO;
        [relationTextArray addObject:relation];
        [parentCmapController.nodesToLink.relationTextArray addObject:relation];
        [linkLayerArray addObject:layer];
        [parentCmapController.nodesToLink.linkLayerArray addObject:layer];
        
        CGPoint p1=[self getViewCenterPoint:self.view];
        CGPoint p2=[self getViewCenterPoint:parentCmapController.nodesToLink.view];
        relation.center=CGPointMake((p1.x/2+p2.x/2), (p1.y/2+p2.y/2));
        [relation becomeFirstResponder];
         [self.parentCmapController.conceptMapView addSubview:relation];
    }
    parentCmapController.isReadyToLink=NO;
    [self updateLink];
    [parentCmapController endWait];
    [parentCmapController enableAllNodesEditting];
}


//remove all the links between other nodes.
-(void)removeLink{
    int i=0;
    for (NodeCell* object in relatedNodesArray) {
        CAShapeLayer* layer=[linkLayerArray objectAtIndex:i];
        [layer removeFromSuperlayer];
        UITextView* relationText= [relationTextArray objectAtIndex:i];
        [relationText removeFromSuperview];
        [object.relatedNodesArray removeObject:self];
        i++;
    }
    
}


-(void)updateLink{
    int i=0;
    for (NodeCell* object in relatedNodesArray) {
        CAShapeLayer* layer=[linkLayerArray objectAtIndex:i];
        CGPoint p1=[self getViewCenterPoint:self.view];
        CGPoint p2=[self getViewCenterPoint:object.view];
        [self addLine:[self getViewCenterPoint:self.view] Point2:[self getViewCenterPoint:object.view] Layer:layer ];
       UITextView* relationText= [relationTextArray objectAtIndex:i];
        relationText.center=CGPointMake((p1.x/2+p2.x/2), (p1.y/2+p2.y/2));
        CGRect frame = relationText.frame;
        frame.size.height=relationText.contentSize.height;
        frame.size.width=relationText.contentSize.width;
        [relationText setFrame:frame];
       [self.parentCmapController.conceptMapView addSubview:relationText];
        i++;
    }
}


-(CGPoint)getViewCenterPoint:(UIView*)view {
    CGPoint point=CGPointMake(0, 0);
    point.x=view.frame.origin.x+view.frame.size.width/2;
    point.y=view.frame.origin.y+view.frame.size.height/2;
    return point;
}


- (void)addLine:(CGPoint)p1 Point2: (CGPoint)p2 Layer: (CAShapeLayer*) layer {
    layer.strokeColor = [[UIColor grayColor] CGColor];
    layer.lineWidth = 1.0;
    layer.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    layer.path = [path CGPath];
    [self.parentCmapController.conceptMapView.layer insertSublayer:layer atIndex:0];
}


//points the position of the concept in the book.
- (void)addLineAtTop:(CGPoint)p1 Point2: (CGPoint)p2 Layer: (CAShapeLayer*) layer {
    // layer = [CAShapeLayer layer];
    layer.strokeColor = [[UIColor grayColor] CGColor];
    layer.lineWidth = 1.0;
    layer.fillColor = [[UIColor clearColor] CGColor];
    //[lineLaer removeFromSuperlayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    // [shapeLayer removeFromSuperlayer];
    layer.path = [path CGPath];
    [self.parentCmapController.parent_ContentViewController.view.layer addSublayer:layer];
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


- (NSInteger) numberOfMenuItems
{
    return 5;
}

-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"addConcpetNode";
            break;
        case 1:
            imageName = @"link";
            break;
        case 2:
            imageName = @"deleteConcept";
            break;
        case 3:
            imageName = @"edit";
            break;
        case 4:
            imageName = @"pinterest-white";
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
            msg = @"back to book";
        {
            CAShapeLayer* layer=[CAShapeLayer layer];
            CGPoint p1=bookPagePosition;
            CGPoint p2=CGPointMake(self.view.frame.origin.x+512, self.view.frame.origin.y+self.view.frame.size.height/2);
            [self addLineAtTop:p1 Point2:p2 Layer:layer ];
        }
            break;
        case 1:
            msg = @"link Selected";
            parentCmapController.isReadyToLink=YES;
            parentCmapController.nodesToLink=self;
            [parentCmapController disableAllNodesEditting];
            [parentCmapController startWait];
            
            
            break;
        case 2:
            msg = @"Deleting Selected";
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting"
                                                            message:@"Do you want to delete this concetp node?."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
        }
            
            break;
        case 3:
            msg = @"Linkedin Selected";
            break;
        case 4:
            msg = @"Pinterest Selected";
            [self showResources];
            break;
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        NodeCell *cellToRemove;
        for(NodeCell* cell in parentCmapController.conceptNodeArray){
            if([cell.text.text isEqualToString:self.text.text]){
                cellToRemove=cell;
                break;
            }
        }
        [self removeLink];
        [parentCmapController.conceptNodeArray removeObject:cellToRemove];
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
    }
}




-(void)showResources{
    [self.parentCmapController showResources];
}



@end
