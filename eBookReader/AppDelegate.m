//
//  AppDelegate.m
//  eBookReader
//
//  Created by Andreea Danielescu on 1/23/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "AppDelegate.h"
#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "HighLight.h"
#import "LogFileController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "TestFairy.h"

@interface AppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
    
    BOOL requireLogin=NO;
    BOOL autoTimer=NO;
    BOOL showPreview=YES;
    BOOL allowmanuAdd=NO;
    BOOL testMode=YES;
    BOOL loadExpertMap=YES;
    BOOL isHyperLink=YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"testMode"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isTimer"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isPreview"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isManu"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"loadExpertMap"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isHyperLinking"];
    
    
    ///////////////////////set iPad id://///////////////////////////////
    [[NSUserDefaults standardUserDefaults] setObject:@"8" forKey:@"iPadId"];
    /////////////////////////////////////////////////////////////////////
    
    
    if(testMode){
       // [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"testMode"];
    }
    if(requireLogin){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
    }
    if(autoTimer){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isTimer"];
    }
    if(showPreview){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isPreview"];
    }
    if(allowmanuAdd){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isManu"];
    }
    if(loadExpertMap){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"loadExpertMap"];
    }
    if(isHyperLink){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isHyperLinking"];
    }
    
    
    [TestFairy begin:@"e5748af60e023eec56df84a69ddfed6cd421b914"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"HyperLinking"];
    // Override point for customization after application launch.
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyBook"];
    [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyBook/book"];
    [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
  
     NSString *txtPath = [dataPath stringByAppendingPathComponent:@"aa.epub"];
     
     if ([fileManager fileExistsAtPath:txtPath] == NO) {
     NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@"epub"];
     [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
     }
    
    LogFileController* logfile=[[LogFileController alloc]init];
    [logfile writeToTextFile:@"\n\n\n\n\nLaunch Application.\n " logTimeStampOrNot:YES];
    
    NSString *txtPath2 = [documentsDirectory stringByAppendingPathComponent:@"ExpertCmapLinkList.xml"];
     NSString *txtPath3 = [documentsDirectory stringByAppendingPathComponent:@"ExpertCmapNodeList.xml"];
    if ([fileManager fileExistsAtPath:txtPath2] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"ExpertCmapLinkList" ofType:@"xml"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    if ([fileManager fileExistsAtPath:txtPath3] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"ExpertCmapNodeList" ofType:@"xml"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
	NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
	NSInteger majorVersion =
    [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
	if (launchURL && majorVersion < 4) {
		// Pre-iOS 4.0 won't call application:handleOpenURL; this code is only needed if you support
		// iOS versions 3.2 or below
		[self application:application handleOpenURL:launchURL];
		return NO;
	}
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
} 

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}



#pragma mark -
#pragma mark DBSessionDelegate methods
- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
	relinkUserId = userId ;
	[[[UIAlertView alloc]
	   initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self
	   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil] show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
	if (index != alertView.cancelButtonIndex) {
		[[DBSession sharedSession] linkUserId:relinkUserId fromController:self];
	}
	relinkUserId = nil;
}


#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

@end
