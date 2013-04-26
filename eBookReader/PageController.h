//
//  PageControllerViewController.h
//  eBookReader
//
//  Created by Andreea Danielescu on 2/20/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageController : UIViewController {
    NSUInteger pageNum;
}

@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, strong) UIWebView *pageView;

-(void) loadPage:(int)pageNum :(NSString*)content :(NSURL*)baseURL;

@end
