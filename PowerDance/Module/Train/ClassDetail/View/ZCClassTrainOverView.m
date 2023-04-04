//
//  ZCClassTrainOverView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/6.
//

#import "ZCClassTrainOverView.h"

@interface ZCClassTrainOverView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation ZCClassTrainOverView

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
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    self.contentView = contentView;
    [self addSubview:contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(AUTO_MARGIN(291));
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_play_stop_bg")];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(contentView);
        make.height.mas_equalTo(AUTO_MARGIN(133));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(43, 42, 51, 0.1);
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconIv.mas_bottom).offset(AUTO_MARGIN(83));
        make.leading.trailing.mas_equalTo(contentView);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"不再多练一会?", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    self.titleL = lb;
    lb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconIv.mas_bottom).offset(AUTO_MARGIN(37));
        make.leading.trailing.mas_equalTo(contentView);        
    }];
    
    UIView *verView = [[UIView alloc] init];
    verView.backgroundColor = rgba(43, 42, 51, 0.1);
    [contentView addSubview:verView];
    [verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_top).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(33));
        make.width.mas_equalTo(AUTO_MARGIN(1));
        make.centerX.mas_equalTo(contentView.mas_centerX);
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"直接退出", nil) font:14 color:rgba(250, 106, 2, 1)];
    [contentView addSubview:sure];
    sure.tag = 0;
    self.rightBtn = sure;
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.leading.mas_equalTo(verView.mas_trailing);
        make.bottom.trailing.mas_equalTo(contentView);
    }];
    [sure addTarget:self action:@selector(sureOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *continueBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"继续训练", nil) font:14 color:[ZCConfigColor txtColor]];
    continueBtn.tag = 1;
    [contentView addSubview:continueBtn];
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.trailing.mas_equalTo(verView.mas_leading);
        make.bottom.leading.mas_equalTo(contentView);
    }];
    self.leftBtn = continueBtn;
    [continueBtn addTarget:self action:@selector(sureOperate:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setTitleStr:(NSString *)titleStr {
    self.titleL.text = titleStr;
}

- (void)setLeftStr:(NSString *)leftStr {
    [self.leftBtn setTitle:leftStr forState:UIControlStateNormal];
}

- (void)setRightStr:(NSString *)rightStr {
    [self.rightBtn setTitle:rightStr forState:UIControlStateNormal];
}

- (void)sureOperate:(UIButton *)sender {
    [self hideAlertView];
    if (self.handleTrainOperate) {
        self.handleTrainOperate(sender.tag);
    }
}

- (void)showAlertView {
    self.frame = UIScreen.mainScreen.bounds;
    [self.superViewController.view addSubview:self];
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
