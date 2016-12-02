//
//  StudentDataWrapper.h
//  TurkStudy
//
//  Created by Shang Wang on 2/4/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StudentData.h>
@interface StudentDataWrapper : NSObject
@property (nonatomic, retain) NSMutableArray *studentDataArray;

-(void)addLogs: (StudentData*)log;
-(void)clearAllData;
@end
