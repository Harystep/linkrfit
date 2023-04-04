//
//  ZCClassPlayRestView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/24.
//

#import "ZCClassPlayRestView.h"

@implementation ZCClassPlayRestView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.timeL = [self createSimpleLabelWithTitle:@"" font:40 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(95));
    }];
    
    UIButton *btn = [self createSimpleButtonWithTitle:NSLocalizedString(@"跳过", nil) font:14 color:[ZCConfigColor whiteColor]];
    btn.backgroundColor = kColorHex(@"#4CD995");
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(44));
        make.width.mas_equalTo(AUTO_MARGIN(124));
        make.height.mas_equalTo(AUTO_MARGIN(42));
    }];
    [btn setViewCornerRadiu:AUTO_MARGIN(21)];
    [btn addTarget:self action:@selector(btnOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnOperate {
    [self routerWithEventName:@"restPass" userInfo:@{}];
}

@end
