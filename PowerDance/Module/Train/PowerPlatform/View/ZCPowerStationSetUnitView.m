//
//  ZCPowerStationSetUnitView.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerStationSetUnitView.h"

@interface ZCPowerStationSetUnitView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UIButton *operateBtn;

@property (nonatomic,strong) UIButton *selectBtn;

@end

@implementation ZCPowerStationSetUnitView

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
        make.height.mas_equalTo(234);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_alert_bg")];
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"设置", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(28);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    CGFloat height = 38;
    NSArray *unitArr = @[@"kg", @"Lb"];
    for (int i = 0; i < unitArr.count; i ++) {
        UIButton *btn = [self createSimpleButtonWithTitle:unitArr[i] font:15 color:rgba(119, 124, 128, 1)];
        [contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(contentView.mas_centerX);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(height);
            make.top.mas_equalTo(contentView.mas_top).offset(75+(height+18)*i);
        }];
        [btn setTitleColor:rgba(248, 125, 0, 1) forState:UIControlStateSelected];
        [btn setBackgroundImage:kIMAGE(@"power_station_btn_nor") forState:UIControlStateNormal];
        [btn setBackgroundImage:kIMAGE(@"power_station_btn_sel") forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(changeUnitOperate:) forControlEvents:UIControlEventTouchUpInside];
    }        
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:kIMAGE(@"power_station_delete") forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(contentView.mas_bottom);
    }];
    [self.deleteBtn addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeUnitOperate:(UIButton *)sender {
    if (sender == self.selectBtn) return;
    self.selectBtn.selected = NO;
    sender.selected = YES;
    self.selectBtn = sender;
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
