//
//  SYBUpdateVersionView.m
//  CashierChoke
//
//  Created by warmStep on 2021/7/19.
//  Copyright © 2021 zjs. All rights reserved.
//

#import "CFFUpdateVersionView.h"

@interface CFFUpdateVersionView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *topImageBg;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation CFFUpdateVersionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        if (@available(iOS 13.0, *)) {
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        } else {
        
        }
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    
    self.alertTitle = [self createSimpleLabelWithTitle:NSLocalizedString(@"更新提示", nil) font:15 bold:YES color:kCFF_COLOR_CONTENT_TITLE];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.layer.cornerRadius  = 5.f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = UIColor.whiteColor;
    
    self.lineView  = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    self.sepView  = [[UIView alloc] init];
    self.sepView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AUTO_MARGIN(15)];
    [self.cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:kColorHex(@"#333333") forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn = [[UIButton alloc] init];
    self.confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AUTO_MARGIN(15)];
    [self.confirmBtn setTitle:NSLocalizedString(@"更新", nil) forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.backgroundColor = kCFF_BG_COLOR_GREEN_COMMON;
    
    self.topImageBg = [[UIImageView alloc] init];
    self.topImageBg.image = kIMAGE(@"home_update_bg");
    
    self.alertMessage = [[UILabel alloc] init];
    self.alertMessage.font = FONT_SYSTEM(14);
    self.alertMessage.text = @"详细内容";
    self.alertMessage.textColor = kColorHex(@"#666666");
    self.alertMessage.textAlignment = NSTextAlignmentCenter;
    self.alertMessage.numberOfLines = 0;
}

- (void)setupConstraints {
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.mas_offset(kCFF_SCREEN_WIDTH * 0.75);
    }];
    
    [self.contentView setViewCornerRadius:15];
    
    [self.contentView addSubview:self.alertTitle];
    [self.alertTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(15));
    }];
    
    [self.contentView addSubview:self.sepView];
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertTitle.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    [self.contentView addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sepView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.bottomView addSubview:self.alertMessage];
    [self.alertMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.bottomView.mas_top).mas_offset(AUTO_MARGIN(20));
        make.leading.trailing.mas_equalTo(self.bottomView).inset(AUTO_MARGIN(20));
    }];
    
    [self.bottomView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.alertMessage.mas_bottom).mas_offset(AUTO_MARGIN(25));
        make.leading.trailing.mas_equalTo(self.bottomView);
        make.height.mas_offset(AUTO_MARGIN(1));
    }];
    
    [self.bottomView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.leading.bottom.mas_equalTo(self.bottomView);
        make.width.mas_offset(kCFF_SCREEN_WIDTH * 0.375);
        make.height.mas_offset(kCFF_SCREEN_WIDTH * 0.12);
    }];
    
    [self.bottomView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.cancelBtn);
        make.leading.mas_equalTo(self.cancelBtn.mas_trailing);
        make.trailing.mas_equalTo(self.bottomView.mas_trailing);
    }];
    
    
}

- (void)setTitle:(NSString *)title {
    self.alertTitle.text = title;
}

#pragma mark -- Public Methods
- (void)showAlertView {
    
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.35 animations:^{
       
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark -- Private Methods
- (void)cancelAction {
    [self hideAlertView];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmAction {
 
    [self hideAlertView];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)hideAlertView {
    
    self.contentView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.35 animations:^{
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
       
        [self removeFromSuperview];
    }];
}

- (void)setMessage:(NSString *)message {
    
    _message = message;
    self.alertMessage.text = [message stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
}

- (void)setCancleTitle:(NSString *)cancleTitle {
    
    _cancleTitle = cancleTitle;
    [self.cancelBtn setTitle:cancleTitle forState:UIControlStateNormal];
}

- (void)setConfirmTitle:(NSString *)confirmTitle {
    
    _confirmTitle = confirmTitle;
    [self.confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
}

- (void)setMessageColor:(UIColor *)messageColor {
    
    _messageColor = messageColor;
    self.alertMessage.textColor = messageColor;
}

- (void)setCancelTitleColor:(UIColor *)cancelTitleColor {
    
    _cancelTitleColor = cancelTitleColor;
    [self.cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
}

- (void)setConfirmTitleColor:(UIColor *)confirmTitleColor {
    
    _confirmTitleColor = confirmTitleColor;
    [self.confirmBtn setTitleColor:confirmTitleColor forState:UIControlStateNormal];
}

- (void)setConfirmBackgroundColor:(UIColor *)confirmBackgroundColor {
    
    _confirmBackgroundColor = confirmBackgroundColor;
    self.confirmBtn.backgroundColor = confirmBackgroundColor;
}


- (void)setHideCancelBtn:(BOOL)hideCancelBtn {
    
    _hideCancelBtn = hideCancelBtn;
    self.cancelBtn.hidden = YES;
    [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_offset(0);
    }];
}


@end
