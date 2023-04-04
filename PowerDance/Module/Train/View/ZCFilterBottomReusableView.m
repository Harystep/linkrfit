//
//  ZCFilterBottomReusableView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/21.
//

#import "ZCFilterBottomReusableView.h"

@implementation ZCFilterBottomReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(90));
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self createBottomViewSubviews:bottomView];
}

- (void)createBottomViewSubviews:(UIView *)bottomView {
    UIView *lineView = [[UIView alloc] init];
    [bottomView addSubview:lineView];
    lineView.backgroundColor = rgba(43, 42, 51, 0.1);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(bottomView);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    UIButton *sureBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:14 color:[ZCConfigColor whiteColor]];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    [bottomView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.trailing.mas_equalTo(bottomView.mas_trailing).inset(AUTO_MARGIN(20));
        make.leading.mas_equalTo(bottomView.mas_leading).offset(AUTO_MARGIN(75));
    }];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [sureBtn addTarget:self action:@selector(sureBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cleanBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"清除", nil) font:12 color:[ZCConfigColor txtColor]];
    [bottomView addSubview:cleanBtn];
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sureBtn.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(50));
        make.leading.mas_equalTo(bottomView.mas_leading).offset(AUTO_MARGIN(12));
    }];
    [cleanBtn setImage:kIMAGE(@"train_category_clean") forState:UIControlStateNormal];
    [cleanBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleTop space:4];
    [cleanBtn addTarget:self action:@selector(cleanBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    

    
}

@end
