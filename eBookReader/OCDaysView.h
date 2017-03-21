//
//  OCDaysView.h
//  eBookReader
//
//  Created by Shang Wang on 4/3/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCDaysView : UIView {
    int startCellX;
    int startCellY;
    int endCellX;
    int endCellY;
    
    float xOffset;
    float yOffset;    
    float hDiff;
    float vDiff;
    
    int currentMonth;
    int currentYear;
    
    BOOL didAddExtraRow;
}

- (void)setMonth:(int)month;
- (void)setYear:(int)year;

- (void)resetRows;

- (BOOL)addExtraRow;

@end
