//
//  Party.m
//  eBookReader
//
//  Created by Shang Wang on 7/18/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "HighLightWrapper.h"
#import "HighLight.h"
@implementation HighLightWrapper
@synthesize highLights = _highLights;

- (id)init {
    
    if ((self = [super init])) {
        self.highLights = [[NSMutableArray alloc] init];
    }
    return self;
    
}

- (void) dealloc {
    self.highLights = nil;
}


-(void)addHighlight: (HighLight*)highlight{
    [self.highLights addObject:highlight];
}

-(void)printAllHighlight{
    NSLog(@"Print Highlight!\n");

    int i=0;
    for (HighLight *player in self.highLights) {
        NSLog(@"No. %d",++i);
        NSLog(@"Text: %@", player.text);
        NSLog(@"Color: %@", player.color);
        NSLog(@"Page: %d", player.page);
        NSLog(@"Count: %d\n", player.searchCount);
        NSLog(@"StartContainer: %d\n", player.startContainer);
        NSLog(@"StartOffset: %d\n", player.startOffset);
        NSLog(@"EndContainer: %d\n", player.endContainer);
        NSLog(@"EndOffset: %d\n", player.endOffset);
    }
    if(0==i){
        NSLog(@"Highlight array empty!\n");
    }

}


-(void)clearAllData{
    [self.highLights removeAllObjects];
}
@end