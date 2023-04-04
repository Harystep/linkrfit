//
//  ZCSuitFtrainFinishTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import "ZCSuitFtrainFinishTopView.h"

@interface ZCSuitFtrainFinishTopView ()

@property (nonatomic,strong) UILabel *averageL;
@property (nonatomic,strong) UILabel *lowL;
@property (nonatomic,strong) UILabel *highL;

@end

@implementation ZCSuitFtrainFinishTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(90));
    }];
    [bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"suit_body_heart")];
    [bgView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AUTO_MARGIN(40));
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
//    iconIv.backgroundColor = [ZCConfigColor bgColor];    
    
    UIView *contentView = [[UIView alloc] init];
    [bgView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.top.mas_equalTo(bgView);
        make.leading.mas_equalTo(iconIv.mas_trailing);
    }];
       
    UILabel *averageTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"平均心率", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:averageTL];
    [averageTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(25));
        make.bottom.mas_equalTo(iconIv.mas_bottom).offset(AUTO_MARGIN(3));
    }];
    self.averageL = [self createSimpleLabelWithTitle:NSLocalizedString(@"100MP", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.averageL];
    [self.averageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(averageTL.mas_centerX);
        make.bottom.mas_equalTo(averageTL.mas_top).inset(AUTO_MARGIN(20));
    }];
    
    UILabel *lowTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"最低心率", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:lowTL];
    [lowTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(30));
        make.centerY.mas_equalTo(averageTL.mas_centerY);
    }];
    self.lowL = [self createSimpleLabelWithTitle:NSLocalizedString(@"800MP", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.lowL];
    [self.lowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lowTL.mas_centerX);
        make.bottom.mas_equalTo(lowTL.mas_top).inset(AUTO_MARGIN(20));
    }];
    
    UILabel *highTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"最高心率", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:highTL];
    highTL.textAlignment = NSTextAlignmentCenter;
    [highTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.centerY.mas_equalTo(lowTL.mas_centerY);
    }];
    self.highL = [self createSimpleLabelWithTitle:NSLocalizedString(@"120MP", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    self.highL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:self.highL];
    [self.highL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(highTL.mas_centerX);
        make.bottom.mas_equalTo(highTL.mas_top).inset(AUTO_MARGIN(20));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.averageL.text = checkSafeContent(dataDic[@"avg"]);
    self.highL.text = checkSafeContent(dataDic[@"max"]);
    self.lowL.text = checkSafeContent(dataDic[@"min"]);
}

@end
