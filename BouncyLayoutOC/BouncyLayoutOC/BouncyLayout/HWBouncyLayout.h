//
//  HWBouncyLayout.h
//  BouncyLayoutOC
//
//  Created by Heath on 28/04/2017.
//  Copyright © 2017 HeathWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BouncyLayoutStyle) {
    BouncyLayoutStyleSubtle,
    BouncyLayoutStyleRegular,
    BouncyLayoutStyleProminent,
};

@interface HWBouncyLayout : UICollectionViewFlowLayout

- (instancetype)initWithDamping:(CGFloat)damping frequency:(CGFloat)frequency;
- (instancetype)initWithStyle:(BouncyLayoutStyle)style;

@end
