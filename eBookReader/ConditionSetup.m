//
//  ConditionSetup.m
//  Digital Textbook
//
//  Created by Shang Wang on 10/17/17.
//  Copyright © 2017 Shang Wang. All rights reserved.
//

#import "ConditionSetup.h"

@implementation ConditionSetup


static ConditionSetup *sharedInstance = nil;

+ (ConditionSetup *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[ConditionSetup alloc] init];
    }
    
    return sharedInstance;
}



- (NSString*)getSessionID{
    NSString* session=@"";
    NSString* LoadExpertMap=[[NSUserDefaults standardUserDefaults] stringForKey:@"isLoadExpertMap"];
    NSString* Hyperlink=[[NSUserDefaults standardUserDefaults] stringForKey:@"isHyperLinking"];
    BOOL isLoadExpertMap=NO;
    BOOL isHyperlink=NO;
    if( [LoadExpertMap isEqualToString:@"YES"]){
        isLoadExpertMap=YES;
    }
    if( [Hyperlink isEqualToString:@"YES"]){
        isHyperlink=YES;
    }
    NSString* templateCondition=@"No Template";
    NSString* hyperlinkCondition=@"No Hyperlink";
    
    if(isLoadExpertMap){
        templateCondition=@"Template";
    }
    if(isHyperlink){
        hyperlinkCondition=@"Hyperlink";
    }
    
    NSString* outputConditionString= [[NSString alloc]initWithFormat:@"%@ + %@", templateCondition, hyperlinkCondition];
    return outputConditionString;
}
@end
