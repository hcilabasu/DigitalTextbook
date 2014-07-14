//
//  LSTabItem.h
//  LSTabs
//
//  Created by Marco Mussini on 1/3/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2012 Marco Mussini - Lucky Software

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class LSTabItem;
@class LSTabControl;


@protocol LSTabItemDelegate <NSObject>

- (void)tabItem:(LSTabItem *)item badgeNumberChangedTo:(int)value;
- (void)tabItem:(LSTabItem *)item titleChangedTo:(NSString *)title;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////


@class LSTabControl;


@interface LSTabItem : NSObject {
  @protected
    NSString     *title;
    id            object;
    NSInteger     badgeNumber;
    LSTabControl *parentTabControl;
}

@property (nonatomic, copy)	  NSString     *title;
@property (nonatomic, retain) id			object;
@property (nonatomic) NSInteger	 badgeNumber;

/**
 * Integer identifier useful to identify the item when nor the title or the object properties
 * are valid to recognize the item's type
 */
@property (nonatomic, assign) NSUInteger	 idMask;

@property (nonatomic,strong) LSTabControl *parentTabControl;


/**
 * Identical to the designated initializer but force selectable to YES
 */
- (id)initWithTitle:(NSString *)aTitle;


@end