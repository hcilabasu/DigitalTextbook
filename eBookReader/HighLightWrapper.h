//
//  Party.h
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HighLight;
@interface HighLightWrapper : NSObject {
    NSMutableArray *_highLights;
}



@property (nonatomic, retain) NSMutableArray *highLights;
-(void)addHighlight: (HighLight*)highlight;
-(void)printAllHighlight;
-(void)clearAllData;
@end