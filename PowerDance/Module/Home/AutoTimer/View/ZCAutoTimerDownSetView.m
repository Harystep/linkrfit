//
//  ZCAutoTimerDownSetView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoTimerDownSetView.h"
#import "ZCTimerDownSetOtherView.h"

@interface ZCAutoTimerDownSetView ()

@property (nonatomic,strong) ZCTimerDownSetOtherView *setView;

@end

@implementation ZCAutoTimerDownSetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self);
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
    }];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.setView = [[ZCTimerDownSetOtherView alloc] init];
    [self addSubview:self.setView];
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(150));
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:14 color:[ZCConfigColor whiteColor]];
    sure.backgroundColor = [ZCConfigColor txtColor];
    [contentView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(27));
        make.width.mas_equalTo(AUTO_MARGIN(187));
        make.height.mas_equalTo(AUTO_MARGIN(42));
    }];
    [sure addTarget:self action:@selector(saveOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveOperate {
    if (self.saveBownTimeOperate) {
        NSString *content = [NSString stringWithFormat:@"%02zd:%02zd", [self.setView.minuteStr integerValue], [self.setView.mouseStr integerValue]];
        self.saveBownTimeOperate(content);
    }
}

@end
