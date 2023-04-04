//
//  ZCDeviceConnectAlertView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/29.
//

#import "ZCDeviceConnectAlertView.h"

@interface ZCDeviceConnectAlertView ()

@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titleL;

@end

@implementation ZCDeviceConnectAlertView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = UIColor.blackColor;
        _maskBtn.alpha = 0.4;
        _maskBtn.frame = CGRectMake(0, 0, kCFF_SCREEN_WIDTH, kCFF_SCREEN_HEIGHT);
        [_maskBtn addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
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
        
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColor.whiteColor;
    self.contentView = contentView;
    [contentView setViewCornerRadiu:15];
    [self addSubview:contentView];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"设备如何连接", nil) font:14 bold:YES color:kCFF_COLOR_CONTENT_TITLE];
    self.titleL = titleL;
    titleL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(contentView).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(18));
    }];
    
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.height.width.mas_equalTo(AUTO_MARGIN(80));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    UILabel *assignL = [self createSimpleLabelWithTitle:@"······" font:AUTO_MARGIN(15) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:assignL];
    [assignL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(22));
    }];
    
    //请确保体脂秤是打开状态\n没有体脂秤依然可以手动填写体重哦
    UILabel *alertL = [self createSimpleLabelWithTitle:NSLocalizedString(@"tizhichenglianjietishi", nil) font:12 bold:NO color:RGBA_COLOR(0, 0, 0, 0.5)];
    [contentView addSubview:alertL];
    self.alertL = alertL;
    alertL.textAlignment = NSTextAlignmentLeft;
    alertL.numberOfLines = 0;
    alertL.lineBreakMode = NSLineBreakByCharWrapping;
    [alertL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(assignL.mas_bottom).offset(AUTO_MARGIN(40));
    }];
    
    UIButton *againBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"取消连接", nil) font:15 color:UIColor.whiteColor];
    againBtn.backgroundColor = [ZCConfigColor txtColor];
    [contentView addSubview:againBtn];
    [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(alertL.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [againBtn addTarget:self action:@selector(tryItAgain) forControlEvents:UIControlEventTouchUpInside];
    [againBtn setViewCornerRadiu:AUTO_MARGIN(20)];
    
}


- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleL.text = titleStr;
}

- (void)tryItAgain {
    if (self.BlueConnectAttempt) {
        self.BlueConnectAttempt();
        [self hideAlertView];
    }
}

- (void)showAlertView {
    self.frame = [UIScreen mainScreen].bounds;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self.maskBtn];
    [win addSubview:self];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(291));
        make.centerX.mas_equalTo(win.mas_centerX);
        make.top.mas_equalTo(win.mas_top).offset(AUTO_MARGIN(208));
    }];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    self.contentView = nil;
    [self removeFromSuperview];
}

@end
