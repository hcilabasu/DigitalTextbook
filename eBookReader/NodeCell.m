//
//  NodeCell.m
//  eBookReader
//
//  Created by Shang Wang on 3/3/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "NodeCell.h"

#import "CmapController.h"
#import "ContentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+i7Rotate360.h"
#import "LSHorizontalScrollTabViewDemoViewController.h"
#import "BookViewController.h"
#import "MapFinderViewController.h"
//#import "RelationTextView.h"
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
@synthesize waitAnim;
@synthesize nodeType;
@synthesize hasHighlight;
@synthesize hasNote;
@synthesize hasWeblink;
@synthesize parentContentViewController;
@synthesize tapRecognizer;
@synthesize pageNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         isInitialed=NO;
        showType=1;
        relatedNodesArray=[[NSMutableArray alloc] init];
        linkLayerArray=[[NSMutableArray alloc] init];
        relationTextArray=[[NSMutableArray alloc] init];
         pageNum=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    int r = arc4random_uniform(3);
    if(1==r||2==r||[text.text isEqualToString:@"bud"]||[text.text isEqualToString:@"yeast cell"]){
    hasNote=YES;
    }
    r = arc4random_uniform(3);
    if(1==r||2==r){
    hasHighlight=YES;
       }
    r = arc4random_uniform(3);
    if(1==r||2==r){
    hasWeblink=YES;
    }
    //set up the note view frame, size, icon image and gesture recognizer.
    text.textAlignment = NSTextAlignmentCenter;
    [self.view setFrame:CGRectMake(showPoint.x-self.view.frame.size.width/2, showPoint.y-self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGesture.delegate=self;
    [self.view addGestureRecognizer:panGesture];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];/*
    relatedNodesArray=[[NSMutableArray alloc] init];
    linkLayerArray=[[NSMutableArray alloc] init];
    relationTextArray=[[NSMutableArray alloc] init];
                                                 */
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
    
    tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    tapRecognizer.delegate=self;
    //    Attaching it to textfield
    text.enableRecognizer=YES;
    [text addGestureRecognizer:tapRecognizer];
    text.enableRecognizer=NO;
    
    
    if(NO==isInitialed){
        NSLog(@"become first responder!\n");
        [text becomeFirstResponder];
    }
    if(hasNote){
    [self addNoteThumb];
    }
    if(hasWeblink){
    [self addWebThumb];
    }
    if(hasHighlight){
    [self addHighlightThumb];
    }
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    /*
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]&&[otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        return YES;
    }*/
    return NO;
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(text.disableEditting){
    return NO;
    }
    return YES;
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

-(void)removeShadowAnim{
    [self.view.layer removeAllAnimations];
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 3;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
}

- (IBAction)pan:(UIPanGestureRecognizer *)gesture
{
    static CGPoint originalCenter;
    
    if(1==nodeType){
        return;
    }
    
    
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
    
   // NSLog(@"Tap gesture!");
    if(YES==parentCmapController.isReadyToLink){
        
        
        NSLog(@"Link!!");
        
        MapFinderViewController* finder=[[MapFinderViewController alloc]initWithNibName:@"MapFinderViewController" bundle:nil];
        [parentCmapController addChildViewController:finder];
        finder.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //finder.fileList=finalFileList;
        finder.parentCmapController=parentCmapController;
        [finder.view setUserInteractionEnabled:YES];
        [parentCmapController addChildViewController:finder];
        [parentCmapController.view addSubview:finder.view];
        [finder becomeFirstResponder];
        
        
        [relatedNodesArray addObject:parentCmapController.nodesToLink];
        [parentCmapController.nodesToLink.relatedNodesArray addObject:self];
        [parentCmapController.nodesToLink removeShadowAnim];
    
        CAShapeLayer* layer = [CAShapeLayer layer];
        UITextView* relation= [[UITextView alloc]initWithFrame:CGRectMake(40, 40, 60, 35)];
        relation.tag=parentCmapController.linkCount;
        relation.delegate=self;
        relation.textAlignment=NSTextAlignmentCenter;
        relation.scrollEnabled=NO;
        [relationTextArray addObject:relation];
        ConceptLink *link = [[ConceptLink alloc] initWithName:self conceptName:parentCmapController.nodesToLink relation:relation page:parentCmapController.pageNum];
        [parentCmapController addConcpetLink:link];
        parentCmapController.linkJustAdded=link;
        
        [parentCmapController.nodesToLink.relationTextArray addObject:relation];
        [linkLayerArray addObject:layer];
        [parentCmapController.nodesToLink.linkLayerArray addObject:layer];
        
        CGPoint p1=[self getViewCenterPoint:self.view];
        CGPoint p2=[self getViewCenterPoint:parentCmapController.nodesToLink.view];
        relation.center=CGPointMake((p1.x/2+p2.x/2), (p1.y/2+p2.y/2));
        //[relation becomeFirstResponder];
        [self.parentCmapController.conceptMapView addSubview:relation];
    }
    parentCmapController.isReadyToLink=NO;
    [self updateLink];
    //[parentCmapController endWait];
    [parentCmapController enableAllNodesEditting];
}


- (IBAction)singleTap:(UIGestureRecognizer *)gesture{
   // parentCmapController.neighbor_BookViewController.pageNum=pageNum;
    [parentCmapController.neighbor_BookViewController showFirstPage:pageNum];
    parentContentViewController.pageNum=pageNum+1;
}






-(void)createLink: (NodeCell*)cellToLink name: (NSString*)relationName{
    
    [relatedNodesArray addObject:cellToLink];
    [cellToLink.relatedNodesArray addObject:self];
    [cellToLink removeShadowAnim];
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    UITextView* relation= [[UITextView alloc]initWithFrame:CGRectMake(40, 40, 60, 35)];
    relation.tag=parentCmapController.linkCount;
    relation.delegate=self;
    relation.textAlignment=NSTextAlignmentCenter;
    relation.scrollEnabled=NO;
    [relationTextArray addObject:relation];
    ConceptLink *link = [[ConceptLink alloc] initWithName:self conceptName:cellToLink relation:relation page:parentCmapController.pageNum];
    [parentCmapController addConcpetLink:link];
    
    [cellToLink.relationTextArray addObject:relation];
    [linkLayerArray addObject:layer];
    [cellToLink.linkLayerArray addObject:layer];
    
    CGPoint p1=[self getViewCenterPoint:self.view];
    CGPoint p2=[self getViewCenterPoint:cellToLink.view];
    relation.center=CGPointMake((p1.x/2+p2.x/2), (p1.y/2+p2.y/2));
    relation.text=relationName;
    [self.parentCmapController.conceptMapView addSubview:relation];
    [self updateLink];
}

-(void)waitForLink{
    self.view.layer.shadowColor=[UIColor redColor].CGColor;
    waitAnim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    waitAnim.fromValue = [NSNumber numberWithFloat:1.0];
    waitAnim.toValue = [NSNumber numberWithFloat:0.0];
    waitAnim.duration = 1.0;
    waitAnim.repeatCount=1000;
    waitAnim.autoreverses=YES;
    [self.view.layer addAnimation:waitAnim forKey:@"shadowOpacity"];
}


//remove all the links between other nodes.
-(void)removeLink{
    int i=0;
    //NSMutableArray *deleteArray= [[NSMutableArray alloc]init];
    for (NodeCell* object in relatedNodesArray) {
        CAShapeLayer* layer=[linkLayerArray objectAtIndex:i];
        [layer removeFromSuperlayer];
        UITextView* relationText= [relationTextArray objectAtIndex:i];
        [relationText removeFromSuperview];
        //delete the link and text in the related node.
        int j=0;
        for(NodeCell *dCell in object.relatedNodesArray){
            if([dCell.text.text isEqualToString:self.text.text]){
                break;
            }else{
            j++;
            }
        }
        [object.relatedNodesArray removeObjectAtIndex:j];
        [object.linkLayerArray removeObjectAtIndex:j];
        [object.relationTextArray removeObjectAtIndex:j];

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
           // [parentCmapController startWait];
            [self waitForLink];
            
            
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
            
            [parentCmapController.parent_ContentViewController showPageAtINdex:3];
            NSLog(@"page");
            
            break;
        case 4:
        {
            msg = @"Pinterest Selected";
             NSArray *popUpContent=[NSArray arrayWithObjects:@"Highlight", nil];
           
            PopoverView* pv = [PopoverView showPopoverAtPoint:self.view.frame.origin
                                          inView:parentCmapController.view
                                       withTitle:@"Key info"
                                 withStringArray:popUpContent
                                        delegate:self];
          //  pv.parent_View_Controller=self;
            pv.showPoint=self.view.frame.origin;
           // pv.parentViewController=self;
            [parentCmapController.view addSubview: pv];
            
           // [self showResources];
            break;
        }
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        
        if(1==nodeType){
            [self.view removeFromSuperview];
            ThumbNailIcon *itemToDelete=nil;
            for(ThumbNailIcon *thumb in   parentContentViewController.bookthumbNailIcon.thumbnails){
                if(3==thumb.type&&[thumb.text isEqualToString:text.text]){
                    itemToDelete=thumb;
                    break;
                }
            }
            [parentContentViewController.bookthumbNailIcon.thumbnails removeObject:itemToDelete];
            [ThumbNailIconParser saveThumbnailIcon:parentContentViewController.bookthumbNailIcon];
            
        }
        
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


-(void)addNoteThumb{
    UIImageView *thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"note_square.png"]];
    [thumb setFrame:CGRectMake(30, 22, 14, 14)];
    [self.view addSubview:thumb];
}

-(void)addWebThumb{
    UIImageView *thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"safari_square.png"]];
    [thumb setFrame:CGRectMake(50, 22, 14, 14)];
    [self.view addSubview:thumb];
}

-(void)addHighlightThumb{
    UIImageView *thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPlate.png"]];
    [thumb setFrame:CGRectMake(10, 22, 14, 14)];
    [self.view addSubview:thumb];
}


-(void)showResources{
    [self.parentCmapController showResources];
}

//after editting the text in the link, update the conceptLinkArray
- (void)textViewDidEndEditing:(UITextView *)textView{
   // ConceptLink* linkToUpdate;
    if(0<textView.tag){ // finish editting relationship text
        for(ConceptLink* view in parentCmapController.conceptLinkArray){
            if(view.relation.tag== textView.tag){
                view.relation.text=textView.text;
                NSLog(@"update link text...\n");
            }
        }
       // NSLog(@"finish editting");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    for(NodeCell* view in parentCmapController.conceptNodeArray){
        NSLog(@"Tag: %d",view.text.tag);
        /*
        if(view.text.tag== textField.tag){
            view.text.text=textField.text;
            NSLog(@"update Node text...\n");
        }
         */
    }
}

-(void)highlightNode{
    text.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(178/255.0) blue:(102/255.0) alpha:0.9];
}

-(void)unHighlightNode{
    text.backgroundColor=[UIColor colorWithRed:(164/255.0) green:(219/255.0) blue:(232/255.0) alpha:1.0];
}

-(void)highlightLink: (NSString*)relatedNodeName{
    int i=0;
    for (NodeCell* object in relatedNodesArray) {
        CAShapeLayer* layer=[linkLayerArray objectAtIndex:i];
        if([object.text.text isEqualToString:relatedNodeName]){
            layer.fillColor = [UIColor blueColor].CGColor;
            return;
        }
        i++;
    }

}


@end
