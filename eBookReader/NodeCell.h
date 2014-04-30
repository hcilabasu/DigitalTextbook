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
@class CmapController;

@interface NodeCell : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>

@property (assign)CGPoint showPoint;

@property (strong, nonatomic) IBOutlet ShangTextField *text;
@property int showType; //0:full screen, 1: half screen;
@property CGPoint bookPagePosition;
@property (strong, nonatomic) CmapController* parentCmapController;
@property(assign,nonatomic) BOOL pressing;
@property(assign,nonatomic) BOOL isInitialed;
@property(strong,nonatomic) IBOutlet UILongPressGestureRecognizer* longPressRecognizer;
@property (strong, nonatomic) NSMutableArray*  relatedNodesArray;
@property (strong, nonatomic) NSMutableArray*  linkLayerArray;
@property (strong, nonatomic) NSMutableArray*  relationTextArray;
@property (nonatomic, retain) HighLightWrapper *bookHighLight;//the highlight wrapper pased from the bookviewcontroller to control the highlight info in the book
@property (nonatomic, retain) ThumbNailIconWrapper *bookthumbNailIcon;
@property (strong, nonatomic) NSString *bookTitle;
- (CGSize) screenSize;// function that returns the size of the screen, used to deteremine where the icon and the popup view is shown.
@end
