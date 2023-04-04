//
//  ZCHomeRecommendClassHeaderView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeRecommendClassHeaderView.h"

@interface ZCHomeRecommendClassHeaderView ()

@end

@implementation ZCHomeRecommendClassHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
   
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    UIView *assignView = [[UIView alloc] init];
    [self addSubview:assignView];
    assignView.backgroundColor = rgba(138, 205, 215, 1);
    [assignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(self.mas_top).offset(30);
        make.leading.mas_equalTo(self.mas_leading).offset(20);
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [assignView setViewCornerRadiu:1.5];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"智能设备健身课程推荐", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(assignView.mas_centerY);
        make.leading.mas_equalTo(assignView.mas_trailing).offset(AUTO_MARGIN(5));
    }];
    
    UIButton *setBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"换一批", nil) font:AUTO_MARGIN(12) color:[ZCConfigColor subTxtColor]];
    [self addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(assignView.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(AUTO_MARGIN(60));
    }];
    [setBtn addTarget:self action:@selector(resetPlanOperate) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setImage:kIMAGE(@"home_recommend_refresh") forState:UIControlStateNormal];
    [setBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:1];
    
}

- (void)resetPlanOperate {
    [self routerWithEventName:@"refreshRecommend" userInfo:@{}];
}

@end
