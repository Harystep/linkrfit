//
//  ZCAutoWRCMiddleTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoWRCMiddleTopView.h"
#import "ZCCircleDialView.h"
#import "ZCSimpleTimeView.h"

@interface ZCAutoWRCMiddleTopView ()

@property (nonatomic,strong) ZCCircleDialView *dialView;

@end

@implementation ZCAutoWRCMiddleTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.dialView = [[ZCCircleDialView alloc] init];
    [self addSubview:self.dialView];
    [self.dialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(15));
        make.width.height.mas_equalTo(307);
    }];
    
    UILabel *timeL = [self createSimpleLabelWithTitle:@"00:00" font:36 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:timeL];
    self.timeL = timeL;
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.dialView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIView *roundView = [[UIView alloc] init];
    [self addSubview:roundView];
    [roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(timeL.mas_bottom).offset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    [roundView setViewCornerRadiu:10];
    roundView.backgroundColor = UIColor.whiteColor;
    
    UILabel *roundTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"圈数", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [roundView addSubview:roundTL];
    [roundTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(roundView.mas_centerY);
        make.leading.mas_equalTo(roundView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    UILabel *roundL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    self.roundL = roundL;
    [roundView addSubview:roundL];
    [roundL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(roundView.mas_centerY);
        make.trailing.mas_equalTo(roundView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
}

@end
