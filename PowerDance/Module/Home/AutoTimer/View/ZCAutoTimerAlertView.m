//
//  ZCAutoTimerAlertView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoTimerAlertView.h"

@interface ZCAutoTimerAlertView ()

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *contentL;

@end

@implementation ZCAutoTimerAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIImageView *downIv = [[UIImageView alloc] initWithImage:kIMAGE(@"timer_auto_down")];
    [self addSubview:downIv];
    [downIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(self.mas_centerX).offset(AUTO_MARGIN(24));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self);
        make.bottom.mas_equalTo(downIv.mas_top).inset(-AUTO_MARGIN(15));
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"什么是HIIT", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    self.titleL = lb;
    [contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(contentView).offset(AUTO_MARGIN(20));
    }];
    
    UILabel *contentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"合理的要求叫做锻炼，不合理的要求叫做磨炼合理的要求叫做锻炼，不合理的要求叫做磨炼，合理的要求叫做锻炼，不合理的要求叫做磨炼合理的要求叫做锻炼，不合理的要求叫做磨炼", nil) font:12 bold:NO color:[ZCConfigColor subTxtColor]];
    self.contentL = contentL;
    [contentL setContentLineFeedStyle];
    [contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lb.mas_leading);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(16));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
    
}

- (void)setType:(NSString *)type {
    _type = type;
    self.titleL.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"什么是", nil), type];
    self.contentL.text = [ZCBluthDataTool convertModeContentWithType:type];
}

@end
