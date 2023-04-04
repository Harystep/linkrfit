//
//  ZCSuitNumView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCSuitNumView.h"

@interface ZCSuitNumView ()


@end

@implementation ZCSuitNumView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.numView = [[ZCGoodsNumView alloc] init];
    [self addSubview:self.numView];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(25));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(144);
        make.height.mas_equalTo(34);
    }];
    self.numView.numF.text = @"0";
    self.numView.numF.keyboardType = UIKeyboardTypeNumberPad;
    self.numView.numF.font = FONT_BOLD(16);
    
    UILabel *numL = [self createSimpleLabelWithTitle:NSLocalizedString(@"目标次数/个", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:numL];
    [numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.numView.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(30));
    }];
    
    self.timeView = [[ZCGoodsNumView alloc] init];
    [self addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numView.mas_bottom).offset(AUTO_MARGIN(14));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(144);
        make.height.mas_equalTo(34);
    }];
    self.timeView.numF.text = @"0";
    self.timeView.numF.keyboardType = UIKeyboardTypeNumberPad;
    self.timeView.numF.font = FONT_BOLD(16);
    
    UILabel *timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"目标时长/分", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeView.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(30));
    }];
    
}


@end
