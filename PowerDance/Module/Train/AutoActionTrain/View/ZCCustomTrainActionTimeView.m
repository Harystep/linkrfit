//
//  ZCCustomTrainActionTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/13.
//

#import "ZCCustomTrainActionTimeView.h"

@interface ZCCustomTrainActionTimeView ()

@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *numL;

@end

@implementation ZCCustomTrainActionTimeView

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
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(18));
        make.height.mas_equalTo(AUTO_MARGIN(55));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UIView *sepView = [[UIView alloc] init];
    [contentView addSubview:sepView];
    sepView.backgroundColor = rgba(228, 228, 228, 1);
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(25));
        make.width.mas_equalTo(AUTO_MARGIN(1));
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"时长", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"00:00:00" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(titleL.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    
    UILabel *actionTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"动作数", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [contentView addSubview:actionTL];
    [actionTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(sepView.mas_trailing).offset(AUTO_MARGIN(40));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    
    self.numL = [self createSimpleLabelWithTitle:@"0" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(actionTL.mas_trailing).offset(AUTO_MARGIN(15));
    }];
    
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    NSInteger num = 0;
    NSInteger count = 0;
    for (NSDictionary *dic in dataArr) {
        count += [dic[@"duration"] integerValue];
        if ([dic[@"rest"] integerValue] == 0) {
            num ++;
        }
    }
    self.numL.text = [NSString stringWithFormat:@"%tu", num];
    self.timeL.text = [ZCDataTool convertMouseToTimeString:count];
}

@end
