//
//  CFFChangeNickView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/4.
//

#import "ZCChangeNickView.h"

@interface ZCChangeNickView ()

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleL;

@end

@implementation ZCChangeNickView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = UIColor.blackColor;
        _maskBtn.alpha = 0.3;
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [_maskBtn addTarget:self action:@selector(maskBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
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
    self.contentView = [[UIView alloc] init];
    [self.contentView setViewCornerRadiu:15];
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(290));
        make.height.mas_equalTo(AUTO_MARGIN(240));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(120));
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"修改昵称", nil) font:15 bold:NO color:RGBA_COLOR(0, 0, 0, 0.5)];
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGBA_COLOR(247, 247, 247, 1);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(72));
        make.height.mas_equalTo(AUTO_MARGIN(70));
        make.width.mas_equalTo(AUTO_MARGIN(204));
    }];
    [bgView setViewCornerRadiu:10];
    
    UITextField *tf = [[UITextField alloc] init];
    self.tf = tf;
    tf.font = FONT_SYSTEM(15);
    tf.textColor = [ZCConfigColor txtColor];
    tf.placeholder = NSLocalizedString(@"请输入昵称", nil);
    tf.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bgView).inset(AUTO_MARGIN(10));
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
     
    self.unitL = [self createSimpleLabelWithTitle:@"KG" font:14 bold:YES color:RGBA_COLOR(0, 0, 0, 0.5)];
    self.unitL.hidden = YES;
    [bgView addSubview:self.unitL];
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(10));
        make.centerY.mas_equalTo(tf.mas_centerY);
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"立即修改", nil) font:15 color:UIColor.whiteColor];
    sure.backgroundColor = [ZCConfigColor txtColor];
    [self.contentView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).offset(AUTO_MARGIN(30));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(AUTO_MARGIN(190));
        make.height.mas_equalTo(AUTO_MARGIN(42));
    }];
    [sure setViewCornerRadiu:AUTO_MARGIN(21)];
    [sure addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleL.text = title;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.tf.placeholder = placeholder;
}

- (void)sureOperate {
    if (self.tf.text.length > 0) {
        if (self.SaveNickOperate) {
            self.SaveNickOperate(self.tf.text);
        }
        [self maskBtnDidClick];
    } else {
        
    }
}

- (void)showAlertView {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
    self.maskBtn.hidden = NO;
    self.contentView.hidden = NO;
    self.hidden = NO;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(win);
    }];
    
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)maskBtnDidClick {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    self.hidden = YES;
    self.tf.text = @"";
    [self endEditing:YES];
}

@end
