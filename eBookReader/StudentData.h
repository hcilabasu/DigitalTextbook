//
//  StudentData.h
//  TurkStudy
//
//  Created by Shang Wang on 2/4/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentData : NSObject
@property (strong, nonatomic) NSString*  name;
@property (strong, nonatomic) NSString* password;

@property (nonatomic, assign) int page;
- (id)initWithName:(NSString*)m_name Password: (NSString*)m_password;
@end
