//
//  ZCClassPlayPauseView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/31.
//

#import "ZCClassPlayPauseView.h"

@interface ZCClassPlayPauseView ()

@end

@implementation ZCClassPlayPauseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
         
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(212));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [bgView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(241));
        make.height.mas_equalTo(AUTO_MARGIN(97));
    }];
    
    UIButton *pauseBtn = [[UIButton alloc] init];
    [contentView addSubview:pauseBtn];
    [pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(AUTO_MARGIN(97));
    }];
    pauseBtn.backgroundColor = rgba(243, 136, 136, 1);
    [pauseBtn setImage:kIMAGE(@"train_class_pause") forState:UIControlStateNormal];
    pauseBtn.tag = 0;
    [pauseBtn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
    [pauseBtn setViewCornerRadiu:AUTO_MARGIN(48.5)];
    
    UIButton *playBtn = [[UIButton alloc] init];
    [contentView addSubview:playBtn];
    playBtn.tag = 1;
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(AUTO_MARGIN(97));
    }];
    playBtn.backgroundColor = rgba(76, 217, 149, 1);
    [playBtn setImage:kIMAGE(@"train_class_play") forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
    [playBtn setViewCornerRadiu:AUTO_MARGIN(48.5)];
}

- (void)btnOperate:(UIButton *)sender {
    [sender routerWithEventName:@"pause" userInfo:@{@"index":@(sender.tag)}];
}

@end
