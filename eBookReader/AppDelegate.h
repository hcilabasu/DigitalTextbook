//
//  AppDelegate.h
//  eBookReader
//
//  Created by Andreea Danielescu on 1/23/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FB_NO @"FBNO"
#define FB_PROCESS @"FB_PROCESS"
#define FB_FULL @"FB_FULL"

@class XMLTestViewController;
@class HighLightWrapper;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    XMLTestViewController *viewController;
    HighLightWrapper *_highLight;
    NSString *relinkUserId;
}

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, retain) HighLightWrapper *highLight;

@end
