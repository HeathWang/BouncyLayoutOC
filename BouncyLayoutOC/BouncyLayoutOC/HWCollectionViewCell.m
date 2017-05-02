//
//  HWCollectionViewCell.m
//  BouncyLayoutOC
//
//  Created by Heath on 28/04/2017.
//  Copyright © 2017 HeathWang. All rights reserved.
//

#import "HWCollectionViewCell.h"

@interface HWCollectionViewCell ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation HWCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.bgView];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    CGFloat gap = 6;
    self.bgView.frame = CGRectMake(gap, gap, CGRectGetWidth(rect) - gap, CGRectGetHeight(rect) - gap);
}

#pragma mark - Getter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blueColor];
    }
    return _bgView;
}


@end
