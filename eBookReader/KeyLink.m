//
//  KeyLink.m
//  Study
//
//  Created by Shang Wang on 3/25/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import "KeyLink.h"

@interface KeyLink ()

@end

@implementation KeyLink
@synthesize leftConcept;
@synthesize relationName;
@synthesize rightConcept;
@synthesize leftName;
@synthesize rightname;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (id) initWithNames: (NSString*) m_leftName   RightName: (NSString*)m_rightname   {
    self=[super init];
    leftName=m_leftName;
    rightname=m_rightname;
    return self;
}

- (BOOL)isPartofLink: (NSString* )nodeName{
    BOOL isOrNot=NO;
    if ([nodeName rangeOfString: leftConcept.name].location != NSNotFound) {
        isOrNot=YES;
    }
    if ([nodeName rangeOfString: rightConcept.name].location != NSNotFound) {
        isOrNot=YES;
    }
    return isOrNot;
}


@end
