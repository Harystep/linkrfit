//
//  ZCComfireOrderPayView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCComfireOrderPayView.h"

@interface ZCComfireOrderPayView ()

@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation ZCComfireOrderPayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"order_pay_alipay")];
    self.iconIv = iconIv;
    [self addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.mas_equalTo(AUTO_MARGIN(14));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(38));
    }];
    [iconIv setViewCornerRadiu:AUTO_MARGIN(15)];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [self addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"支付方式", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTypeOperate)];
    [self addGestureRecognizer:tap];
    
}

- (void)setType:(PayType)type {
    _type = type;
    if (type == PayTypeAlipay) {
        self.iconIv.image = kIMAGE(@"order_pay_alipay");
    } else {
        self.iconIv.image = kIMAGE(@"order_pay_wx");
    }
}

- (void)payTypeOperate {
    [self routerWithEventName:@"2"];
}

@end
