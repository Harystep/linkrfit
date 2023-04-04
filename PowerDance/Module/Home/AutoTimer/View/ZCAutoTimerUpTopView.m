//
//  ZCAutoTimerUpTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoTimerUpTopView.h"
#import "ZCSimpleTimeView.h"

@interface ZCAutoTimerUpTopView ()

@end

@implementation ZCAutoTimerUpTopView

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
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(5));
    }];
    
//    UILabel *timeL = [self createSimpleLabelWithTitle:@"00:00" font:36 bold:YES color:[ZCConfigColor txtColor]];
//    self.timeL = timeL;
//    [self addSubview:timeL];
//    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.top.mas_equalTo(self.dialView.mas_bottom).offset(AUTO_MARGIN(20));
//        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
//    }];
}

@end
