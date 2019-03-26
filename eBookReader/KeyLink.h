//
//  KeyLink.h
//  Study
//
//  Created by Shang Wang on 3/25/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyConcept.h"
NS_ASSUME_NONNULL_BEGIN

@interface KeyLink : UIViewController
@property KeyConcept* leftConcept;
@property KeyConcept* rightConcept;
@property NSString* relationName;
@end

NS_ASSUME_NONNULL_END
