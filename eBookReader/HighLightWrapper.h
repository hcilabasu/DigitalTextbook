//
//  Party.h
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighLightWrapper : NSObject {
    NSMutableArray *_players;
}

@property (nonatomic, retain) NSMutableArray *players;

@end