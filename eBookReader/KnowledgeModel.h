//
//  KnowledgeModel.h
//  Study
//
//  Created by Shang Wang on 3/20/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyConcept.h"
#import "KeyLink.h"
NS_ASSUME_NONNULL_BEGIN

@interface KnowledgeModel : UIViewController
@property (nonatomic, retain) NSMutableArray *keyConceptsAry;
-(NSMutableArray*) getKeyConceptLists;
-(NSMutableArray*) getKeyLinkLists;

@end

NS_ASSUME_NONNULL_END
