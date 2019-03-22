//
//  KeyConcept.h
//  Study
//
//  Created by Shang Wang on 3/20/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyConcept : UIViewController
@property NSString* name;
@property int page;
@property int subPage;
@property CGPoint position;
@property NSString* keywords;

- (id) initWithVariable: (NSString*) m_name  Page: (int*) m_page   Subpage: (int*)m_subPage   Position: (CGPoint) m_position;
@end

NS_ASSUME_NONNULL_END
