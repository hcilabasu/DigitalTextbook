//
//  CmapController.h
//  eBookReader
//
//  Created by Shang Wang on 2/18/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeModule.h"
#import <QuartzCore/QuartzCore.h>
#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "GDataXMLNode.h"
#import "HighLight.h"
#import "ConceptLink.h"
#import "ThumbNailIcon.h"
#import "ThumbNailIconParser.h"
#import "ThumbNailIconWrapper.h"
#import "ContentViewController.h"
#import "CmapLinkParser.h"
#import "CmapNodeParser.h"
#import "CmapNodeWrapper.h"
#import "MBProgressHUD.h"
#import <DropboxSDK/DropboxSDK.h>
#import "LogData.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"
#import "NodeCell.h"
#import "ZCTradeView.h"
#import "RelationTextView.h"
#import "DTAlertView.h"
#import "WebBrowserViewController.h"
#define NODE_TEMPLATE 0;
#define NODE_STUDENT 1;
@class NodeCell;
@class BookViewController;
@class HighLightWrapper;
@class ThumbNailIconWrapper;
@class BookPageViewController;
@class TrainingViewController;
@class ContentViewController;
@interface CmapController : UIViewController <UIAlertViewDelegate,PopoverViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UITextViewDelegate, MBProgressHUDDelegate, DBRestClientDelegate,UITextFieldDelegate,ZCTradeViewDelegate,DTAlertViewDelegate>{
    long long expectedLength;
    long long currentLength;
    MBProgressHUD *HUD;
}

//@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIScrollView *conceptMapView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) PopoverView* showingPV; //pv in node cell
@property (strong, nonatomic) NodeCell* noteTakingNode; //for taking notes

@property (strong, nonatomic) id dataObject;// sotres the HTML data
@property (strong, nonatomic) id url; //the URL link to display HTML content
@property (nonatomic) BOOL isMenuShow;
//@property (nonatomic, retain) IBOutlet UILabel *currentPageLabel; //indicates the current page number
@property (nonatomic) int pageNum; //current page number
@property (nonatomic) int totalpageNum;//total page number
@property (strong, nonatomic) BookViewController *neighbor_BookViewController;
@property (strong, nonatomic) ContentViewController *parent_ContentViewController;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *returnToBook;
@property (nonatomic) NSInteger prevIndex;
@property (nonatomic) CGPoint longPressLocation;
@property (nonatomic) CGPoint curretnLocation;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isTraining;
@property (nonatomic, assign) BOOL isNavigateTraining;
@property (nonatomic, assign) BOOL isPinchTraining;
@property (nonatomic, assign) BOOL isAlertShowing;
@property (nonatomic, assign) BOOL isHyperlinkTraining;
@property (nonatomic, assign) BOOL isAddNodeTraining;
@property (nonatomic, assign) BOOL isKeyboardOffset;
@property (nonatomic, assign) int keyboardOffset;

@property (nonatomic, assign) BOOL isPaning;
@property (nonatomic, strong) NSMutableArray* menuItems;
@property (nonatomic, assign) BOOL isBlockedByKeyboard;
@property(strong,nonatomic) UIImageView *bulbImageView;
@property(strong,nonatomic) UIImageView *previewImageView;


@property (weak, nonatomic) IBOutlet UILabel *focusQuestionLable;
@property BOOL isQuestionShow;
@property (strong, nonatomic) NSMutableArray*  conceptNamesArray;
//the array that keeps trak of all the concept nodes in the Cmap view
@property (strong, nonatomic) NSMutableArray*  conceptNodeArray;
//stores the links between concepts
@property (strong, nonatomic) NSMutableArray*  conceptLinkArray;

@property (strong, nonatomic) NSMutableArray*  lastStepConceptNodeArray;
//stores the links between concepts
@property (strong, nonatomic) NSMutableArray*  lastStepConceptLinkArray;


@property BOOL isFinishLoadMap;
@property BOOL isInitComplete;
@property (nonatomic, strong) DBRestClient *restClient;
@property  int nodeCount;
@property  int linkCount;
@property (strong, nonatomic) KnowledgeModule*  knowledgeModule;
//link
@property (nonatomic, assign) BOOL isReadyToLink;
@property (strong, nonatomic) NodeCell* nodesToLink;
@property int showType; //the id that indicates the scenario of the view, //0: full screen, 1: half screen 2://linking concept in the training view
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat arcAngle;
@property (nonatomic) CGFloat angleBetweenItems;
@property (nonatomic, strong) NSMutableArray* itemLocations;
@property (nonatomic) CGColorRef itemBGHighlightedColor;
@property (nonatomic) CGColorRef itemBGColor;
@property (nonatomic) int savedMapHeight;
@property (nonatomic) int savedMapWidth;
@property (nonatomic, strong) NSMutableArray* positionBeforeZoom;
@property (nonatomic) float sacleBeforeZooming;


@property (nonatomic, retain) HighLightWrapper *bookHighlight;
@property (nonatomic, retain) ThumbNailIconWrapper* bookThumbNial;
@property (nonatomic, retain) CmapLinkWrapper* bookLinkWrapper;
@property (nonatomic, retain) CmapNodeWrapper* bookNodeWrapper;
@property (nonatomic, retain) ConceptLink* linkJustAdded;
@property (nonatomic, retain) LogDataWrapper* bookLogDataWrapper;
@property (nonatomic, retain) RelationTextView* linkJustCreated;

@property (nonatomic, retain) BookPageViewController* parentBookPageViewController ;

@property (strong, nonatomic) NSString *bookTitle;
@property (strong,nonatomic)  UIImageView *waitImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *upLoadIcon;


@property (strong, nonatomic) NSString* userName;
@property BOOL enableHyperLink;
@property BOOL isUserAction;
@property (weak, nonatomic) IBOutlet UIImageView *preView;
@property CGSize sizebeforePinch;
@property (strong, nonatomic) NodeCell* addedNode;

@property (strong, nonatomic) NSString *nodeTextBeforeEditing;
@property (strong, nonatomic) NSString *linkTextBeforeEditing;
@property BOOL hasLogedModifyMap;

@property (strong, nonatomic) UIImage* savedExpertImg;
@property (nonatomic, strong) NSMutableArray* conceptsShowAry;
@property (nonatomic, strong)TrainingViewController* parentTrainingCtr;
@property NSMutableArray* correctIndexAry;


-(void)disableAllNodesEditting;
-(void)enableAllNodesEditting;
-(void)showpageAtIntex: (int)page;
-(void)addConceptOnClick: (CGPoint)clickPoint;
-(void)scrollCmapView :(CGFloat)length;
-(void)generateNodeArray: (NSMutableArray*) conceptArray;
-(void)autoGerenateNode;
-(CGPoint)calculateNodePosition:(int) arrayId;
-(void)startWait;
-(void)endWait;
-(void)showResources;
-(void)createNode:(CGPoint)position withName:(NSString*) name page: (int)m_pageNum  url:(NSURL*)m_linkingUrl;


-(void)createNodeFromBook:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition page:(int)m_pageNum;
-(void)addConcpetLink: (ConceptLink*) m_link;
-(void)autoSaveMap;
- (IBAction)loadConceptMap:(id)sender;
-(void)highlightNode: (NSString*)nodeName;
-(void)clearAllHighlight;
-(void)highlightLink: (int)page;
-(void)upDateLinkText: (NSString*)text;

-(void)logLinkingConceptNodes: (NSString*)Concept1 ConnectedConcept: (NSString*)Concept2;//log linking activity into log file
-(void)logHyperNavigation:(NSString*)ConceptName;
- (IBAction)upLoad:(id)sender;
-(CGPoint)calculateNodePosition:(int) arrayId;
-(void)editRelationLink;
-(void)deleteConcept:(NSString*)name;
-(void)updateNodesPosition: (CGPoint)position Node: (NodeCell*)m_node;
- (IBAction)getPreView:(id)sender;
-(void)showAlertwithTxt :(NSString*)title body: (NSString*)txt;
-(void)removePreviewNode: (NSString*)nodeName;
-(BOOL)isLinkExist: (NSString*)name1 OtherName: (NSString*)name2;
-(void)SetNodesFirstResponder;
-(void)uploadCMapImg;
-(void)uploadExpertCMapImg;
-(void)uploadCmapCocneptAddedList;
-(void)deleteLink: (NSString* )leftName SecondNode: (NSString*)rightName;
-(void)LogStudentMapNum;
-(void)readSavedCmapSize;
-(void)SaveCmapSize:(int)width Height: (int)height;
-(void)savePreviousStep;
-(void)deleteHighlightwithWord: (NSString*)name;
-(void)updatePreviewLocation;
-(BOOL)isNodeExist: (NSString*)name;
-(NodeCell*)createNodeFromBookForLink:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition page:(int)m_pageNum;
-(void)highlightPageNode: (int)page;
-(void)showLinkHint;
-(void)dismissLinkHint;
-(void)showNoteTaking: (CGPoint)showpoint;
@end
