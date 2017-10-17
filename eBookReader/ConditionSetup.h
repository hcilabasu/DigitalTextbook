//
//  ConditionSetup.h
//  Digital Textbook
//
//  Created by Shang Wang on 10/17/17.
//  Copyright © 2017 Shang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConditionSetup : NSObject
+ (ConditionSetup *)sharedInstance;
-(NSString*)getSessionID;
@end
