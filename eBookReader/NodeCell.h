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
@class CmapController;
@class ContentViewController;

@interface NodeCell : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate , GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>

@property (assign)CGPoint showPoint;
@property int pageNum;
@property int nodeType; //1: shows in book scroll thumb view; 0: shows in Cmap view;
@property (strong, nonatomic) IBOutlet ShangTextField *text;
@property int showType; //0:full screen, 1: half screen;
@property CGPoint bookPagePosition;
@property (strong, nonatomic) CmapController* parentCmapController;
@property (strong, nonatomic) ContentViewController *parentContentViewController;

@property(assign,nonatomic) BOOL pressing;
@property(assign,nonatomic) BOOL isInitialed;
@property  CABasicAnimation *waitAnim;
@property(strong,nonatomic) IBOutlet UILongPressGestureRecognizer* longPressRecognizer;
@property(strong,nonatomic) IBOutlet UITapGestureRecognizer* tapRecognizer;


@property (strong, nonatomic) NSMutableArray*  relatedNodesArray;
@property (strong, nonatomic) NSMutableArray*  linkLayerArray;
@property (strong, nonatomic) NSMutableArray*  relationTextArray;
@property (nonatomic, retain) HighLightWrapper *bookHighLight;//the highlight wrapper pased from the bookviewcontroller to control the highlight info in the book
@property (nonatomic, retain) ThumbNailIconWrapper *bookthumbNailIcon;
@property (strong, nonatomic) NSString *bookTitle;
@property BOOL hasNote;
@property BOOL hasHighlight;
@property BOOL hasWeblink;
- (CGSize) screenSize;// function that returns the size of the screen, used to deteremine where the icon and the popup view is shown.
-(void)removeShadowAnim;
-(void)removeLink;
-(void)createLink: (NodeCell*)cellToLink name: (NSString*)relationName;
-(void)highlightNode;
-(void)unHighlightNode;
-(void)highlightLink: (NSString*)relatedNodeName;
@end
