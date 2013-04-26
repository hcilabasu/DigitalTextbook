#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (void) push: (id)item;
- (id) pop;
- (id) peek;
- (void) replaceTop: (id)item;

@end