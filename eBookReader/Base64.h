//
//  Base64.h
//  Cmapping with Kinect
//
//  Created by Andreea Danielescu on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

- (NSString *)encodeBase64WithString:(NSString *)strData;
- (NSString *)encodeBase64WithData:(NSData *)objData;

- (NSData *)decodeBase64WithString:(NSString *)strBase64;

@end
