//
//  ZCCurrentActionInfoView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/13.
//

#import "ZCCurrentActionInfoView.h"

@interface ZCCurrentActionInfoView ()


@end

@implementation ZCCurrentActionInfoView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = rgba(255, 255, 255, 0.7);
    [self addSubview:contentView];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(58));
        make.top.bottom.mas_equalTo(self);
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [contentView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"动作详情", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.trailing.mas_equalTo(arrowIv.mas_leading).inset(AUTO_MARGIN(8));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [contentView addGestureRecognizer:tap];
    
}

- (void)tapClick {
    [self routerWithEventName:@"actionDetail" userInfo:@{}];
}

@end
