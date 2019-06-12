//
//  ExpertModel.h
//  Study
//
//  Created by Shang Wang on 2/19/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CmapNodeParser.h"
#import "CmapLinkParser.h"
#import "KnowledgeModel.h"
#import "LogData.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"
NS_ASSUME_NONNULL_BEGIN
@class CmapController;
@class CmapLinkWrapper;
@class CmapNodeWrapper;
@interface ExpertModel : UIViewController
@property (nonatomic, retain) NSMutableArray *logArray;
@property (nonatomic, retain) NSMutableArray *stateArray;
@property CmapController* parentCmapController;
@property (nonatomic, retain) CmapLinkWrapper* bookLinkWrapper;
@property (nonatomic, retain) CmapNodeWrapper* bookNodeWrapper;
@property (nonatomic, retain) NSMutableArray *unUsedStateArray;
@property (nonatomic, retain) NSMutableDictionary *NodenamePage;
@property int readActionCount;
@property int readFeedbackCount;
@property int startPosition;
@property int sequentialAddCount;
@property double startTimeSecond;
@property double preTimeSecond;
@property (nonatomic, retain) NSMutableArray *keyConceptsAry;
@property (nonatomic, retain) NSMutableArray *keyLinksAry;
@property (nonatomic, retain) NSMutableArray *missingConceptsAry;
@property NSMutableDictionary* pageTimeMap;
@property NSMutableDictionary* pageStayTimeMap;
@property int prePageNum;
@property KeyConcept* kc1;
@property KeyConcept* kc2;
@property int comparePageLeft;
@property int comparePageRight;
@property NSString* nodeName1;
@property NSString* nodeName2;
@property (nonatomic, strong) LogDataWrapper* bookLogDataWrapper;
@property int lastFeedbackSecond;
@property NSTimer* actionTimer;
@property NSTimer* templateActionTimer;
@property NSTimer* backNaviTimber;
@property NSTimer* crosslinkTimer;

@property NSString* missingCrossLinkLeftNodename;
@property NSString* missingCrossLinkRightNodename;
@property NSString* noCrossLinkFBMsg;

@property int backNavicount;
@property int crossLinkCount;
-(void)startAllTimer;
-(void)evaluate;
-(void)setupKM;
-(void)seachMissingCrossLink;
@end

NS_ASSUME_NONNULL_END
