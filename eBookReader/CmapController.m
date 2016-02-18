//
//  CmapController.m
//  eBookReader
//
//  Created by Shang Wang on 2/18/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "CmapController.h"
//#import "GHContextMenuView.h"
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

#import "BookPageViewController.h"
#import "LogData.h"
#import "BookPageViewController.h"
/*
 @interface CmapController ()<GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>
 @property (weak, nonatomic) IBOutlet UIImageView *imageView;
 @end
 */
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
@synthesize restClient;
@synthesize linkJustAdded;
@synthesize bookLogDataWrapper;
@synthesize bulbImageView;
@synthesize focusQuestionLable;
@synthesize isQuestionShow;
@synthesize toolBar;
@synthesize userName;
@synthesize parentBookPageViewController;
@synthesize enableHyperLink;
@synthesize addedNode;
@synthesize nodeTextBeforeEditing;
@synthesize linkTextBeforeEditing;
@synthesize hasLogedModifyMap;
@synthesize savedExpertImg;
@synthesize conceptsShowAry;
@synthesize savedMapHeight;
@synthesize savedMapWidth;
@synthesize previewImageView;
@synthesize lastStepConceptLinkArray;
@synthesize lastStepConceptNodeArray;
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
    addedNode=nil;
    // if(2==showScenarioId){//the view is initialized in the book page.
    CGRect rect=CGRectMake(530, 0, 511, 768);
    [self.view setFrame:rect];
    //[self.conceptMapView setFrame:CGRectMake(0, 0, 494, 768)];
    //}
    CGRect rect2=CGRectMake(0, 0, 511, 768);
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
    conceptsShowAry=[[NSMutableArray alloc] init];
    lastStepConceptNodeArray=[[NSMutableArray alloc] init];
    lastStepConceptLinkArray=[[NSMutableArray alloc] init];
    
    [self.navigationController setDelegate:self];
    [self.navigationController setNavigationBarHidden: YES animated:NO];
    /*
     GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
     overlay.dataSource = self;
     overlay.delegate = self;
     */
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPress:)];
    //[conceptMapView addGestureRecognizer:longPressRecognizer];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification
     object:nil];
    
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 2;
    //[self autoGerenateNode]; generate nodes from highlights and notes.
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate=self;
    // [conceptMapView addGestureRecognizer:pinchGesture];
    // [self loadConceptMap:nil];
    isInitComplete=YES;
    
    //double tap to pop up help menu
    //UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    //[doubleTap setNumberOfTapsRequired:2];
    //doubleTap.delegate=self;
    //[self.view addGestureRecognizer:doubleTap];
    
    bulbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(450, 700, 40, 40)];
    [bulbImageView setImage:[UIImage imageNamed:@"addIcon"]];
    bulbImageView.alpha=0.8;
    bulbImageView.userInteractionEnabled = YES;
    
    bulbImageView.layer.shadowOpacity = 0.4;
    bulbImageView.layer.shadowRadius = 3;
    bulbImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    bulbImageView.layer.shadowOffset = CGSizeMake(2, 2);
    
    UITapGestureRecognizer *bulbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBulb:)];
    [self.bulbImageView addGestureRecognizer:bulbTap];
    
    
    previewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 700, 40, 40)];
    [previewImageView setImage:[UIImage imageNamed:@"preview"]];
    previewImageView.alpha=0.8;
    previewImageView.userInteractionEnabled = YES;
    
    previewImageView.layer.shadowOpacity = 0.4;
    previewImageView.layer.shadowRadius = 3;
    previewImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    previewImageView.layer.shadowOffset = CGSizeMake(2, 2);
    
    /*
    UITapGestureRecognizer *previewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndHidePreview:)];
    [previewImageView addGestureRecognizer:previewTap];
    
    NSString* previewBtn=[[NSUserDefaults standardUserDefaults] stringForKey:@"isPreview"];
    if([previewBtn isEqualToString:@"YES"]){
        [self.view addSubview:previewImageView];
    }
 
    NSString* allowManu=[[NSUserDefaults standardUserDefaults] stringForKey:@"isManu"];
    if([allowManu isEqualToString:@"YES"]){
        [self.view addSubview:bulbImageView];
    }
    */
    UIImageView*  uploadImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 730, 40, 40)];
    [uploadImg setImage:[UIImage imageNamed:@"idea"]];
    uploadImg.alpha=0.8;
    uploadImg.userInteractionEnabled = YES;
    
    uploadImg.layer.shadowOpacity = 0.4;
    uploadImg.layer.shadowRadius = 3;
    uploadImg.layer.shadowColor = [UIColor blackColor].CGColor;
    uploadImg.layer.shadowOffset = CGSizeMake(2, 2);
    
    UITapGestureRecognizer *bulbTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upp:)];
    
    [uploadImg addGestureRecognizer:bulbTap2];
    
    [self.view addSubview:uploadImg];
    [uploadImg setHidden:YES];
    
    focusQuestionLable.layer.shadowOpacity = 0.4;
    focusQuestionLable.layer.shadowRadius = 3;
    focusQuestionLable.layer.shadowColor = [UIColor blackColor].CGColor;
    focusQuestionLable.layer.shadowOffset = CGSizeMake(2, 2);
    isQuestionShow=YES;
    [focusQuestionLable setHidden:YES];
    //[bulbImageView setHidden: YES];
   // [toolBar setHidden:YES];
    [self resignFirstResponder];
    
    /*
     UIButton *but=[UIButton buttonWithType:UIButtonTypeRoundedRect];
     but.frame= CGRectMake(20, 700, 25, 15);
     [but setTitle:@"Go" forState:UIControlStateNormal];
     [but addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:but];*/
    //  [self loadConceptMap: nil];
    
    [self readSavedCmapSize];
    [self loadConceptMap:nil];
    
    [self.view bringSubviewToFront:toolBar];
    
}

- (IBAction)hideAndShow:(id)sender {
    [parentBookPageViewController hideAndShowPreView];

}


-(void)showAndHidePreview:(id)sender {
    [parentBookPageViewController hideAndShowPreView];
}

-(void)buttonAction{
    [self saveConceptMap:nil];
    
    [self upLoadExpertNodetoDropbox];
    [self upLoadExpertLinktoDropbox];
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
    
    [self SaveCmapSize:contentView.frame.size.width Height:contentView.frame.size.height];
    
    
    recognizer.scale = 1;
    if(recognizer.state == UIGestureRecognizerStateEnded){
    }
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(contentView.frame.size.width>2500){
        return NULL;
    }
    
    return contentView;
}




- (IBAction)loadConceptMap:(id)sender {
    
    
    NSString* istest=[[NSUserDefaults standardUserDefaults] stringForKey:@"loadExpertMap"];
    
    if([istest isEqualToString:@"YES"]){
        
        bookNodeWrapper=[CmapNodeParser loadExpertCmapNode];
        bookLinkWrapper=[CmapLinkParser loadExpertCmapLink];
    }else{
        bookNodeWrapper=[CmapNodeParser loadCmapNode];
        bookLinkWrapper=[CmapLinkParser loadCmapLink];
    }
    

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
            if([link.leftConceptName isEqualToString:node.conceptName]){
                c1=node;
            }
            if([link.rightConceptName isEqualToString:node.conceptName]){
                c2=node;
            }
        }
        [c1 createLink:c2 name:link.relationName];
    }
    isFinishLoadMap=YES;
    
  //  [self modifyMap];
    
    if([istest isEqualToString:@"YES"]){
        [self modifyExpertMap];
    }
}



-(void)reCreateAllLinks{
    
    bookNodeWrapper=[CmapNodeParser loadExpertCmapNode];
    bookLinkWrapper=[CmapLinkParser loadExpertCmapLink];
    
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
            if([link.leftConceptName isEqualToString:node.conceptName]){
                c1=node;
            }
            if([link.rightConceptName isEqualToString:node.conceptName]){
                c2=node;
            }
        }
        [c1 createLink:c2 name:link.relationName];
    }
    isFinishLoadMap=YES;
    
    
}


-(void)createLink: (NodeCell*) leftCell rightCell: (NodeCell*) rightCell name: (NSString*)relationName{
    [self savePreviousStep];
    CAShapeLayer* layer = [CAShapeLayer layer];
    RelationTextView* relation= [[RelationTextView alloc]initWithFrame:CGRectMake(40, 40, 60, 35)];
    relation.tag=linkCount;
    relation.delegate=self;
    relation.textAlignment=NSTextAlignmentCenter;
    //relation.scrollEnabled=NO;
    relation.parentCmapCtr=self;
    relation.leftNodeName=leftCell.text.text;
    relation.rightNodeName=rightCell.text.text;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(textViewDidEndEditing:)
               name:UITextViewTextDidEndEditingNotification
             object:nil];
    
    
    //relation.frame = CGRectMake(relation.frame.origin.x, relation.frame.origin.y, relation.contentSize.width, relation.contentSize.height);
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
        CmapLink* link= [[CmapLink alloc] initWithName:m_link.leftNode.text.text conceptName:m_link.righttNode.text.text relation:m_link.relation.text page:pageNum];
        
        [bookLinkWrapper addLinks:link];
    }
    //  [ CmapLinkParser saveCmapLink:bookLinkWrapper];
    [ CmapLinkParser saveExpertCmapLink:bookLinkWrapper];
    for(NodeCell* m_node in conceptNodeArray){
        CmapNode* node= [[CmapNode alloc] initWithName: m_node.text.text bookTitle:m_node.bookTitle positionX:m_node.view.frame.origin.x positionY:m_node.view.frame.origin.y Tag:m_node.text.tag page:m_node.pageNum];
        [bookNodeWrapper addthumbnail:node];
    }
    //[CmapNodeParser saveCmapNode:bookNodeWrapper];
    [CmapNodeParser saveExpertCmapNode:bookNodeWrapper];
}

-(void)savePreviousStep{
    lastStepConceptLinkArray= [[NSMutableArray alloc] initWithArray:conceptLinkArray];
    lastStepConceptNodeArray= [[NSMutableArray alloc] initWithArray:conceptNodeArray];
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
        LogFileController* log=[[LogFileController alloc]init];
        NSString *logStr=[[NSString alloc] initWithFormat:@"Add new concept.\n"];
        
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"creating new concept node" selection:@"Concept Map View" input:@"null" pageNum:pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        [log writeToTextFile:logStr logTimeStampOrNot:YES];
    }
}


-(void)logLinkingConceptNodes: (NSString*)Concept1 ConnectedConcept: (NSString*)Concept2 {
    NSString* LogString=[[NSString alloc] initWithFormat:@"Linking concept: %@ with: %@. ", Concept1, Concept2];
    NSString* selectionString=[[NSString alloc] initWithFormat:@" %@ and %@. ", Concept1, Concept2];
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:LogString selection:selectionString input:@"null" pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
}


-(void)logHyperNavigation:(NSString*)ConceptName{
    NSString* LogString=[[NSString alloc] initWithFormat:@"Using hyperlink from concept: %@", ConceptName];
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:LogString selection:@"concept map view" input:@"null" pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
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
    //[self savePreviousStep];
    /*
     NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
     node.parentCmapController=self;
     node.showPoint=CGPointMake(position.x+39, position.y+15);;
     node.bookHighLight=bookHighlight;
     node.isInitialed=YES;
     node.bookTitle=bookTitle;
     node.bookthumbNailIcon=bookThumbNial;
     node.text.text=name;
     node.conceptName=name;
     [self addChildViewController:node];
     [conceptNodeArray addObject:node];
     [conceptMapView addSubview: node.view ];
     node.text.text=name;
     node.conceptName=name;
     */
    
    
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.createType=0;
    node.bookPagePosition=CGPointMake(0, 0);
    node.parentCmapController=self;
    node.showPoint=CGPointMake(position.x+39, position.y+15);
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
    node.pageNum=m_pageNum;
    node.conceptName=name;
    node.userName=userName;
    node.bookLogData=bookLogDataWrapper;
    [conceptNodeArray addObject:node];
    [self addChildViewController:node];
    [conceptMapView addSubview: node.view ];
    node.text.text=name;
    node.text.tag=nodeCount;//use nodeCount to identify the node.
    nodeCount++;
    [node becomeFirstResponder];
    
    //  [self autoSaveMap];
    //if([name isEqualToString:@"seeds"]||[name isEqualToString:@"bud"]||[name isEqualToString:@"fusion"]||[name isEqualToString:@"plant"]||[name isEqualToString:@"spores"]){
    //  node.text.text=@"???";
    // node.pageNum=-1;
    //}
    //[self autoSaveMap];
}


-(void)modifyMap{
    
    int numberToDelete = arc4random_uniform(8)+1;
    
    NSMutableArray* delAry=[[NSMutableArray alloc]init];
    
    for (int i=0; i<numberToDelete;i++){
        
        int ran=0;
        NSString* ranString=[NSString stringWithFormat: @"%d", ran];
        do {
            ran  = arc4random_uniform(10);
            ranString=[NSString stringWithFormat: @"%d", ran];
            
        } while ( [delAry containsObject: ranString]);
        [delAry addObject:ranString];
    }
    
    NSString* titleString=@"Sections deleted:";
    
    for (id obj in delAry) {
        NSString* objString=(NSString*)obj;
        titleString=[titleString stringByAppendingString:objString];
        titleString=[titleString stringByAppendingString:@", "];
        int objInt=[objString intValue];
        [self deleteConceptByIndex: objInt];
    }
    parentBookPageViewController.navigationController.navigationBar.topItem.title=titleString;
    if(!hasLogedModifyMap){
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Finish modifying expert concept map" selection:@"expert concept map" input:@"null" pageNum:pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        
        
        //save the number of concepts in the expert map to log file
        int conceptNum=(int)conceptNodeArray.count;
        NSString* conceptNumString= [[NSString alloc]initWithFormat:@"%d",conceptNum];
        LogData* countLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Number of Concepts in Expert Map" selection:@"expert concept map" input:conceptNumString pageNum:pageNum];
        [bookLogDataWrapper addLogs:countLog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        hasLogedModifyMap=YES;
    }
    
    
    //save expert map to file
    UIGraphicsBeginImageContextWithOptions(conceptMapView.bounds.size, NO, 0.0);
    [conceptMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor whiteColor] set];
    
    UIGraphicsEndImageContext();
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ExpertScreenShot.png"];
    
    // Save image.
    [UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
    
}



-(void)modifyExpertMap{
    int sectionsToShow = arc4random_uniform(8)+1;
    NSMutableArray* delAry=[[NSMutableArray alloc]init];
    for (int i=0; i<sectionsToShow;i++){
        int ran=0;
        NSString* ranString=[NSString stringWithFormat: @"%d", ran];
        do {
            ran  = arc4random_uniform(10);
            ranString=[NSString stringWithFormat: @"%d", ran];
        } while ( [delAry containsObject: ranString]);
        [delAry addObject:ranString];
    }
    
    
    for (id obj in delAry) {
        NSString* objString=(NSString*)obj;
        int objInt=[objString intValue];
        [self addConceptByIndex: objInt];
        //  [self deleteConceptByIndex:objInt];
    }
    
    
    int t=[conceptsShowAry count];
    NSMutableArray* delnamesAry=[[NSMutableArray alloc]init];
    for (NodeCell *node in conceptNodeArray){
        if (![conceptsShowAry containsObject: node.text.text]) // YES
        {
            NSString* del=node.text.text;
            [delnamesAry addObject:del];
        }
    }
    
    for(NSString* name in delnamesAry){
        [self deleteConcept:name];
    }
    
    
    
    //save the number of concepts in the expert map to log file
    int conceptNum=(int)conceptNodeArray.count;
    NSString* conceptNumString= [[NSString alloc]initWithFormat:@"%d",conceptNum];
    LogData* countLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Number of Concepts in Expert Map" selection:@"expert concept map" input:conceptNumString pageNum:pageNum];
    [bookLogDataWrapper addLogs:countLog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    hasLogedModifyMap=YES;
    
    
    
    //save expert map to file
    UIGraphicsBeginImageContextWithOptions(conceptMapView.bounds.size, NO, 0.0);
    [conceptMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor whiteColor] set];
    
    UIGraphicsEndImageContext();
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ExpertScreenShot.png"];
    
    // Save image.
    [UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
    
    
}

-(void)addConceptByIndex: (int)Index{
    
    switch ( Index )
    {
        case 0:
            [conceptsShowAry addObject:@"Water pollution"];
            [conceptsShowAry addObject:@"two types of sources"];
            break;
        case 1:
            [conceptsShowAry addObject:@"water quality"];
            [conceptsShowAry addObject:@"dissolved oxygen"];
            break;
        case 2:
            [conceptsShowAry addObject:@"Water pollution"];
            [conceptsShowAry addObject:@"agriculture"];
            break;
        case 3:
            [conceptsShowAry addObject:@"industry"];
            [conceptsShowAry addObject:@"organic chemical"];
            break;
        case 4:
            [conceptsShowAry addObject:@"mining"];
            [conceptsShowAry addObject:@"sediment"];
            break;
        case 5:
            [conceptsShowAry addObject:@"point source"];
            [conceptsShowAry addObject:@"single"];
            break;
        case 6:
            [conceptsShowAry addObject:@"nonpoint source"];
            [conceptsShowAry addObject:@"identify"];
            break;
        case 7:
            [conceptsShowAry addObject:@"nonpoint source"];
            [conceptsShowAry addObject:@"dispersed"];
            break;
        case 8:
            [conceptsShowAry addObject:@"organic chemical"];
            [conceptsShowAry addObject:@"chemical analysis"];
            break;
        case 9:
            [conceptsShowAry addObject:@"sediment"];
            [conceptsShowAry addObject:@"water evaporation"];
            break;
        default:
            ;
    }
}


-(void)deleteConceptByIndex: (int)Index{
    
    switch ( Index )
    {
        case 0:
            [self deleteConcept:@"Water pollution"];
            [self deleteConcept:@"two types of sources"];
            break;
        case 1:
            [self deleteConcept:@"water quality"];
            [self deleteConcept:@"dissolved oxygen"];
            break;
        case 2:
            [self deleteConcept:@"Water pollution"];
            [self deleteConcept:@"agriculture"];
            break;
        case 3:
            [self deleteConcept:@"industry"];
            [self deleteConcept:@"organic chemical"];
            break;
        case 4:
            [self deleteConcept:@"mining"];
            [self deleteConcept:@"sediment"];
            break;
        case 5:
            [self deleteConcept:@"point source"];
            [self deleteConcept:@"single"];
            break;
        case 6:
            [self deleteConcept:@"nonpoint source"];
            [self deleteConcept:@"identify"];
            break;
        case 7:
            [self deleteConcept:@"nonpoint source"];
            [self deleteConcept:@"dispersed"];
            break;
        case 8:
            [self deleteConcept:@"organic chemical"];
            [self deleteConcept:@"chemical analysis"];
            break;
        case 9:
            [self deleteConcept:@"sediment"];
            [self deleteConcept:@"water evaporation"];
            break;
        default:
            ;
    }
}


-(void)deleteConcept:(NSString*)name{
    [self savePreviousStep];
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:name]){
            [cell deleteNode:NO];
            return;
        }
    }
}




- (IBAction)clickOnBulb : (id)sender
{
    int r = arc4random_uniform(300)+50;
    CGPoint location=CGPointMake(r, 650);
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"creating new concept node" selection:@"new concept map node" input:@"null" pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
    [self addConceptOnClick: location];
    
    NSString* numString=[[NSUserDefaults standardUserDefaults] stringForKey:@"NumOfConcepts"];
    int numInt=[numString intValue];
    numInt++;
    numString=[[NSString alloc]initWithFormat:@"%d",numInt];
    [[NSUserDefaults standardUserDefaults] setObject:numString forKey:@"NumOfConcepts"];
    /*
     NSLog( @"click focus question");
     if(YES==isQuestionShow){
     [focusQuestionLable setHidden:YES];
     isQuestionShow=NO;
     }else{
     [focusQuestionLable setHidden:NO];
     isQuestionShow=YES;
     }
     */
}


- (IBAction)uppCmap : (id)sender
{
    [self uploadConceptMapImg];
}


-(void)createNodeFromBook:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition page:(int)m_pageNum{
     [self savePreviousStep];
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:name]){
            NSString* msg=[[NSString alloc]initWithFormat:@"Concept %@ already exist.", name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=1;
            [alert show];
            return;
        }
    }
    
    
    LogData* log= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"creating concept node from book " selection:@"textbook" input:name pageNum:pageNum];
    [bookLogDataWrapper addLogs:log];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
    
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.createType=1;
    node.parentCmapController=self;
    node.bookLogData=bookLogDataWrapper;
    node.bookPagePosition=bookPosition;
    node.showPoint=position;
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
    node.enableHyperLink=YES;
    node.pageNum=m_pageNum-1;
    [conceptNodeArray addObject:node];
    [self addChildViewController:node];
    [conceptMapView addSubview: node.view ];
    node.text.tag=nodeCount;//use nodeCount to identify the node.
    node.text.text=name;
    [node updateViewSize];
    nodeCount++;
    NSString* numString=[[NSUserDefaults standardUserDefaults] stringForKey:@"NumOfConcepts"];
    int numInt=[numString intValue];
    numInt++;
    numString=[[NSString alloc]initWithFormat:@"%d",numInt];
    [[NSUserDefaults standardUserDefaults] setObject:numString forKey:@"NumOfConcepts"];
    [self autoSaveMap];
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



-(void)addConceptOnClick: (CGPoint)clickPoint
{
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.createType=1;
    node.parentCmapController=self;
    node.showPoint=clickPoint;
    node.bookLogData=bookLogDataWrapper;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.bookthumbNailIcon=bookThumbNial;
    [self addChildViewController:node];
    [conceptNodeArray addObject:node];
    [conceptMapView addSubview: node.view ];
    addedNode=node;
}

-(void)scrollCmapView :(CGFloat)length
{
    [conceptMapView setContentOffset:CGPointMake(0, length) animated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    nodeTextBeforeEditing=textField.text;
    
    textField.text=@"";
    CGSize screenSZ=[self screenSize];
    CGFloat offSet=(textField.superview.frame.size.height+ textField.superview.frame.origin.y)-(768-352);
    // NSLog(@"Offset: %f",offSet);
    if(offSet>0){
        // NSLog(@"Blocked by keyboard!!");
        [self scrollCmapView:(offSet+100)];
    }
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    linkTextBeforeEditing=textView.text;
    textView.text=@"";
    CGSize screenSZ=[self screenSize];
    CGFloat offSet=(textView.superview.frame.size.height+ textView.superview.frame.origin.y)-(768-352);
    // NSLog(@"Offset: %f",offSet);
    if(offSet>0){
        // NSLog(@"Blocked by keyboard!!");
        [self scrollCmapView:(offSet+100)];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Finish editting concept node name" selection:nodeTextBeforeEditing input:textField.text pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0&&alertView.tag==1)
    {
        [addedNode.text becomeFirstResponder];
        //Code for OK button
    }
    if (buttonIndex == 1&&alertView.tag==2)
    {
        for (NodeCell *cell in conceptNodeArray)
        {
            [cell removeLink];
            [cell.view removeFromSuperview];
        }
        
        [conceptNodeArray removeAllObjects];
        [conceptLinkArray removeAllObjects];
        [bookLinkWrapper clearAllData];
        [bookNodeWrapper clearAllData];
        [self updatePreviewLocation];
        [self getPreView:nil];
        [self autoSaveMap];
        
        
        [contentView setFrame:CGRectMake(0, 0, conceptMapView.frame.size.width, conceptMapView.frame.size.height)];
        
        
       // [contentView setFrame:conceptMapView.frame];
       // [conceptMapView setContentSize:contentView.frame.size];
         //[conceptMapView setFrame:self.view.frame];
        //[self SaveCmapSize:contentView.frame.size.width Height:contentView.frame.size.height];
        //[self getPreView:nil];
        //[self updatePreviewLocation];

        [parentBookPageViewController.bookView clearALlHighlight];
        parentBookPageViewController.bookView.currentContentView.bookHighLight=parentBookPageViewController.bookView.highLight;
        [parentBookPageViewController.bookView.currentContentView refresh];
        
        //Code for OK button
    }
    if (buttonIndex == 1)
    {
        //Code for download button
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    /*
     if ([addedNode.text.text isEqualToString:@""] ){
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Node is empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     //[alert show];
     //[addedNode.text becomeFirstResponder];
     }
     */
    [self scrollCmapView: -10];
}


- (void)keyboardDidHide:(NSNotification*)notification {
    int sameNodeCount=0;
    if ([addedNode.text.text isEqualToString:@""] ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Node is empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // [alert show];
    }else{
        for(NodeCell* cell in conceptNodeArray){
            if([addedNode.text.text isEqualToString:cell.text.text]){
                sameNodeCount++;
            }
        }//end for
        if(sameNodeCount>1){
            NSString* msg=[[NSString alloc]initWithFormat:@"Node %@ already exists!",addedNode.text.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            // return;
        }//end if
        
    }//end else
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


- (IBAction)upLoad:(id)sender {
    
    [neighbor_BookViewController.parent_BookPageViewController upLoadCmap];
    [neighbor_BookViewController.parent_BookPageViewController upLoadLogFile];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Uploading log file...";
    [HUD showWhileExecuting:@selector(WaitingTask) onTarget:self withObject:nil animated:YES];
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



//- (void)textViewDidEndEditing:(UITextView *)textView{
- (void)textViewDidEndEditing:(UITextView *)textView{
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Finish editting concept link name" selection:linkTextBeforeEditing input:textView.text pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
    /*
     if(textView.text.length<5){
     textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, 40, textView.frame.size.height);
     }*/
    
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


-(void)upDateLinkText: (NSString*)text{
    linkJustAdded.relation.text=text;
    //auto resize the textview
    CGRect textFrame=linkJustAdded.relation.frame;
    textFrame.size.width=7*text.length+20;
    linkJustAdded.relation.frame=textFrame;
    
}

-(void)editRelationLink{
    linkJustAdded.relation.editable=YES;
    [linkJustAdded.relation becomeFirstResponder];
}


- (void)WaitingTask {
    sleep(1);
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPreView:nil];
    // [self loadConceptMap:nil];
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

- (void)doubleTapped:(UITapGestureRecognizer *)tap
{
    NSArray *popUpContent=[NSArray arrayWithObjects:@"Highlight", nil];
    
    PopoverView* pv = [PopoverView showPopoverAtPoint:[tap locationInView:self.view]
                                               inView:self.view
                                            withTitle:@"Resource"
                                      withStringArray:popUpContent
                                             delegate:self];
}




-(void)clearAllHighlight{
    for(NodeCell* cell in conceptNodeArray){
        [cell unHighlightNode];
    }
}


-(void)highlightLink: (int)page{
    
    for(ConceptLink *link in conceptLinkArray){
        if(link.pageNum==pageNum){
            NodeCell* left=link.leftNode;
            [left highlightLink:link.righttNode.text.text];
            
        }
    }
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}


- (IBAction)getPreView:(id)sender {
    [parentBookPageViewController addConceptMapPreview:conceptNodeArray Links:conceptLinkArray CMapFrame:contentView.frame];
}


-(void)removePreviewNode: (NSString*)nodeName{
    
}


- (IBAction)hidePreView:(id)sender {
    [parentBookPageViewController hideAndShowPreView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updatePreviewLocation];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale{
    
    [self SaveCmapSize:contentView.frame.size.width Height:contentView.frame.size.height];
    
    [self getPreView:nil];
    [self updatePreviewLocation];
}


-(void)updatePreviewLocation{
    
    if(0==conceptMapView.contentSize.height){
        return;
    }
    if(0==conceptMapView.contentSize.width){
        return;
    }
    CGPoint position=conceptMapView.contentOffset;
    float xRatio=parentBookPageViewController.previewImg.frame.size.width/conceptMapView.contentSize.width;
    float yRatio=parentBookPageViewController.previewImg.frame.size.height/conceptMapView.contentSize.height;
    
    position.x= position.x*xRatio;
    position.y= position.y*yRatio;
    
    if(position.x<1||position.y<1){
        // return;
    }
    CGRect fra=parentBookPageViewController.PreviewRect.frame;
    [parentBookPageViewController.PreviewRect setFrame:CGRectMake(position.x+2, position.y+2, fra.size.width, fra.size.height)];
    
}

-(void)updateNodesPosition: (CGPoint)position Node: (NodeCell*)m_node{
    [self savePreviousStep];
    int index=0;
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:m_node.text.text]){
            cell.showPoint=m_node.view.center;
        }
        index++;
    }
}

-(void)showAlertwithTxt :(NSString*)title body: (NSString*)txt{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:txt delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self SetNodesFirstResponder];
}

-(BOOL)isLinkExist: (NSString*)name1 OtherName: (NSString*)name2{
    
    for(ConceptLink* m_link in conceptLinkArray){
        if([m_link.leftNode.text.text isEqualToString:name1]&&[m_link.righttNode.text.text isEqualToString:name2]){
            return YES;
        }
        
        if([m_link.leftNode.text.text isEqualToString:name2]&&[m_link.righttNode.text.text isEqualToString:name1]){
            return YES;
        }
        
    }
    return NO;
}


-(void)SetNodesFirstResponder{
    
    for(NodeCell* cell in conceptNodeArray){
        [cell becomeFirstResponder];
    }
}



- (void) uploadConceptMapImg{
    /*
     UIGraphicsBeginImageContextWithOptions(conceptMapView.bounds.size, NO, 0.0);
     [conceptMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
     [[UIColor whiteColor] set];
     
     UIGraphicsEndImageContext();
     
     
     
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ExpertScreenShot.png"];
     
     // Save image.
     // [UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
     
     //return img;
     
     NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
     sessionConfiguration.HTTPAdditionalHeaders = @{
     @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
     @"Content-Type"  : @"application/zip"
     };
     
     
     //make a file name to write the data to using the documents directory:
     NSString *documentsDirectory = [paths objectAtIndex:0];
     
     NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
     usedEncoding:nil
     error:nil];
     // NSString *filename = @"Maps/ScreenShot.png";
     // NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
     //NSString *localPath = [localDir stringByAppendingPathComponent:filename];
     /// [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
     
     
     NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/auto/%@?overwrite=false",filename]]];
     [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
     NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
     [request setHTTPMethod:@"PUT"];
     [request setHTTPBody:data];
     [request setTimeoutInterval:1000];
     
     NSURLSessionDataTask *doDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     if (!error){
     NSLog(@"WORKED!!!!");
     } else {
     NSLog(@"ERROR: %@", error);
     }
     }];
     
     [doDataTask resume];
     */
}


-(void)deleteLink: (NSString* )leftName SecondNode: (NSString*)rightName{
    [self savePreviousStep];
    NSLog(@"%@",leftName);
    NSLog(@"%@",rightName);
    NodeCell* lNode;
    NodeCell* rNode;
    ConceptLink* linkBk;
    
    /*
     for(NodeCell* cell in conceptNodeArray){
     [cell removeLink];
     }*/
    
    
    for( ConceptLink* link in conceptLinkArray ){
        if([link.leftNode.text.text isEqualToString:leftName]&& [link.righttNode.text.text isEqualToString:rightName] ){
            linkBk=link;
        }
        if([link.leftNode.text.text isEqualToString:rightName]&& [link.righttNode.text.text isEqualToString:leftName] ){
            linkBk=link;
        }
    }
    [conceptLinkArray removeObject:linkBk];
    
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:leftName]){
            lNode=cell;
        }
        if([cell.text.text isEqualToString:rightName]){
            rNode=cell;
        }
    }
    // [lNode deleteLinkWithNode:rNode];
    [lNode removeLinkWithNode:rNode];
    // [rNode deleteLinkWithNode:lNode];
    [self autoSaveMap];
    //[self loadConceptMap: nil];
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

-(void)uploadCmapCocneptAddedList{
    
    
    NSString* input=@"";
    for(NodeCell* m_node in conceptNodeArray){
        if(1==m_node.createType){//added by user
            input=[input stringByAppendingString:m_node.text.text];
            input=[input stringByAppendingString:@", "];
        }
    }
    
    NSString* LogString=@"concepts added by student";
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:LogString selection:@"concept map view" input:input pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
}


-(void)uploadCMapImg
{
    
    //Log user added concepts
    
    
    /*
     UIGraphicsBeginImageContext(conceptMapView.contentSize);
     
     CGPoint savedContentOffset = conceptMapView.contentOffset;
     CGRect savedFrame = conceptMapView.frame;
     
     conceptMapView.contentOffset = CGPointZero;
     conceptMapView.frame = CGRectMake(0, 0, conceptMapView.contentSize.width,  conceptMapView.contentSize.height);
     [conceptMapView.layer renderInContext: UIGraphicsGetCurrentContext()];
     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
     
     conceptMapView.contentOffset = savedContentOffset;
     conceptMapView.frame = savedFrame;
     
     [conceptMapView resignFirstResponder];
     UIGraphicsEndImageContext();
     */
    
    
    /*
     UIGraphicsBeginImageContextWithOptions(conceptMapView.bounds.size, conceptMapView.opaque, 0.0);
     [conceptMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
     [[UIColor whiteColor] set];
     
     UIGraphicsEndImageContext();
     */
    
    /*
     UIGraphicsBeginImageContext(conceptMapView.contentSize);
     
     CGPoint savedContentOffset = conceptMapView.contentOffset;
     CGRect savedFrame = conceptMapView.frame;
     
     conceptMapView.contentOffset = CGPointZero;
     conceptMapView.frame = CGRectMake(0, 0, conceptMapView.contentSize.width,  conceptMapView.contentSize.height);
     [conceptMapView.layer renderInContext: UIGraphicsGetCurrentContext()];
     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
     
     conceptMapView.contentOffset = savedContentOffset;
     conceptMapView.frame = savedFrame;
     
     [conceptMapView resignFirstResponder];
     UIGraphicsEndImageContext();
     */
    UIGraphicsBeginImageContextWithOptions(conceptMapView.bounds.size, NO, 0.0);
    [conceptMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor whiteColor] set];
    
    UIGraphicsEndImageContext();
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FinalScreenShot.png"];
    
    // Save image.
    [UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
    
    //return img;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    //make a file name to write the data to using the documents directory:
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
                                                    usedEncoding:nil
                                                           error:nil];
    NSString *filename = @"TurkStudyMaps/";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    filename=[filename stringByAppendingString:usrName];
    
    filename=[filename stringByAppendingString:@"_FinalMap.png"];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    // [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/auto/%@?overwrite=false",filename]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    [request setTimeoutInterval:1000];
    
    NSURLSessionDataTask *doDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"WORKED!!!!");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    [doDataTask resume];
    
}


-(void)uploadExpertCMapImg
{
    
    UIGraphicsBeginImageContextWithOptions(conceptMapView.bounds.size, NO, 0.0);
    [conceptMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor whiteColor] set];
    
    UIGraphicsEndImageContext();
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ExpertScreenShot.png"];
    
    // Save image.
    // [UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
    
    // Save image.
    //[UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
    
    //return img;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    //make a file name to write the data to using the documents directory:
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath
                                                    usedEncoding:nil
                                                           error:nil];
    
    
    NSString *filename = @"TurkStudyMaps/";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    filename=[filename stringByAppendingString:usrName];
    filename=[filename stringByAppendingString:@"_ExpertMap.png"];
    
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    // [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/auto/%@?overwrite=false",filename]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    [request setTimeoutInterval:1000];
    
    NSURLSessionDataTask *doDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"WORKED!!!!");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    [doDataTask resume];
    
}


- (IBAction)uploadTurkExpertMap:(id)sender {
}


-(void)upLoadExpertLinktoDropbox{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/ExpertCmapLinkList.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    
    
    NSString *filename = @"ExpertMap/ExpertLink";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    filename=[filename stringByAppendingString:userName];
    filename=[filename stringByAppendingString:@".xml"];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/auto/%@?overwrite=false",filename]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    [request setTimeoutInterval:1000];
    
    NSURLSessionDataTask *doDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"WORKED!!!!");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    [doDataTask resume];
    
}



-(void)upLoadExpertNodetoDropbox{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/ExpertCmapNodeList.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    
    
    NSString *filename = @"ExpertMap/ExpertNode";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    filename=[filename stringByAppendingString:userName];
    filename=[filename stringByAppendingString:@".xml"];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/auto/%@?overwrite=false",filename]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    [request setTimeoutInterval:1000];
    
    NSURLSessionDataTask *doDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"WORKED!!!!");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    [doDataTask resume];
    
}

-(void)LogStudentMapNum{
    //save the number of concepts in the expert map to log file
    int conceptNum=(int)conceptNodeArray.count;
    NSString* conceptNumString= [[NSString alloc]initWithFormat:@"%d",conceptNum];
    LogData* countLog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Number of Concepts in Student Map" selection:@"student concept map" input:conceptNumString pageNum:pageNum];
    [bookLogDataWrapper addLogs:countLog];
    [LogDataParser saveLogData:bookLogDataWrapper];
}

-(void)readSavedCmapSize{
    NSString* widthString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedWidth"];
    savedMapWidth=[widthString intValue];
    NSString* heightString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedheight"];
    savedMapHeight=[heightString intValue];
    if(savedMapWidth>contentView.frame.size.width){
     [contentView setFrame:CGRectMake(0, 0, savedMapWidth, savedMapHeight)];
        [conceptMapView setContentSize:CGSizeMake(savedMapWidth, savedMapHeight)];
    }
    
}


-(void)SaveCmapSize:(int)width Height: (int)height{
    savedMapWidth=width;
    savedMapHeight=height;
    NSString* widthString= [NSString stringWithFormat:@"%d",width];
    NSString* heightString= [NSString stringWithFormat:@"%d",height];
    
    [[NSUserDefaults standardUserDefaults] setObject:widthString forKey:@"savedWidth"];
    [[NSUserDefaults standardUserDefaults] setObject:heightString forKey:@"savedheight"];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

- (IBAction)deleteAll:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to delete the whole map?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Yes",nil];
    alert.tag=2;
    [alert show];
}
- (IBAction)undo:(id)sender {
    
    
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
            if([link.leftConceptName isEqualToString:node.conceptName]){
                c1=node;
            }
            if([link.rightConceptName isEqualToString:node.conceptName]){
                c2=node;
            }
        }
        [c1 createLink:c2 name:link.relationName];
    }
}


-(void)deleteHighlightwithWord: (NSString*)name{
    [parentBookPageViewController.bookView deleteHighlightWithWord:name];
    parentBookPageViewController.bookView.currentContentView.bookHighLight=parentBookPageViewController.bookView.highLight;
    [parentBookPageViewController.bookView.currentContentView refresh];
}


@end

