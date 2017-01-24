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
#import "ZCTradeView.h"
#import "MyAlertView.h"
#import "TrainingViewController.h"
#import "PopoverView.h"
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
@synthesize positionBeforeZoom;
@synthesize sacleBeforeZooming;
@synthesize isTraining;
@synthesize parentTrainingCtr;
@synthesize isNavigateTraining;
@synthesize isPinchTraining;
@synthesize isAlertShowing;
@synthesize isHyperlinkTraining;
@synthesize isAddNodeTraining;
@synthesize isKeyboardOffset;
@synthesize keyboardOffset;
@synthesize linkJustCreated;
@synthesize upLoadIcon;
@synthesize showingPV;
@synthesize noteTakingNode;
@synthesize correctIndexAry;
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
    sacleBeforeZooming=1;
    [super viewDidLoad];
    addedNode=nil;
    
    
    [upLoadIcon  setEnabled:NO];
    [upLoadIcon setTintColor: [UIColor clearColor]];
    
    // if(2==showScenarioId){//the view is initialized in the book page.
    CGRect rect=CGRectMake(530, 0, 511, 768);
    [self.view setFrame:rect];
    //[self.conceptMapView setFrame:CGRectMake(0, 0, 494, 768)];
    //}
    CGRect rect2=CGRectMake(0, 0, 511, 768);
    contentView= [[UIView alloc]init];
    [contentView setFrame:conceptMapView.frame];
    [conceptMapView addSubview:contentView];
    
    conceptMapView.delegate=self;
    conceptMapView.minimumZoomScale = 1.0;
    conceptMapView.maximumZoomScale = 10.0;
    bookLinkWrapper= [[CmapLinkWrapper alloc]init];
    bookNodeWrapper= [[CmapNodeWrapper alloc]init];
    knowledgeModule=[ [KnowledgeModule alloc] init ];
    conceptNamesArray=[[NSMutableArray alloc] init];
    positionBeforeZoom=[[NSMutableArray alloc] init];
    
    conceptNodeArray=[[NSMutableArray alloc] init];
    conceptLinkArray=[[NSMutableArray alloc] init];
    conceptsShowAry=[[NSMutableArray alloc] init];
    lastStepConceptNodeArray=[[NSMutableArray alloc] init];
    lastStepConceptLinkArray=[[NSMutableArray alloc] init];
    
  //  myWebView=[[WebBrowserViewController alloc]initWithNibName:@"WebBrowserViewController" bundle:nil];
    
    [self.navigationController setDelegate:self];
    // [self.navigationController setNavigationBarHidden: YES animated:NO];
    /*
     GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
     overlay.dataSource = self;
     overlay.delegate = self;
     */
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolBarTap:)];
    tapGesture.numberOfTapsRequired=3;
    tapGesture.delegate=self;
    [toolBar addGestureRecognizer:tapGesture];
    
    
    
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
    
    
    UITapGestureRecognizer *cmapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTap:)];
    cmapTap.delegate=self;
   // [self.view addGestureRecognizer:cmapTap];
    
    
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
    conceptMapView.maximumZoomScale=5.0;
   // conceptMapView.zoomScale=2.0;
    //[self readSavedCmapSize];
    if(!parentBookPageViewController.isTraining){
        [self readSavedCmapScale];
        //[self readSavedOrigin];
    }
    if(!isTraining){
        [self loadConceptMap:nil];
    }
    [self.view bringSubviewToFront:toolBar];
    
    if(conceptMapView.zoomScale<1.2){
        conceptMapView.zoomScale=3.0;
    }
    [self getPreView:nil];
    [self updatePreviewLocation];
    
}




-(void)uploadCmapXML{
    [self uploadMapLinkXML];
    [self uploadMapNodeXML];
    
}

-(void)uploadMapNodeXML{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    //make a file name to write the data to using the documents directory:
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory
                          stringByAppendingPathComponent:@"CmapNodeList.xml"];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSString *filename = @"HighSchoolMapNode/";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    // filename=[filename stringByAppendingString:usrName];
    
    NSString* iPadId=[[NSUserDefaults standardUserDefaults] stringForKey:@"iPadId"];
    filename=[filename stringByAppendingString:iPadId];
    
    filename=[filename stringByAppendingString:@"_CmapNodeList.xml"];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish Upload Logfile" message:@"Success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            // [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish Upload Logfile" message:@"Error!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            // [alertView show];
        }
    }];
    [doDataTask resume];
    
}

-(void)uploadMapLinkXML{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    //make a file name to write the data to using the documents directory:
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory
                          stringByAppendingPathComponent:@"CmapLinkList.xml"];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSString *filename = @"HighSchoolMapLink/";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    // filename=[filename stringByAppendingString:usrName];
    
    NSString* iPadId=[[NSUserDefaults standardUserDefaults] stringForKey:@"iPadId"];
    filename=[filename stringByAppendingString:iPadId];
    
    filename=[filename stringByAppendingString:@"_CmapLinkList.xml"];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish Upload Logfile" message:@"Success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //[alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish Upload Logfile" message:@"Error!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            // [alertView show];
        }
    }];
    [doDataTask resume];
}


- (void)toolBarTap:(UILongPressGestureRecognizer *)gestureRecognizer{
    [upLoadIcon  setEnabled:YES];
    [upLoadIcon setTintColor: nil];
}


//The search button on toolbar
- (IBAction)hideAndShow:(id)sender {
    [parentBookPageViewController hideAndShowPreView];
    
}


-(void)showAndHidePreview:(id)sender {
    //[parentBookPageViewController hideAndShowPreView];
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
    [self updatePreviewLocation];
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
        // return NULL;
    }
    return contentView;
}



//Loads concept map
- (IBAction)loadConceptMap:(id)sender {
    
    
    for(NSString* idneString in correctIndexAry){
        
    }
    
    
    
    
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
    
    
    //////start creating map//////
    for(CmapNode* cell in bookNodeWrapper.cmapNodes){
        //check if this node should be created////
        
       
        
        
        [self createNode:CGPointMake(cell.point_x, cell.point_y) withName:cell.text page:cell.pageNum url:cell.linkingUrl urlTitle: cell.linkingUrlTitle hasNote: cell.hasNote hasHighlight: cell.hasHighlight hasWebLink: cell.hasWebLink savedNotesString: cell.savedNotesString];
        
        
    }
    for(CmapLink* link in bookLinkWrapper.cmapLinks){
        //check if the link should exist///
        
        
        
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
       // [self modifyExpertMap];
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
        
        [self createNode:CGPointMake(cell.point_x, cell.point_y) withName:cell.text page:cell.pageNum url:cell.linkingUrl];
        
        
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
        CmapNode* node= [[CmapNode alloc] initWithName: m_node.text.text bookTitle:m_node.bookTitle positionX:m_node.view.frame.origin.x positionY:m_node.view.frame.origin.y Tag:m_node.text.tag page:m_node.pageNum url:m_node.linkingUrl.absoluteString urlTitle: m_node.linkingUrlTitle hasNote:m_node.hasNote hasHighlight:m_node.hasHighlight hasWebLink:m_node.hasWeblink savedNotesString: m_node.appendedNoteString];
        [bookNodeWrapper addthumbnail:node];
    }
    //[CmapNodeParser saveCmapNode:bookNodeWrapper];
    [CmapNodeParser saveExpertCmapNode:bookNodeWrapper];
}

-(void)savePreviousStep{
    lastStepConceptLinkArray= [[NSMutableArray alloc] initWithArray:conceptLinkArray];
    lastStepConceptNodeArray= [[NSMutableArray alloc] initWithArray:conceptNodeArray];
}


-(void)autoSaveMap{ //This is to save the current concept map in the log files
    if(isTraining){
        return;
    }
    
    
    [bookLinkWrapper clearAllData];
    [bookNodeWrapper clearAllData];
    for(ConceptLink* m_link in conceptLinkArray){
        CmapLink* link= [[CmapLink alloc] initWithName:m_link.leftNode.text.text conceptName:m_link.righttNode.text.text relation:m_link.relation.text page:pageNum];
        
        [bookLinkWrapper addLinks:link];
    }
    [ CmapLinkParser saveCmapLink:bookLinkWrapper];
    for(NodeCell* m_node in conceptNodeArray){
     //   NSLog([NSString stringWithFormat: @"Note String at auto save: %@", m_node.appendedNoteString]);
        CmapNode* node= [[CmapNode alloc] initWithName: m_node.text.text bookTitle:m_node.bookTitle positionX:m_node.view.frame.origin.x positionY:m_node.view.frame.origin.y Tag:m_node.text.tag page:m_node.pageNum url:m_node.linkingUrl.absoluteString urlTitle: m_node.linkingUrlTitle hasNote:m_node.hasNote hasHighlight:m_node.hasHighlight hasWebLink:m_node.hasWeblink savedNotesString: m_node.appendedNoteString];
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
    NSString* LogString=[[NSString alloc] initWithFormat:@"Linking concept: %@ with: %@.", Concept1, Concept2];
    NSString* selectionString=[[NSString alloc] initWithFormat:@" %@ and %@. ", Concept1, Concept2];
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:LogString selection:selectionString input:@"null" pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
}

/*
-(void)logHyperNavigation:(NSString*)ConceptName{
    NSString* LogString=[[NSString alloc] initWithFormat:@"Using hyperlink from concept: %@", ConceptName];
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:LogString selection:@"concept map view" input:@"null" pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
}*/

-(void)disableAllNodesEditting{
    for (NodeCell *node in conceptNodeArray){
      //  node.text.enabled=NO;
    }
}
-(void)enableAllNodesEditting{
    for (NodeCell *node in conceptNodeArray){
      //  node.text.enabled=YES;
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
//Used to create nodes when map is loading
-(void)createNode:(CGPoint)position withName:(NSString*) name page: (int)m_pageNum  url:(NSURL*)m_linkingUrl urlTitle: (NSString *) m_linkingUrlTitle hasNote: (BOOL) m_hasNote hasHighlight: (BOOL) m_hasHighlight hasWebLink: (BOOL) m_hasWebLink savedNotesString: (NSString *) m_noteString{
    
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
    node.appendedNoteString = m_noteString;
    [conceptNodeArray addObject:node];
    if(m_hasNote){
        node.hasNote = YES;
    }
    if(m_hasWebLink){
        node.hasWeblink = YES;
    }
    if(m_hasHighlight) {
        node.hasHighlight = YES;
    }
    [self addChildViewController:node];
    [conceptMapView addSubview: node.view ];
    node.text.text=name;
    node.text.tag=nodeCount;//use nodeCount to identify the node.
    nodeCount++;
    node.linkingUrl = m_linkingUrl;
    node.linkingUrlTitle = m_linkingUrlTitle;
 
    [node becomeFirstResponder];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view.subviews]) {
        return NO;
    }
    return YES;
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
    int sectionsToShow = arc4random_uniform(10);
    //sectionsToShow=0;
    // if(sectionsToShow!=9&&sectionsToShow!=10){
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
    
    // }//end if !=10&&!=0
    
    
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


-(IBAction)mapViewTap:(id)sender{
    if(isReadyToLink){
        [nodesToLink removeShadowAnim];
        [nodesToLink becomeFirstResponder];
        nodesToLink=nil;
        isReadyToLink=NO;
    }
}

//The  "+" button on the toolbar, create a node
- (IBAction)clickOnBulb : (id)sender
{
    
    if(isReadyToLink){
        [parentBookPageViewController showAlertWithText:@"There is a concept waiting to be linked!"];
        return;
    }
    int r = arc4random_uniform(300)+50;
    //r = arc4random_uniform(300)+50;
    
    CGPoint location=CGPointMake(r, 150);
    
    location.x+=conceptMapView.contentOffset.x;
    location.y+=conceptMapView.contentOffset.y;
    
    
    
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"creating new concept node" selection:@"new concept map node" input:@"null" pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
    [self addConceptOnClick: location];
    
    
    NSString* numString=[[NSUserDefaults standardUserDefaults] stringForKey:@"NumOfConcepts"];
    int numInt=[numString intValue];
    numInt++;
    numString=[[NSString alloc]initWithFormat:@"%d",numInt];
    [[NSUserDefaults standardUserDefaults] setObject:numString forKey:@"NumOfConcepts"];
    
    
    [self getPreView:nil];
    [self updatePreviewLocation];
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

//For nodes created from book and web browser
-(void)createNodeFromBook:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition page:(int)m_pageNum{
    [self savePreviousStep];
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:name]){//Node already exists
            NSString* msg=[[NSString alloc]initWithFormat:@"Concept %@ already exist.", name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=1;
            [alert show];
            return;
        }
    }
    
    CGPoint pointInView=position;
    pointInView.x+=conceptMapView.contentOffset.x;
    pointInView.y+=conceptMapView.contentOffset.y;
    //Saves info into log file
    if (m_pageNum == 0){ //Made from Web Browser
        LogData* log= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"creating concept node from web browser " selection:@"web browser" input:name pageNum:0];
        [bookLogDataWrapper addLogs:log];
        [LogDataParser saveLogData:bookLogDataWrapper];
    }
    else{//from book
        LogData* log= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"creating concept node from book " selection:@"textbook" input:name pageNum:m_pageNum];
        [bookLogDataWrapper addLogs:log];
        [LogDataParser saveLogData:bookLogDataWrapper];
    }

    //creates node
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.createType=1;
    node.parentCmapController=self;
    node.bookLogData=bookLogDataWrapper;
    node.bookPagePosition=bookPosition;
    node.showPoint=pointInView;
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
    node.enableHyperLink=YES;
    node.pageNum=m_pageNum-1;
    if (m_pageNum == 0){ //Made from Web Browser
        [node setLinkingUrl];
        node.hasWeblink = YES;
    }
    else {
        node.hasHighlight = YES; //made from book
    }
    [conceptNodeArray addObject:node];
    [self addChildViewController:node];
    [conceptMapView addSubview: node.view ];
    node.text.tag=nodeCount;//use nodeCount to identify the node.
    node.text.text=name;

    node.conceptName=name;
    [node updateViewSize];
    nodeCount++;
    NSString* numString=[[NSUserDefaults standardUserDefaults] stringForKey:@"NumOfConcepts"];
    int numInt=[numString intValue];
    numInt++;
    numString=[[NSString alloc]initWithFormat:@"%d",numInt];
    [[NSUserDefaults standardUserDefaults] setObject:numString forKey:@"NumOfConcepts"];
    
    node.updateViewSize;
    [self getPreView:nil];
    [self updatePreviewLocation];
    [self autoSaveMap];
}

-(NodeCell*)createNodeFromBookForLink:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition page:(int)m_pageNum{
    [self savePreviousStep];
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:name]){
            NSString* msg=[[NSString alloc]initWithFormat:@"Concept %@ already exist.", name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=1;
            [alert show];
            return nil;
        }
    }
    
    CGPoint pointInView=position;
    pointInView.x+=conceptMapView.contentOffset.x;
    pointInView.y+=conceptMapView.contentOffset.y;
    
    LogData* log= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"creating concept node from book " selection:@"textbook" input:name pageNum:pageNum];
    [bookLogDataWrapper addLogs:log];
    [LogDataParser saveLogData:bookLogDataWrapper];
    
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.createType=1;
    node.parentCmapController=self;
    node.bookLogData=bookLogDataWrapper;
    node.bookPagePosition=bookPosition;
    node.showPoint=pointInView;
    node.isInitialed=YES;
    node.bookthumbNailIcon=bookThumbNial;
    node.bookHighLight=bookHighlight;
    node.bookTitle=bookTitle;
    node.showType=showType;
    node.enableHyperLink=YES;
    node.pageNum=m_pageNum-1;
    node.showType=2;
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
    
    [self getPreView:nil];
    [self autoSaveMap];
    return node;
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


//from click on bulb adds a node
-(void)addConceptOnClick: (CGPoint)clickPoint
{
    NodeCell *node=[[NodeCell alloc]initWithNibName:@"NodeCell" bundle:nil];
    node.hasNote = YES; // created manually
    node.createType=1;
    node.parentCmapController=self;
    node.showPoint=clickPoint;
    node.bookLogData=bookLogDataWrapper;
    node.bookHighLight=bookHighlight;
    node.pageNum=self.parent_ContentViewController.pageNum - 1;
    node.bookTitle=bookTitle;
    node.bookthumbNailIcon=bookThumbNial;
    [self addChildViewController:node];
    [conceptNodeArray addObject:node];
    [conceptMapView addSubview: node.view ];
    addedNode=node;
    
    node.updateViewSize;
}

-(void)scrollCmapView :(CGFloat)length
{
    //  [conceptMapView setContentOffset:CGPointMake(conceptMapView.contentOffset.x, 10+conceptMapView.contentOffset.y) animated:YES];
    [conceptMapView setContentOffset:CGPointMake(conceptMapView.contentOffset.x, length+conceptMapView.contentOffset.y) animated:YES];
    
    isKeyboardOffset=YES;
    keyboardOffset=length;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    nodeTextBeforeEditing=textField.text;
    // textField.text=@"";
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
    if (buttonIndex == 1&&alertView.tag==2)//delete map was selected
    {
        LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"deleting whole concept view" selection:@"Concept Map View" input:@"null" pageNum:pageNum];
        [bookLogDataWrapper addLogs:newlog];
        [LogDataParser saveLogData:bookLogDataWrapper];
        
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
        self.conceptMapView.zoomScale=1.0;
        [self SaveCmapScale:1.0];
        
        //  [contentView setFrame:CGRectMake(0, 0, conceptMapView.frame.size.width, conceptMapView.frame.size.height)];
        
        
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
    }if (buttonIndex == 1&&alertView.tag==3){
        NSString *pasd = [alertView textFieldAtIndex:0].text;
        if([pasd isEqualToString:@"2sigma"]){
            NSLog(@"Correct");
            [self upLoadLogFiletoDropBox];
            [self uploadCMapImg];
            [self uploadCmapXML];
            
        }else{
            [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(targetMethod:)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
    
    
    
    if (buttonIndex == 1)
    {
        //Code for download button
    }
}




-(void) targetMethod:(NSTimer*)_timer{
    
    MyAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Wrong Password" message:@"Please input correct password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.tag=3;
    alertView.delegate=self;
    [alertView show];
}



- (void)keyboardWillHide:(NSNotification*)notification {

    /*
     if ([addedNode.text.text isEqualToString:@""] ){
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Node is empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     //[alert show];
     //[addedNode.text becomeFirstResponder];
     }
     */
    
    int sameNodeCount=0;
    for(NodeCell* cell in conceptNodeArray){
        if([addedNode.text.text isEqualToString:cell.text.text]){
            sameNodeCount++;
        }
    }
    
    if(isKeyboardOffset&&(![addedNode.text.text isEqualToString:@""]&&(sameNodeCount<2))){
        [self scrollCmapView: -keyboardOffset];
        isKeyboardOffset=NO;
    }
}


- (void)keyboardDidHide:(NSNotification*)notification {
    int sameNodeCount=0;
    if ([addedNode.text.text isEqualToString:@""] ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Node is empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // [alert show];
    }

   // if(isKeyboardOffset){
     //   [self scrollCmapView: -keyboardOffset];
      //  isKeyboardOffset=NO;
   // }
    
    /*
     else{
     
     for(NodeCell* cell in conceptNodeArray){
     if([addedNode.text.text isEqualToString:cell.text.text]){
     sameNodeCount++;
     }
     }//end for
     if(sameNodeCount>1){
     NSString* msg=[[NSString alloc]initWithFormat:@"Node %@ already exists!",addedNode.text.text];
     [NSTimer scheduledTimerWithTimeInterval:2.0
     target:self
     selector:@selector(showDepliAlert)
     userInfo:nil
     repeats:NO];
     
     // return;
     }else{
     isAlertShowing=NO;
     }//end if
     
     }//end else*/

}

-(void)showDepliAlert{
    if(!isAlertShowing){
        NSString* msg=[[NSString alloc]initWithFormat:@"Node %@ already exists!",addedNode.text.text];
        [self showAlertwithTxt:@"Warning" body:msg];
        isAlertShowing=YES;
    }
    [addedNode.text becomeFirstResponder];
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
                        //[self createNode:position withName:cell.conceptName page:0 url:cell.];
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
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Taking notes" selection:linkTextBeforeEditing input:textView.text pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    if (showingPV != nil){ // popoverview for taking notes exists
        noteTakingNode.appendedNoteString = showingPV.noteText.text; //saves text from popover view
        [showingPV dismiss]; //gets rid of popover view
    }
    [self autoSaveMap];
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
    
    if(isTraining){
        [parentTrainingCtr showAlertWithString:@"Good job! Now try to delete a concept node"];
    }
}


-(void)upDateLinkText: (NSString*)text{
    linkJustAdded.relation.text=text;
    //auto resize the textview
    CGRect textFrame=linkJustAdded.relation.frame;
    textFrame.size.width=7*text.length+20;
    linkJustAdded.relation.frame=textFrame;
    [self autoSaveMap];
    
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
    [upLoadIcon  setEnabled:NO];
    [upLoadIcon setTintColor: [UIColor clearColor]];
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



-(void)highlightPageNode: (int)page{
    NSLog(@"Highlight");
    for(NodeCell* cell in conceptNodeArray){
        if(cell.pageNum==(page-1)){
            [cell highlightNode];
        
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



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updatePreviewLocation];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale{
    
    //[self SaveCmapSize:contentView.frame.size.width Height:contentView.frame.size.height];
    
    //[self getPreView:nil];
    //[self updatePreviewLocation];
    
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    positionBeforeZoom=[[NSMutableArray alloc] init];
    sacleBeforeZooming=conceptMapView.zoomScale;
    
    for (NodeCell* cell in conceptNodeArray  ){
        CGPoint p=cell.view.center;
        [positionBeforeZoom addObject:[NSValue valueWithCGPoint:p]];
    }
}


-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // [self SaveCmapSize:contentView.frame.size.width Height:contentView.frame.size.height];
    if(conceptMapView.zoomScale>sacleBeforeZooming*1.5&&isPinchTraining){
        UIImage *image = [UIImage imageNamed:@"finishTraining"];
        image=[self imageWithImage:image scaledToSize:CGSizeMake(300, 200)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [parentBookPageViewController showAlertWithString:@"Good job! You have learned how to use the concept mapping tool. Click on finish to exist" :imageView];
        isPinchTraining=NO;
    }
    
    [self SaveCmapScale:conceptMapView.zoomScale];
    NSLog(@"Zooming Scale: %f\n",conceptMapView.zoomScale);
    
    NSLog(@"content width: %f\n",conceptMapView.contentSize.width);
    NSLog(@"view width: %f\n",conceptMapView.frame.size.width);
    
    float extraWidth=(conceptMapView.contentSize.width-conceptMapView.frame.size.width)/2;
    float extraHeight=(conceptMapView.contentSize.height-conceptMapView.frame.size.height)/2;
    float scale2= conceptMapView.zoomScale;
    // scale=sqrtf(scale);
    extraWidth=conceptMapView.frame.size.width*(conceptMapView.zoomScale-sacleBeforeZooming)/2;
    extraHeight=conceptMapView.frame.size.height*(conceptMapView.zoomScale-sacleBeforeZooming)/2;
    int i=0;
    
    for (NodeCell* cell in conceptNodeArray  ){
        if(positionBeforeZoom.count==0){
            continue;
        }
        NSValue *CGPointValue=[positionBeforeZoom objectAtIndex:i];
        CGPoint savedPoint=[CGPointValue CGPointValue];
        //[cell.view setFrame:CGRectMake(cell.view.frame.origin.x*scale, cell.view.frame.origin.y*scale, cell.view.frame.size.width,  cell.view.frame.size.height)];
        cell.view.center=CGPointMake(savedPoint.x+extraWidth, savedPoint.y+extraWidth);
        
        [cell updateLink];
        //[self getPreView:nil];
        [self updateNodesPosition:cell.view.center Node:cell];
        //[self updatePreviewLocation];
        i++;
    }
    [self getPreView:nil];
    [self updatePreviewLocation];
    
    
    
    for(NodeCell* cell in conceptNodeArray){
        if(  (cell.view.frame.origin.x+cell.view.frame.size.width)  >contentView.frame.size.width){
            cell.view.center=CGPointMake(cell.view.center.x-1,cell.view.center.y);
            conceptMapView.zoomScale=sacleBeforeZooming;
            
        }
        
        if((cell.view.frame.origin.y+cell.view.frame.size.height)>contentView.frame.size.height){
            cell.view.center=CGPointMake(cell.view.center.x,cell.view.center.y-1);
            conceptMapView.zoomScale=sacleBeforeZooming;
        }
        
        if(cell.view.frame.origin.y<cell.view.frame.size.height/2||cell.view.frame.origin.x<cell.view.frame.size.width/2){
            cell.view.center=CGPointMake(cell.view.center.x,cell.view.center.y-1);
            conceptMapView.zoomScale=sacleBeforeZooming;
        }
        
    }
    [self getPreView:nil];
    [self updatePreviewLocation];
    
    
    return;
    
    
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
    
    // [self saveOrigin];
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


-(void)highlightPreviewNode{
    
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
    
    LogData* newlog= [[LogData alloc]initWithName:userName SessionID:@"session_id" action:@"Deleting Link" selection:@"concept map view" input:linkBk.relation.text pageNum:pageNum];
    [bookLogDataWrapper addLogs:newlog];
    [LogDataParser saveLogData:bookLogDataWrapper];
    //removes link that matches description
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
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(conceptMapView.contentSize);
    {
        CGPoint savedContentOffset = conceptMapView.contentOffset;
        CGRect savedFrame = conceptMapView.frame;
        
        conceptMapView.contentOffset = CGPointZero;
        conceptMapView.frame = CGRectMake(0, 0, conceptMapView.contentSize.width, conceptMapView.contentSize.height);
        
        [conceptMapView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        conceptMapView.contentOffset = savedContentOffset;
        conceptMapView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FinalScreenShot.png"];
    
    // Save image.
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];

    
    /*
    if (image != nil) {
        [UIImagePNGRepresentation(image) writeToFile: @"/tmp/test.png" atomically: YES];
        system("open /tmp/test.png");
    }*/
    
    
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
    NSString *filename = @"HighSchoolStudyMaps/";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    //filename=[filename stringByAppendingString:usrName];
    
    NSString* iPadId=[[NSUserDefaults standardUserDefaults] stringForKey:@"iPadId"];
    filename=[filename stringByAppendingString:iPadId];

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
   // filename=[filename stringByAppendingString:usrName];
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
    //filename=[filename stringByAppendingString:userName];
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
    //filename=[filename stringByAppendingString:userName];
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
    
    // NSString* oroginXString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedOriginX"];
    // NSString* originYString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedOriginY"];
    // int originX= [oroginXString intValue];
    // int originY= [originYString intValue];
    // [parentBookPageViewController.PreviewRect setFrame:CGRectMake(originX, originY, parentBookPageViewController.PreviewRect.frame.size.width, parentBookPageViewController.PreviewRect.frame.size.height)];
    
    if(savedMapWidth>contentView.frame.size.width){
        [contentView setFrame:CGRectMake(0, 0, savedMapWidth, savedMapHeight)];
        [conceptMapView setContentSize:CGSizeMake(savedMapWidth, savedMapHeight)];
    }
    
}


-(void)SaveCmapSize:(int)width Height: (int)height{
    int originX=parentBookPageViewController.PreviewRect.frame.origin.x;
    int originY=parentBookPageViewController.PreviewRect.frame.origin.y;
    
    
    savedMapWidth=width;
    savedMapHeight=height;
    NSString* widthString= [NSString stringWithFormat:@"%d",width];
    NSString* heightString= [NSString stringWithFormat:@"%d",height];
    
    NSString* originXString= [NSString stringWithFormat:@"%d",originX];
    NSString* originYString= [NSString stringWithFormat:@"%d",originY];
    
    [[NSUserDefaults standardUserDefaults] setObject:widthString forKey:@"savedWidth"];
    [[NSUserDefaults standardUserDefaults] setObject:heightString forKey:@"savedheight"];
    
    // [[NSUserDefaults standardUserDefaults] setObject:originXString forKey:@"savedOriginX"];
    // [[NSUserDefaults standardUserDefaults] setObject:originYString forKey:@"savedOriginY"];
}


-(void)SaveCmapScale:(float)scale{
    if(parentBookPageViewController.isTraining){
        return;
    }
    NSString* scaleString= [NSString stringWithFormat:@"%f",scale];
    [[NSUserDefaults standardUserDefaults] setObject:scaleString forKey:@"savedScale"];
    
}

-(void)readSavedCmapScale{
    NSString* widthString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedScale"];
    float scale=[widthString floatValue];
    conceptMapView.zoomScale=scale;
    
}


-(void)saveOrigin{
    int originX=parentBookPageViewController.PreviewRect.frame.origin.x;
    int originY=parentBookPageViewController.PreviewRect.frame.origin.y;
    NSString* originXString= [NSString stringWithFormat:@"%d",originX];
    NSString* originYString= [NSString stringWithFormat:@"%d",originY];
    [[NSUserDefaults standardUserDefaults] setObject:originXString forKey:@"savedOriginX"];
    [[NSUserDefaults standardUserDefaults] setObject:originYString forKey:@"savedOriginY"];
}



-(void)readSavedOrigin{
    NSString* oroginXString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedOriginX"];
    NSString* originYString=[[NSUserDefaults standardUserDefaults] stringForKey:@"savedOriginY"];
    int originX= [oroginXString intValue];
    int originY= [originYString intValue];
    [parentBookPageViewController.PreviewRect setFrame:CGRectMake(originX, originY, parentBookPageViewController.PreviewRect.frame.size.width, parentBookPageViewController.PreviewRect.frame.size.height)];
    
}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

//trashcan on toolbar
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
        
        [self createNode:CGPointMake(cell.point_x, cell.point_y) withName:cell.text page:cell.pageNum url:cell.linkingUrl];
        
        
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
//upload button on far right of toolbar, needs three clicks to load
- (IBAction)AdminUpload:(id)sender {
    /*
     ZCTradeView* trade=[[ZCTradeView alloc]init];
     trade.delegate=self;
     [trade show];*/
    
    
    MyAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Admin" message:@"Enter admin password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.tag=3;
    alertView.delegate=self;
    [alertView show];
    
    //[parentBookPageViewController showAdminPsdAlert];
    
    
    
}


-(void)upLoadLogFiletoDropBox{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    //make a file name to write the data to using the documents directory:
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory
                          stringByAppendingPathComponent:@"LogData.xml"];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];

    NSString *filename = @"HighSchoolLogfile/";
    NSString* usrName=[[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
   // filename=[filename stringByAppendingString:usrName];
    
    NSString* iPadId=[[NSUserDefaults standardUserDefaults] stringForKey:@"iPadId"];
    filename=[filename stringByAppendingString:iPadId];
    
    filename=[filename stringByAppendingString:@"_LogData.xml"];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish Upload Logfile" message:@"Success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finish Upload Logfile" message:@"Error!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }];
    [doDataTask resume];
    
}


-(BOOL)isNodeExist: (NSString*)name{
    for(NodeCell* cell in conceptNodeArray){
        if([cell.text.text isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}

-(void)showLinkHint{
    /*
    [conceptMapView bringSubviewToFront:focusQuestionLable];
    //[focusQuestionLable removeFromSuperview];
    //[self.view addSubview:focusQuestionLable];
    focusQuestionLable.text=@"Click on the node you want to link. To cancel linking, click on the node itself.";
    focusQuestionLable.center=CGPointMake(200+conceptMapView.contentOffset.x, 15+conceptMapView.contentOffset.y);
    [focusQuestionLable setHidden:NO];*/
    [parentBookPageViewController showLinkingWarning];
}

-(void)dismissLinkHint{
    //[focusQuestionLable setHidden:YES];
    [parentBookPageViewController hideLinkingWarning];
}

//"Web" button  on toolbar action to display web view
-(IBAction) displayWebView:(id)sender{
   /// WebBrowserViewController *myweb=[[WebBrowserViewController alloc]initWithNibName:@"WebBrowserViewController" bundle:nil];
    if (self.parentBookPageViewController.myWebView.view.isHidden == YES){ // Web browser view is hidden
        //Show view
        [self.parentBookPageViewController.myWebView.view setHidden: NO];
        if ([self.parentBookPageViewController.myWebView.webAdrText.text isEqualToString:@""]){ //Url textfield is empty
            [self.parentBookPageViewController.myWebView SearchKeyWord: @""]; //go to google
        }
        self.parentBookPageViewController.subViewType=1;
        [self.parentBookPageViewController.view bringSubviewToFront:parentBookPageViewController.myWebView.view];
    }
    else{ //Web browser view is showing
        //Hide View
        [self.parentBookPageViewController.myWebView.view setHidden: YES];
         self.parentBookPageViewController.subViewType=0;
        [self.parentBookPageViewController.view sendSubviewToBack:parentBookPageViewController.myWebView.view];
    }

}


//commenting
-(void)showNoteTaking: (CGPoint)showpoint  {
    
    NSArray *popUpContent=[NSArray arrayWithObjects:@"NoteTaking", nil];
    [PopoverView showPopoverAtPoint:showpoint
                                 inView:self.contentView
                              withTitle:@"Take Note"
                        withStringArray:popUpContent
                               delegate:self];
    //pv.showPoint=self.showPoint;
    
   // [pv becomeFirstResponder];

}

@end

