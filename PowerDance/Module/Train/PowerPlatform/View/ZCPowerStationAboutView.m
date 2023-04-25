//
//  ZCPowerStationAboutView.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerStationAboutView.h"

@interface ZCPowerStationAboutView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UITextField *contentF;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *baseView;//基本信息视图

@property (nonatomic,strong) UIImageView *updateIv;//更新视图

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) NSData *gifData;

@property (nonatomic,strong) UIView *faiView;//升级失败视图

@property (nonatomic,strong) UIButton *operateBtn;

@property (nonatomic,strong) UIView *updateSuccessView;

@property (nonatomic,strong) UILabel *systemL;//系统版本
@property (nonatomic,strong) UILabel *driveL;//序列号
@property (nonatomic,strong) UILabel *numL;//序列号
@property (nonatomic,strong) UILabel *descL;

@end

@implementation ZCPowerStationAboutView

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
        make.width.mas_equalTo(297);
        make.height.mas_equalTo(338);
    }];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"power_station_alert_bg")];
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"关于本机", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(28);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    NSArray *titleArr = @[NSLocalizedString(@"系统版本", nil), NSLocalizedString(@"驱动器版本", nil), NSLocalizedString(@"序列号", nil)];
    CGFloat height = 22;
    for (int i = 0; i < titleArr.count; i ++) {
        UIView *itemView = [[UIView alloc] init];
        [self.contentView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.contentView).inset(55);
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(32+height*i);
            make.height.mas_equalTo(height);
        }];
        UILabel *titleL = [self createSimpleLabelWithTitle:titleArr[i] font:14 bold:YES color:[ZCConfigColor txtColor]];
        [itemView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(itemView.mas_leading);
            make.centerY.mas_equalTo(itemView.mas_centerY);
        }];
        
        UILabel *contentL = [self createSimpleLabelWithTitle:@"XXX" font:14 bold:YES color:[ZCConfigColor txtColor]];
        [itemView addSubview:contentL];
        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(itemView.mas_trailing);
            make.centerY.mas_equalTo(itemView.mas_centerY);
        }];
        if (i == 0) {
            self.systemL = contentL;
        } else if (i == 1) {
            self.driveL = contentL;
        } else {
            self.numL = contentL;
        }
    }
    
    UILabel *contentL = [self createSimpleLabelWithTitle:@"XXX" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(30);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(118);
    }];
    NSString *contentDesc = @"此处是介绍的内容此处是介绍的内容此处是介绍的内容，此处是介绍的内此处是介绍的内容此处是介绍的内容容，此处是介绍的内容。此处是介绍的内容此处是介绍的内容";
    [contentL setAttributeStringContent:contentDesc space:5 font:FONT_BOLD(13) alignment:NSTextAlignmentCenter];
    [contentL setContentLineFeedStyle];
    
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
