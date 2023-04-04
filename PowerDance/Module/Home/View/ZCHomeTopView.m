//
//  ZCHomeTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/28.
//

#import "ZCHomeTopView.h"

@interface ZCHomeTopView ()

@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIView *statusView;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation ZCHomeTopView

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
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(STATUS_BAR_HEIGHT + AUTO_MARGIN(36));
        make.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    
    UIButton *myTrain = [self createSimpleButtonWithTitle:NSLocalizedString(@"我的训练", nil) font:20 color:[ZCConfigColor txtColor]];
    myTrain.titleLabel.font = FONT_BOLD(20);
    [contentView addSubview:myTrain];
    [myTrain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView);
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    self.selectBtn = myTrain;
    [myTrain addTarget:self action:@selector(trainOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [ZCConfigColor txtColor];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(myTrain.mas_centerX);
        make.top.mas_equalTo(myTrain.mas_bottom).offset(AUTO_MARGIN(5));
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(3);
    }];
    
    UIButton *historyTrain = [self createSimpleButtonWithTitle:NSLocalizedString(@"历史训练", nil) font:14 color:rgba(43, 42, 51, 0.5)];
    historyTrain.titleLabel.font = FONT_BOLD(14);
    historyTrain.tag = 1;
    [contentView addSubview:historyTrain];
    [historyTrain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(myTrain.mas_trailing).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView);
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    [historyTrain addTarget:self action:@selector(trainOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *timeView = [[UIView alloc] init];
    timeView.backgroundColor = RGBA_COLOR(244, 244, 244, 1);
    [self addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(myTrain);
        make.height.mas_equalTo(AUTO_MARGIN(30));
        make.width.mas_equalTo(AUTO_MARGIN(100));
    }];
    [timeView setViewCornerRadiu:AUTO_MARGIN(15)];
    
    UIImageView *timeIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_time_icon")];
    [timeView addSubview:timeIv];
    [timeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(timeView.mas_trailing).inset(AUTO_MARGIN(5));
        make.centerY.mas_equalTo(timeView);
    }];
    
    self.statusView = [[UIView alloc] init];
    self.statusView.backgroundColor = rgba(255, 97, 97, 1);
    [timeView addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(timeIv.mas_leading).inset(AUTO_MARGIN(8));
        make.centerY.mas_equalTo(timeIv.mas_centerY);
        make.height.width.mas_equalTo(8);
    }];
    [self.statusView setViewCornerRadiu:4];
    
    [self bind];
}

- (void)bind {
    kweakself(self);
    [RACObserve(kUserInfo, status) subscribeNext:^(id  _Nullable x) {
        if ([x integerValue] == 1) {
            weakself.statusView.backgroundColor = UIColor.blueColor;
        } else {
            weakself.statusView.backgroundColor = rgba(255, 97, 97, 1);
        }
    }];
}

- (void)trainOperate:(UIButton *)sender {
    if (sender == self.selectBtn) return;
    self.selectBtn.titleLabel.font = FONT_BOLD(14);
    [self.selectBtn setTitleColor:rgba(43, 42, 51, 0.5) forState:UIControlStateNormal];
    sender.titleLabel.font = FONT_BOLD(20);
    [sender setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
    self.selectBtn = sender;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sender.mas_centerX);
        make.top.mas_equalTo(sender.mas_bottom).offset(AUTO_MARGIN(5));
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(3);
    }];    
    [sender routerWithEventName:[NSString stringWithFormat:@"%tu", sender.tag]];
    
}

@end
