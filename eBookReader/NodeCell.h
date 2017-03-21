//
//  NodeCell.h
//  eBookReader
//
//  Created by Shang Wang on 3/3/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHContextMenuView.h"
#import "ShangTextField.h"
#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "GDataXMLNode.h"
#import "HighLight.h"
#import "ThumbNailIcon.h"
#import "ThumbNailIconParser.h"
#import "ThumbNailIconWrapper.h"
#import "ConceptLink.h"
#import "CmapLink.h"
#import "RelationTextView.h"
#import "PopoverView.h"
#import "TylerTextView.h"
#import "LogDataWrapper.h"
@class CmapController;
@class ContentViewController;

@interface NodeCell : UIViewController<PopoverViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate , GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>

@property (assign)CGPoint showPoint;
@property (strong, nonatomic) PopoverView *pv; //For taking notes
@property (strong, nonatomic) NSString *appendedNoteString; //Saved text info for notes
@property int pageNum;
@property int createType; //0: expert node, 1:student node
@property int nodeType; //1: shows in book scroll thumb view; 0: shows in Cmap view;
//@property (strong, nonatomic) IBOutlet ShangTextField *text;

@property (strong, nonatomic) NSString *conceptName;


@property (weak, nonatomic) IBOutlet TylerTextView *text;

@property (strong, nonatomic)   GHContextMenuView* overlay;
@property int showType; //0:full screen, 1: half screen;
@property CGPoint bookPagePosition;
@property (nonatomic, retain) CmapController* parentCmapController;
@property (strong, nonatomic) ContentViewController *parentContentViewController;

@property(assign,nonatomic) BOOL pressing;
@property(assign,nonatomic) BOOL isAlertShowing;

@property(assign,nonatomic) BOOL isInitialed;
@property  CABasicAnimation *waitAnim;
@property(strong,nonatomic) IBOutlet UILongPressGestureRecognizer* longPressRecognizer;

@property(strong,nonatomic) IBOutlet UITapGestureRecognizer* tapRecognizer;

@property (strong, nonatomic) NSMutableArray*  savedUrls; //bookmarked urls from web browser
@property (strong, nonatomic) NSURL* linkingUrl; //associated url when created from web browser
@property (strong, nonatomic) NSString* linkingUrlTitle; //title of web page for linking url
@property (strong, nonatomic) NSMutableArray*  relatedNodesArray;
@property (strong, nonatomic) NSMutableArray*  linkLayerArray;
@property (strong, nonatomic) NSMutableArray*  relationTextArray;
@property (nonatomic, retain) HighLightWrapper *bookHighLight;//the highlight wrapper pased from the bookviewcontroller to control the highlight info in the book
@property (nonatomic, retain) ThumbNailIconWrapper *bookthumbNailIcon;
@property (strong, nonatomic) NSString *bookTitle;
@property BOOL hasNote;
@property BOOL hasHighlight;
@property BOOL hasWeblink;
@property (nonatomic, retain) LogDataWrapper* bookLogData;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) RelationTextView*linkTextview2;
@property BOOL enableHyperLink;

-(void)deleteLinkWithNode: (NodeCell*)cellToDel;
-(void)removeLinkWithNode: (NodeCell*) LinkedNode;

- (CGSize) screenSize;// function that returns the size of the screen, used to deteremine where the icon and the popup view is shown.
-(void)removeShadowAnim;
-(void)removeLink;
-(void)createLink: (NodeCell*)cellToLink name: (NSString*)relationName;
-(void)highlightNode;
-(void)unHighlightNode;
-(void)unHighlightExpertNode;

-(void)highlightLink: (NSString*)relatedNodeName;
-(void)addHighlightThumb;
-(void)deleteNode: (BOOL)delByUser;
-(void)updateViewSize;
-(void)updateLink;
-(void)enterIntoUrlArray;
-(void)setLinkingUrl;

@end
