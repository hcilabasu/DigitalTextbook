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
@property int readActionCount;
@property int readFeedbackCount;
@property int startPosition;
-(void)evaluate;
@end

NS_ASSUME_NONNULL_END
