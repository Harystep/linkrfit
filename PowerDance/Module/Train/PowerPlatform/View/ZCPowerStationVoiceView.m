//
//  ZCPowerStationVoiceView.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerStationVoiceView.h"

@interface ZCPowerStationVoiceView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIButton *deleteBtn;


@end

@implementation ZCPowerStationVoiceView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = rgba(0, 0, 0, 0.4);
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    }
    return _maskBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.maskBtn];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [self addSubview:contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(165);
        make.width.mas_equalTo(195);
        make.height.mas_equalTo(380);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_alert_bg")];
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:14 color:[ZCConfigColor whiteColor]];
    [self.contentView  addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(40);
        make.width.mas_equalTo(182);
        make.height.mas_equalTo(42);
    }];
    [sure addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    [sure layoutIfNeeded];
    
    [sure configureLeftToRightViewColorGradient:sure width:182 height:42 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:21];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:kIMAGE(@"power_station_delete") forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(contentView.mas_bottom);
    }];
    [self.deleteBtn addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
}


- (void)showAlertView {
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    [self removeFromSuperview];
}

- (void)sureOperate {
    
    [self hideAlertView];
}

@end
