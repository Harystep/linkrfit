//
//  ZCDeviceSimpleView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/23.
//

#import "ZCDeviceSimpleView.h"

@interface ZCDeviceSimpleView ()

@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation ZCDeviceSimpleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"连接智能设备", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_time_icon")];
    self.iconIv = iconIv;
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    
}

- (void)tapClick {
    //SmartTimer  TrainTimer
    [HCRouter router:@"SmartTimer" params:@{} viewController:self.superViewController animated:YES];
}

@end
