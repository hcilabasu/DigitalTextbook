//
//  StudentDataWrapper.m
//  TurkStudy
//
//  Created by Shang Wang on 2/4/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import "StudentDataWrapper.h"

@implementation StudentDataWrapper
@synthesize studentDataArray;

- (id)init {
    if ((self = [super init])) {
        studentDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addLogs: (StudentData*)log{
    
    [studentDataArray addObject:log];
}


-(void)clearAllData{
    [studentDataArray removeAllObjects];
}

@end
