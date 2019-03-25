//
//  KeyConcept.m
//  Study
//
//  Created by Shang Wang on 3/20/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import "KeyConcept.h"

@interface KeyConcept ()

@end

@implementation KeyConcept
@synthesize name;
@synthesize subName;
@synthesize subName2;
@synthesize page;
@synthesize subPage;
@synthesize position;
@synthesize conceptName;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id) initWithVariable: (NSString*) m_name  Page: (int*) m_page   Subpage: (int*)m_subPage   Position: (CGPoint) m_position  {
    self=[super init];
    name=m_name;
    page=m_page;
    subPage=m_subPage;
    position=m_position;
    subName=m_name;
    subName2=m_name;
    conceptName=m_name;
    
    return self;
}



@end
