//
//  CmapController.m
//  eBookReader
//
//  Created by Shang Wang on 2/18/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "CmapController.h"
#import "GHContextMenuView.h"
#import "NodeCell.h"
#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "GDataXMLNode.h"
#import "HighLight.h"
#import "ThumbNailIcon.h"
#import "ThumbNailIconParser.h"
#import "ThumbNailIconWrapper.h"
#import "UIView+i7Rotate360.h"
#import "LSHorizontalScrollTabViewDemoViewController.h"
@interface CmapController ()<GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation CmapController
@synthesize dataObject;
@synthesize url;
@synthesize pageNum;
@synthesize totalpageNum;
@synthesize parent_BookViewController;
@synthesize prevIndex;
@synthesize longPressLocation;
@synthesize isShowing;
@synthesize isPaning;
@synthesize curretnLocation;
@synthesize menuItems;
@synthesize conceptMapView;
@synthesize isBlockedByKeyboard;
@synthesize conceptNamesArray;
@synthesize knowledgeModule;
@synthesize isReadyToLink;
@synthesize conceptNodeArray;
@synthesize nodesToLink;
@synthesize waitImageView;
@synthesize bookHighlight;
@synthesize bookThumbNial;
@synthesize bookTitle;
@synthesize showType;
@synthesize parent_ContentViewController;
@synthesize contentView;
- (void)viewDidLoad
{
    [super viewDidLoad];
   // if(2==showScenarioId){//the view is initialized in the book page.
        CGRect rect=CGRectMake(530, 0, 494, 768);
        [self.view setFrame:rect];
    //[self.conceptMapView setFrame:CGRectMake(0, 0, 494, 768)];
    //}
    CGRect rect2=CGRectMake(0, 0, 494, 768);
    contentView= [[UIView alloc]init];
    [contentView setFrame:rect2];
    [conceptMapView addSubview:contentView];
    
    conceptMapView.delegate=self;
    conceptMapView.minimumZoomScale = 1.0;
    conceptMapView.maximumZoomScale = 10.0;
    
    knowledgeModule=[ [KnowledgeModule alloc] init ];
    conceptNamesArray=[[NSMutableArray alloc] init];
    conceptNodeArray=[[NSMutableArray alloc] init];
    [self.navigationController setDelegate:self];
    [self.navigationController setNavigationBarHidden: YES animated:NO];
    
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPress:)];
    [conceptMapView addGestureRecognizer:longPressRecognizer];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 2;
    [self autoGerenateNode];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate=self;
       // [conceptMapView addGestureRecognizer:pinchGesture];

}



- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    static CGRect originSize;
    if(recognizer.state==UIGestureRecognizerStateBegan){
        originSize=recognizer.view.frame;
    }
    NSLog(@"%f",recognizer.scale);
    conceptMapView.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    [conceptMapView setContentSize:contentView.frame.size];
    [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    
    recognizer.scale = 1;
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        /*
        if(originSize.size.width*1.2<recognizer.view.frame.size.width||1==showType){
            CGRect rect=CGRectMake(530, 0, 494, 768);
            [self.view setFrame:rect];
           CmapController* cmapView=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
            cmapView.parent_ContentViewController=parent_ContentViewController;
            cmapView.dataObject=dataObject;
            cmapView.showType=0;
            cmapView.url=url;
            cmapView.bookHighlight=bookHighlight;
            cmapView.bookThumbNial=bookThumbNial;
            cmapView.bookTitle=bookTitle;
           [parent_ContentViewController.navigationController pushViewController:cmapView animated:NO];
           // [parent_ContentViewController.navigationController.view addSubview:cmapView.view];
        }else if (originSize.size.width<1.2*recognizer.view.frame.size.width||0==showType){
           
            [self.navigationController popViewControllerAnimated:NO ];
         
        } */
    }
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
     NSLog(@"eeee!");
    return contentView;
   
}




- (void)LongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (UIGestureRecognizerStateBegan==gestureRecognizer.state) {
        NSLog(@"UIGestureRecognizerStateEnded");
         CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
        [self addConceptOnClick: location];
    }
}

-(void)disableAllNodesEditting{
    
    for (NodeCell *node in conceptNodeArray){
        node.text.enabled=NO;
    }
}
-(void)enableAllNodesEditting{
    for (NodeCell *node in conceptNodeArray){
        node.text.enabled=YES;
    }
}

-(void)startWait{
    waitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wait"]];
    waitImageView.frame = CGRectMake(conceptMapView.frame.size.width-60, conceptMapView.frame.size.height-60, 40, 40);
    waitImageView.alpha=0.8;
    waitImageView.layer.masksToBounds = YES;
    waitImageView.image = [UIImage imageNamed:@"wait"];
    [conceptMapView addSubview:waitImageView];
    [waitImageView rotate360WithDuration:2.0 repeatCount:200 timingMode:i7Rotate360TimingModeLinear];
    waitImageView.animationDuration = 2.0;
 
    waitImageView.animationRepeatCount = 1;
    [waitImageView startAnimating];
    
    conceptMapView.backgroundColor=[UIColor colorWithRed: 114 green:114 blue:114 alpha:0.7];
}

-(void)endWait{
    [waitImageView removeFromSuperview];
}

-(void)dismissAlert:(UIAlertView*)x{
	[x dismissWithClickedButtonIndex:-1 animated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)createNode:(CGPoint)position withName:(NSString*) name{
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.bookPagePosition=CGPointMake(0, 0);
    node.parentCmapController=self;
    node.showPoint=position;
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
        [conceptNodeArray addObject:node];
    [self addChildViewController:node];
    // [contentView addSubview: node.view ];
    [conceptMapView addSubview: node.view ];
    node.text.text=name;
}


-(void)createNodeFromBook:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition{
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.parentCmapController=self;
    node.bookPagePosition=bookPosition;
    node.showPoint=position;
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
    [conceptNodeArray addObject:node];
    [self addChildViewController:node];
    [conceptMapView addSubview: node.view ];
    node.text.text=name;

}

-(void)showpageAtIntex: (int)page{
    [parent_ContentViewController showPageAtINdex:page];
}

-(void)generateNodeArray: (NSMutableArray*) conceptArray{
    
}


- (IBAction)returnToBookPage : (id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{

    if (  action == @selector(LongPress:)
        ||action==@selector(addWebMark:)
        ||action==@selector(backToBook:))
    {
        return YES;
    }
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (NSInteger) numberOfMenuItems
{
    return 4;
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
            msg = @"Add Selected";
            break;
        case 1:
            msg = @"Link Selected";
            break;
        case 2:
            msg = @"Google Plus Selected";
            break;
        case 3:
            msg = @"Linkedin Selected";
            break;
        case 4:
            msg = @"Pinterest Selected";
            break;
            
        default:
            break;
    }
}

-(void)addConceptOnClick: (CGPoint)clickPoint
{
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.parentCmapController=self;
    node.showPoint=clickPoint;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.bookthumbNailIcon=bookThumbNial;
    [self addChildViewController:node];
    [conceptNodeArray addObject:node];
    [conceptMapView addSubview: node.view ];
}

-(void)scrollCmapView :(CGFloat)length
{
    [conceptMapView setContentOffset:CGPointMake(0, length) animated:YES];
}


- (void)keyboardWillHide:(NSNotification*)notification {
    [self scrollCmapView: -10];
}


-(void)readyToAddLink{
    
}

-(void)autoGerenateNode{
    int conceptId=0;
    if ( bookHighlight!= nil) {
        for (HighLight *highLightText in bookHighlight.highLights) {
            NSString *methodString=highLightText.text;
            for (  Concept *cell in knowledgeModule.conceptList) {
                if([methodString rangeOfString:cell.conceptName].location != NSNotFound){
                    if(![conceptNamesArray containsObject: cell.conceptName]){
                        [conceptNamesArray addObject:cell.conceptName];
                        CGPoint position= [self calculateNodePosition:conceptId];
                        conceptId++;
                        [self createNode:position withName:cell.conceptName];
                    }
                }
            }
        }
    }
}



-(CGPoint)calculateNodePosition:(int) arrayId{
    int NodesInRow=3;
    int row = (int)arrayId/NodesInRow;
    int column=arrayId%NodesInRow;
    if( column < 0 ) column += NodesInRow;
    CGFloat x= 50+column*100;
    CGFloat y=40+row*40;
    return CGPointMake(x, y);
}


-(void)showResources
{
    LSHorizontalScrollTabViewDemoViewController *tabView=[[LSHorizontalScrollTabViewDemoViewController alloc] initWithNibName:@"LSHorizontalScrollTabViewDemoViewController" bundle:nil]; 
    tabView.highlightWrapper=bookHighlight;
    tabView.thumbNailWrapper=bookThumbNial;
    tabView.bookTitle=bookTitle;
    tabView.showType=showType;
    tabView.parentContentViewController=parent_ContentViewController;
    [self addChildViewController:tabView];
    [self.view addSubview:tabView.view];
}

- (IBAction)saveMap:(id)sender {
}


@end
