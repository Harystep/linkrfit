//
//  ZCCustomDeleteTrainAlertView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/19.
//

#import "ZCCustomDeleteTrainAlertView.h"

@interface ZCCustomDeleteTrainAlertView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCCustomDeleteTrainAlertView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = rgba(0, 0, 0, 0.4);
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//        [_maskBtn addTarget:self action:@selector(maskBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
        make.width.mas_equalTo(SCREEN_W - AUTO_MARGIN(82));
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"确定删除以下动作？", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(23));
    }];
    
    UILabel *contentL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(18) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:contentL];
    self.contentL = contentL;
    contentL.textAlignment = NSTextAlignmentCenter;
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(38));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(18) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentL.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:14 color:[ZCConfigColor whiteColor]];
    sure.backgroundColor = [ZCConfigColor txtColor];
    [contentView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView).offset(AUTO_MARGIN(60));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(40));
        make.width.mas_equalTo(AUTO_MARGIN(100));
        make.height.mas_equalTo(AUTO_MARGIN(42));
    }];
    sure.tag = 1;
    [sure setViewCornerRadiu:AUTO_MARGIN(21)];
    [sure addTarget:self action:@selector(sureOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel = [self createSimpleButtonWithTitle:NSLocalizedString(@"取消", nil) font:14 color:[ZCConfigColor txtColor]];
    cancel.backgroundColor = rgba(0, 0, 0, 0.1);
    [contentView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView).offset(-AUTO_MARGIN(60));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(40));
        make.width.mas_equalTo(AUTO_MARGIN(100));
        make.height.mas_equalTo(AUTO_MARGIN(42));
    }];
    [cancel setViewCornerRadiu:AUTO_MARGIN(21)];
    cancel.tag = 0;
    [cancel addTarget:self action:@selector(sureOperate:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)sureOperate:(UIButton *)sender {
    [self hideAlertView];
    if (sender.tag) {
        if (self.sureEditOperate) {
            self.sureEditOperate(@"");
        }
    }
}

- (void)maskBtnClick {
//    [self hideAlertView];
}

- (void)setContent:(NSString *)content {
    _content = content;
//    self.contentL.text = content;
    [self.contentL setAttributeStringContent:content space:5 font:FONT_BOLD(AUTO_MARGIN(18)) alignment:NSTextAlignmentCenter];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleL.text = titleStr;
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeL.text = [NSString stringWithFormat:@"%@s", time];
}

@end
