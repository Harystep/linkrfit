//
//  ZCAutoTimerUpStatusView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/21.
//

#import "ZCAutoTimerUpStatusView.h"

@interface ZCAutoTimerUpStatusView ()

@property (nonatomic,strong) UIButton *selectBtn;

@end

@implementation ZCAutoTimerUpStatusView

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
        make.edges.mas_equalTo(self);
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UIButton *upBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"正计时", nil) font:14 color:[ZCConfigColor txtColor]];
    [upBtn setTitleColor:[ZCConfigColor whiteColor] forState:UIControlStateSelected];
    [contentView addSubview:upBtn];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(AUTO_MARGIN(100));
    }];
    upBtn.backgroundColor = rgba(135, 131, 192, 1);
    upBtn.selected = YES;
    self.selectBtn = upBtn;
    upBtn.tag = 0;
    [upBtn addTarget:self action:@selector(operateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"倒计时", nil) font:14 color:[ZCConfigColor txtColor]];
    [downBtn setTitleColor:[ZCConfigColor whiteColor] forState:UIControlStateSelected];
    [contentView addSubview:downBtn];
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentView);
        make.leading.mas_equalTo(upBtn.mas_trailing);
        make.width.mas_equalTo(AUTO_MARGIN(100));
    }];
    downBtn.backgroundColor = rgba(243, 243, 243, 1);
    downBtn.tag = 1;
    [downBtn addTarget:self action:@selector(operateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)operateBtn:(UIButton *)sender {
//    if (sender == self.selectBtn) return;
    [sender routerWithEventName:@"status" userInfo:@{@"index":@(sender.tag)}];
    self.selectBtn.backgroundColor = rgba(243, 243, 243, 1);
    self.selectBtn.selected = NO;
    sender.selected = YES;
    sender.backgroundColor = rgba(135, 131, 192, 1);
    self.selectBtn = sender;
}

@end
