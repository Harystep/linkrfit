//
//  ZCAlertView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/1.
//

#import "ZCAlertView.h"

@interface ZCAlertView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UITextField *contentF;

@property (nonatomic,strong) UIButton *maskBtn;

@end

@implementation ZCAlertView

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
        make.top.mas_equalTo(AUTO_MARGIN(230));
        make.width.mas_equalTo(AUTO_MARGIN(291));
        make.height.mas_equalTo(AUTO_MARGIN(240));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"给动作组重命名", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(contentView).offset(AUTO_MARGIN(20));
    }];
    
    self.contentF = [[UITextField alloc] init];
    self.contentF.textAlignment = NSTextAlignmentCenter;
    self.contentF.placeholder = NSLocalizedString(@"请输入名称", nil);
    [contentView addSubview:self.contentF];
    [self.contentF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(72));
        make.height.mas_equalTo(AUTO_MARGIN(69));
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"完成", nil) font:14 color:[ZCConfigColor whiteColor]];
    sure.backgroundColor = [ZCConfigColor txtColor];
    [contentView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.mas_equalTo(self.contentF.mas_bottom).offset(AUTO_MARGIN(30));
        make.width.mas_equalTo(AUTO_MARGIN(187));
        make.height.mas_equalTo(AUTO_MARGIN(42));
    }];
    [sure addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    
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
    if (self.contentF.text.length == 0) {
        [self makeToast:NSLocalizedString(@"请输入名称", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (self.sureEditOperate) {
        self.sureEditOperate(self.contentF.text);
    }
    [self hideAlertView];
}

@end
