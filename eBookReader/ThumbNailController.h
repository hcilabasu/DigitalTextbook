//
//  ThumbNailController.h
//  eBookReader
//
//  Created by Shang Wang on 7/11/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbNailController : UIViewController

@property (nonatomic) CGPoint showPoint; //position that the thumbnail icon displays

@property (nonatomic) int totalIconNum;

@property (nonatomic) int topSpace;

@property (nonatomic) int bottomSpace;

@property (strong, nonatomic) NSMutableArray *iconArray;

@property (nonatomic) CGSize screenSize;

-(int) getIconPos: (CGPoint) m_showPoint type:(int)thumbtype;
-(void)clearAllThumbnail;

@end
