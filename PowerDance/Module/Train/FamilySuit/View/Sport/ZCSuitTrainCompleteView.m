//
//  ZCSuitTrainCompleteView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import "ZCSuitTrainCompleteView.h"

@implementation ZCSuitTrainCompleteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.top.bottom.mas_equalTo(self);
    }];
    contentView.backgroundColor = rgba(248, 248, 248, 1);
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UIView *colorView = [[UIView alloc] init];
    [contentView addSubview:colorView];
    colorView.backgroundColor = [ZCConfigColor txtColor];
    [colorView setViewCornerRadiu:AUTO_MARGIN(10)];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(AUTO_MARGIN(190));
    }];
    
    UILabel *alertL = [self createSimpleLabelWithTitle:NSLocalizedString(@"😄已完成目标", nil) font:AUTO_MARGIN(12) bold:NO color:rgba(76, 217, 149, 1)];
    [contentView addSubview:alertL];
    [alertL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
}

@end
