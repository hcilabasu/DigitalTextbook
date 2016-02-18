//
//  StudentData.m
//  TurkStudy
//
//  Created by Shang Wang on 2/4/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import "StudentData.h"

@implementation StudentData
@synthesize name;
@synthesize password;

- (id)initWithName:(NSString*)m_name Password: (NSString*)m_password{
    
    if ((self = [super init])) {
        
        name=m_name;
        password=m_password;
        
    }
    return self;
    
}

@end

