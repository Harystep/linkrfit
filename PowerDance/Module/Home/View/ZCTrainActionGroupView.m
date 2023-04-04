//
//  ZCTrainActionGroupView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import "ZCTrainActionGroupView.h"

@implementation ZCTrainActionGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.groupL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.groupL];
    [self.groupL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    self.loopL = [self createSimpleLabelWithTitle:@"" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.loopL];
    [self.loopL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
    }];
}

@end
