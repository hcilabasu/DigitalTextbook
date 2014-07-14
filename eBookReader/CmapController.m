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
#import "BookViewController.h"
@interface CmapController ()<GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation CmapController
@synthesize dataObject;
@synthesize url;
@synthesize pageNum;
@synthesize totalpageNum;
@synthesize neighbor_BookViewController;
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
@synthesize conceptLinkArray;
@synthesize nodeCount;
@synthesize linkCount;
@synthesize bookLinkWrapper;
@synthesize bookNodeWrapper;
@synthesize isFinishLoadMap;
@synthesize isInitComplete;

- (id) init {
	if (self = [super init]) {
        nodeCount=1;
        linkCount=1;
	}
	
	return self;
}

- (void)viewDidLoad
{
    nodeCount=1;
    linkCount=1;
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
    bookLinkWrapper= [[CmapLinkWrapper alloc]init];
    bookNodeWrapper= [[CmapNodeWrapper alloc]init];
    knowledgeModule=[ [KnowledgeModule alloc] init ];
    conceptNamesArray=[[NSMutableArray alloc] init];
    conceptNodeArray=[[NSMutableArray alloc] init];
    conceptLinkArray=[[NSMutableArray alloc] init];
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
    //[self autoGerenateNode]; generate nodes from highlights and notes.
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate=self;
       // [conceptMapView addGestureRecognizer:pinchGesture];
    [self loadConceptMap:nil];
    isInitComplete=YES;
    
    
}

- (void) viewDidAppear:(BOOL) animated {
    //do stuff...
    [neighbor_BookViewController searchAndHighlightNode];
    [neighbor_BookViewController searchAndHighlightLink];
    [super viewDidAppear:animated];
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
    }
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentView;
}


- (IBAction)loadConceptMap:(id)sender {
    bookNodeWrapper=[CmapNodeParser loadCmapNode];
    bookLinkWrapper=[CmapLinkParser loadCmapLink];
    
    for (NodeCell *cell in conceptNodeArray)
    {
        [cell removeLink];
        [cell.view removeFromSuperview];
    }

    [conceptNodeArray removeAllObjects];
    [conceptLinkArray removeAllObjects];
    for(CmapNode* cell in bookNodeWrapper.cmapNodes){
        [self createNode:CGPointMake(cell.point_x, cell.point_y) withName:cell.text page:cell.pageNum];
    }
    for(CmapLink* link in bookLinkWrapper.cmapLinks){
        
        NodeCell* c1, *c2;
        
        for(NodeCell* node in conceptNodeArray){
            if([link.leftConceptName isEqualToString:node.text.text]){
                c1=node;
            }
            if([link.rightConceptName isEqualToString:node.text.text]){
                c2=node;
            }
        }
        [c1 createLinkWithPageNum:c2 name:link.relationName page:link.pageNum];
    }
    isFinishLoadMap=YES;
}



-(void)createLink: (NodeCell*) leftCell rightCell: (NodeCell*) rightCell name: (NSString*)relationName{
    CAShapeLayer* layer = [CAShapeLayer layer];
    UITextView* relation= [[UITextView alloc]initWithFrame:CGRectMake(40, 40, 60, 35)];
    relation.tag=linkCount;
    relation.delegate=self;
    relation.textAlignment=NSTextAlignmentCenter;
    relation.scrollEnabled=NO;
   // [relationTextArray addObject:relation];
    //ConceptLink *link = [[ConceptLink alloc] initWithName:self conceptName:relationName relation:relation];
    //[parentCmapController addConcpetLink:link];
    
    CGPoint p1=[self getViewCenterPoint:leftCell.view];
    CGPoint p2=[self getViewCenterPoint:rightCell.view];
    relation.center=CGPointMake((p1.x/2+p2.x/2), (p1.y/2+p2.y/2));
    [self.view addSubview:relation];
    relation.text=relationName;
    
    layer.strokeColor = [[UIColor grayColor] CGColor];
    layer.lineWidth = 1.0;
    layer.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    layer.path = [path CGPath];
    [self.view.layer insertSublayer:layer atIndex:0];
    [leftCell.linkLayerArray addObject:layer];
     [rightCell.linkLayerArray addObject:layer];
}

-(CGPoint)getViewCenterPoint:(UIView*)view{
    CGPoint point=CGPointMake(0, 0);
    point.x=view.frame.origin.x+view.frame.size.width/2;
    point.y=view.frame.origin.y+view.frame.size.height/2;
    return point;
    
}

- (IBAction)saveConceptMap:(id)sender {
    
     HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	HUD.labelText = @"Saving...";
	[HUD showWhileExecuting:@selector(WaitingTask) onTarget:self withObject:nil animated:YES];
    [bookLinkWrapper clearAllData];
    [bookNodeWrapper clearAllData];
    for(ConceptLink* m_link in conceptLinkArray){
        CmapLink* link= [[CmapLink alloc] initWithName:m_link.leftNode.text.text conceptName:m_link.righttNode.text.text relation:m_link.relation.text page:m_link.pageNum];
       
        [bookLinkWrapper addLinks:link];
    }
    [ CmapLinkParser saveCmapLink:bookLinkWrapper];
    for(NodeCell* m_node in conceptNodeArray){
        CmapNode* node= [[CmapNode alloc] initWithName: m_node.text.text bookTitle:m_node.bookTitle positionX:m_node.view.frame.origin.x positionY:m_node.view.frame.origin.y Tag:m_node.text.tag page:m_node.pageNum];
        [bookNodeWrapper addthumbnail:node];
    }
    [CmapNodeParser saveCmapNode:bookNodeWrapper];
}



-(void)autoSaveMap{
    [bookLinkWrapper clearAllData];
    [bookNodeWrapper clearAllData];
    for(ConceptLink* m_link in conceptLinkArray){
        CmapLink* link= [[CmapLink alloc] initWithName:m_link.leftNode.text.text conceptName:m_link.righttNode.text.text relation:m_link.relation.text page:pageNum];
        
        [bookLinkWrapper addLinks:link];
    }
    [ CmapLinkParser saveCmapLink:bookLinkWrapper];
    for(NodeCell* m_node in conceptNodeArray){
        CmapNode* node= [[CmapNode alloc] initWithName: m_node.text.text bookTitle:m_node.bookTitle positionX:m_node.view.frame.origin.x positionY:m_node.view.frame.origin.y Tag:m_node.text.tag page:m_node.pageNum];
        [bookNodeWrapper addthumbnail:node];
        
    }
    [CmapNodeParser saveCmapNode:bookNodeWrapper];
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

-(void)createNode:(CGPoint)position withName:(NSString*) name page: (int)m_pageNum{
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.bookPagePosition=CGPointMake(0, 0);
    node.parentCmapController=self;
    node.showPoint=CGPointMake(position.x+39, position.y+15);
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
    node.pageNum=m_pageNum;
    [conceptNodeArray addObject:node];
    [self addChildViewController:node];
    // [contentView addSubview: node.view ];
    [conceptMapView addSubview: node.view ];
    node.text.text=name;
    node.text.tag=nodeCount;//use nodeCount to identify the node.
    nodeCount++;
    //[self autoSaveMap];
}


-(void)createNodeFromBook:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition page:(int)m_pageNum{
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.parentCmapController=self;
    node.bookPagePosition=bookPosition;
    node.showPoint=position;
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
    node.pageNum=m_pageNum-1;
    [conceptNodeArray addObject:node];
    [self addChildViewController:node];
    [conceptMapView addSubview: node.view ];
    node.text.text=name;
    node.text.tag=nodeCount;//use nodeCount to identify the node.
    nodeCount++;
    //[self autoSaveMap];
}

-(void)addConcpetLink: (ConceptLink*) m_link{
    [conceptLinkArray addObject:m_link];
    linkCount++;
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
                        [self createNode:position withName:cell.conceptName page:0];
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

- (void)textViewDidEndEditing:(UITextView *)textView{
    // ConceptLink* linkToUpdate;
    if(0<textView.tag){ // finish editting relationship text
        for(ConceptLink* view in conceptLinkArray){
            if(view.relation.tag== textView.tag){
                view.relation.text=textView.text;
                NSLog(@"update link text...\n");
            }
        }
    }
}

- (void)WaitingTask {
	sleep(1);
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self loadConceptMap:nil];
}

- (void)viewWillDisappear:(BOOL)animated { //when it is about to disappera, save the current concept map.
    [self autoSaveMap];
}


-(void)highlightNode: (NSString*)nodeName{
    NSLog(@"Highlight");
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:nodeName]){
            [cell highlightNode];
            return;
        }
    }
}


-(void)clearAllHighlight{
    for(NodeCell* cell in conceptNodeArray){
        [cell unHighlightNode];
        [cell unHighlightLink];
    }
   // [self unHighlightLink];
}


-(void)highlightLink: (int)page{
    
    for(ConceptLink *link in conceptLinkArray){
        if(link.pageNum==pageNum){
            NodeCell* left=link.leftNode;
            [left highlightLink:link.righttNode.text.text];
            
        }
    }
}

-(void)unHighlightLink{
    for(ConceptLink *link in conceptLinkArray){
        NodeCell* left=link.leftNode;
        [left unHighlightLink];
    }
}

@end

