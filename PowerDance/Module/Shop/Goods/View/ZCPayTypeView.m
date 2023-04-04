//
//  ZCPayTypeView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCPayTypeView.h"


@implementation ZCPayTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(300));
    }];
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"选择支付方式", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(30));
    }];
    
    UIButton *alipay = [self createSimpleButtonWithTitle:NSLocalizedString(@"支付宝", nil) font:14 color:[ZCConfigColor txtColor]];
    alipay.tag = 0;
    [alipay setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [alipay setImage:kIMAGE(@"order_pay_alipay") forState:UIControlStateNormal];
    [contentView addSubview:alipay];
    [alipay dn_layoutButtonEdgeInset:DNEdgeInsetStyleRight space:10];
    
    UIButton *wechat = [self createSimpleButtonWithTitle:NSLocalizedString(@"微信", nil) font:14 color:[ZCConfigColor txtColor]];
    [wechat setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    wechat.tag = 1;
    [wechat setImage:kIMAGE(@"order_pay_wx") forState:UIControlStateNormal];
    [contentView addSubview:wechat];
    [alipay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(49));
        make.height.mas_equalTo(AUTO_MARGIN(60));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGINY(20));
    }];
    [wechat dn_layoutButtonEdgeInset:DNEdgeInsetStyleRight space:10];
    
    [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alipay.mas_bottom).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(60));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGINY(20));
    }];
    [wechat addTarget:self action:@selector(payTypeOperate:) forControlEvents:UIControlEventTouchUpInside];
    [alipay addTarget:self action:@selector(payTypeOperate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)payTypeOperate:(UIButton *)sender {
    [sender routerWithEventName:[NSString stringWithFormat:@"%tu", sender.tag] userInfo:@{}];
}


@end
