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
@class NodeCell;
@class BookViewController;
@class HighLightWrapper;
@class ThumbNailIconWrapper;
@class ContentViewController;
@interface CmapController : UIViewController <UIGestureRecognizerDelegate,UIWebViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UITextViewDelegate, MBProgressHUDDelegate>{
    long long expectedLength;
	long long currentLength;
    MBProgressHUD *HUD;
}

//@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIScrollView *conceptMapView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) id dataObject;// sotres the HTML data
@property (strong, nonatomic) id url; //the URL link to display HTML content
@property (nonatomic) BOOL isMenuShow;
//@property (nonatomic, retain) IBOutlet UILabel *currentPageLabel; //indicates the current page number
@property (nonatomic) int pageNum; //current page number
@property (nonatomic) int totalpageNum;//total page number
@property (strong, nonatomic) BookViewController *parent_BookViewController;
@property (strong, nonatomic) ContentViewController *parent_ContentViewController;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *returnToBook;
@property (nonatomic) NSInteger prevIndex;
@property (nonatomic) CGPoint longPressLocation;
@property (nonatomic) CGPoint curretnLocation;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isPaning;
@property (nonatomic, strong) NSMutableArray* menuItems;
@property (nonatomic, assign) BOOL isBlockedByKeyboard;
@property (strong, nonatomic) NSMutableArray*  conceptNamesArray;
//the array that keeps trak of all the concept nodes in the Cmap view
@property (strong, nonatomic) NSMutableArray*  conceptNodeArray;
//stores the links between concepts
@property (strong, nonatomic) NSMutableArray*  conceptLinkArray;
@property BOOL isFinishLoadMap;

@property  int nodeCount;
@property  int linkCount;
@property (strong, nonatomic) KnowledgeModule*  knowledgeModule;
//link
@property (nonatomic, assign) BOOL isReadyToLink;
@property (strong, nonatomic) NodeCell* nodesToLink;
@property int showType; //the id that indicates the scenario of the view, //0: full screen, 1: half screen
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat arcAngle;
@property (nonatomic) CGFloat angleBetweenItems;
@property (nonatomic, strong) NSMutableArray* itemLocations;
@property (nonatomic) CGColorRef itemBGHighlightedColor;
@property (nonatomic) CGColorRef itemBGColor;

@property (nonatomic, retain) HighLightWrapper *bookHighlight;
@property (nonatomic, retain) ThumbNailIconWrapper* bookThumbNial;
@property (nonatomic, retain) CmapLinkWrapper* bookLinkWrapper;
@property (nonatomic, retain) CmapNodeWrapper* bookNodeWrapper;


@property (strong, nonatomic) NSString *bookTitle;
@property (strong,nonatomic)  UIImageView *waitImageView;

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
-(void)createNode:(CGPoint)position withName:(NSString*) name;
-(void)createNodeFromBook:(CGPoint)position withName:(NSString*) name BookPos: (CGPoint)bookPosition;
-(void)addConcpetLink: (ConceptLink*) m_link;
-(void)autoSaveMap;
- (IBAction)loadConceptMap:(id)sender;
@end
