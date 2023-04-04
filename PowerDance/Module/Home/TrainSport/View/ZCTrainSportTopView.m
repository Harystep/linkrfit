//
//  ZCTrainSportTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/2.
//

#import "ZCTrainSportTopView.h"

@interface ZCTrainSportTopView ()

@end

@implementation ZCTrainSportTopView

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
        make.edges.mas_equalTo(self);
    }];        
    
    UILabel *timeTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"剩余总时长", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [contentView addSubview:timeTL];
    [timeTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(15));
    }];
    
    UILabel *totalTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"已用总时长", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [contentView addSubview:totalTL];    
    [totalTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(15));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"00:00:00", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(timeTL);
        make.top.mas_equalTo(timeTL.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(5));
    }];
    
    self.totalL = [self createSimpleLabelWithTitle:NSLocalizedString(@"00:00:00", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.totalL];
    [self.totalL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(totalTL);
        make.top.mas_equalTo(totalTL.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    
    self.precentL = [self createSimpleLabelWithTitle:@"/" font:40 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.precentL];
    [self.precentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.bottom.mas_equalTo(contentView);
    }];
}

@end
