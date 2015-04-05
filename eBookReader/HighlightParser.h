//
//  PartyParser.h
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HighLightWrapper;

@interface HighlightParser : NSObject {
    
}

+ (HighLightWrapper *)loadHighlight;
+ (void)saveHighlight:(HighLightWrapper *)highLight ;
@end