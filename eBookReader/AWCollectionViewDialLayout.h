//
//  AWCollectionViewDialLayout.h
//  Created by Antoine Wette on github: https://github.com/awdigital/AWCollectionViewDialLayout
//

#import <UIKit/UIKit.h>

@interface AWCollectionViewDialLayout : UICollectionViewLayout

typedef enum WheelAlignmentType : NSInteger WheelAlignmentType;
enum WheelAlignmentType : NSInteger {
    WHEELALIGNMENTLEFT,
    WHEELALIGNMENTCENTER
};

@property (readwrite, nonatomic, assign) int cellCount;
@property (readwrite, nonatomic, assign) int wheelType;
@property (readwrite, nonatomic, assign) CGPoint center;
@property (readwrite, nonatomic, assign) CGFloat offset;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat xOffset;
@property (readwrite, nonatomic, assign) CGSize cellSize;
@property (readwrite, nonatomic, assign) CGFloat AngularSpacing;
@property (readwrite, nonatomic, assign) CGFloat dialRadius;
@property (readonly, nonatomic, strong) NSIndexPath *currentIndexPath;


-(id)initWithRadius: (CGFloat) radius andAngularSpacing: (CGFloat) spacing andCellSize: (CGSize) cell andAlignment:(WheelAlignmentType)alignment andItemHeight:(CGFloat)height andXOffset: (CGFloat) xOffset;
@end
