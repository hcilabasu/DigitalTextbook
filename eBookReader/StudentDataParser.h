//
//  StudentDataParser.h
//  TurkStudy
//
//  Created by Shang Wang on 2/4/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentData.h"
#import "StudentDataWrapper.h"

@interface StudentDataParser : NSObject
+ (StudentDataWrapper *)loadLogData;
+ (void)saveLogData:(StudentDataWrapper *)LogDatas;
@end
