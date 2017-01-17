//
//  RelationTextView.h
//  eBookReader
//
//  Created by Shang Wang on 6/15/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHContextMenuView.h"
@class CmapController;
@interface RelationTextView : UITextView <UITextViewDelegate,GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>
@property (strong, nonatomic)   GHContextMenuView* overlay;
@property (strong, nonatomic) CmapController* parentCmapCtr;
@property int viewID;
@property BOOL enableRecognizer;
@property BOOL disableEditting;
@property NSString* leftNodeName;
@property NSString* rightNodeName;
//@property (nonatomic, retain) NodeCell* leftNode;
//@property (nonatomic, retain) NodeCell* rightNode;
@end
