//
//  ZCAutoTimerOperateTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoTimerOperateTimeView.h"

@interface ZCAutoTimerOperateTimeView ()

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIButton *startBtn;

@end

@implementation ZCAutoTimerOperateTimeView

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
    
    UIButton *cancleBtn = [[ZCSimpleButton alloc] init];
    [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = FONT_SYSTEM(20);
    [cancleBtn setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
    [contentView addSubview:cancleBtn];
    self.cancelBtn = cancleBtn;
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.width.height.mas_equalTo(AUTO_MARGIN(80));
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    cancleBtn.tag = 0;
    [cancleBtn setViewCornerRadiu:AUTO_MARGIN(40)];
    cancleBtn.backgroundColor = rgba(244, 244, 244, 1);
    [cancleBtn addTarget:self action:@selector(operateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [[ZCSimpleButton alloc] init];
    [sureBtn setTitle:NSLocalizedString(@"启动", nil) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = FONT_SYSTEM(20);
    [sureBtn setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
    [contentView addSubview:sureBtn];
    self.startBtn = sureBtn;
    [sureBtn setTitle:NSLocalizedString(@"暂停", nil) forState:UIControlStateSelected];
    sureBtn.tag = 1;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.width.height.mas_equalTo(AUTO_MARGIN(80));
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(40)];
    sureBtn.backgroundColor = rgba(244, 244, 244, 1);
    [sureBtn addTarget:self action:@selector(operateClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)operateClick:(UIButton *)sender {
    NSString *content = @"";
    if (sender.tag == 1) {
        content = @"start";
        sender.selected = !sender.selected;
    } else {
        content = @"cancel";
        self.startBtn.selected = NO;
    }
    kweakself(self);
    [sender routerWithEventName:content userInfo:@{@"status":@(sender.selected)} block:^(id  _Nonnull result) {
        weakself.startBtn.selected = NO;        
    }];
}

- (void)resetSubviews {
    self.startBtn.selected = NO;    
}

@end
