//
//  ZCAutoTimerSetTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoTimerSetTimeView.h"

@interface ZCAutoTimerSetTimeView ()

@end

@implementation ZCAutoTimerSetTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = rgba(244, 244, 244, 1);
    [self addSubview:contentView];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(65));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"00:00:00" font:36 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"设置时间", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_bottom).offset(AUTO_MARGIN(5));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeOperate)];
    [self addGestureRecognizer:tap];
}

- (void)timeOperate {
    [self routerWithEventName:@"time" userInfo:@{}];
}

@end
