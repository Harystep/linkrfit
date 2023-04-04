//
//  ZCMyTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/8.
//

#import "ZCMyTopView.h"

@interface ZCMyTopView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UIButton *alertBtn;

@property (nonatomic,strong) UIView *alertView;

@end

@implementation ZCMyTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(60));
        make.top.bottom.mas_equalTo(self);
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(30)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
    _iconIv.userInteractionEnabled = YES;
    [_iconIv addGestureRecognizer:tap];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(20));
    }];
    
    self.alertBtn = [[UIButton alloc] init];
    [self.alertBtn setImage:kIMAGE(@"my_alert_icon") forState:UIControlStateNormal];
    [self addSubview:self.alertBtn];
    self.alertBtn.hidden = YES;
    [self.alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(30));
    }];
    [self.alertBtn addTarget:self action:@selector(noticeOperate) forControlEvents:UIControlEventTouchUpInside];
    
    self.alertView = [[UIView alloc] init];
    self.alertView.hidden = YES;
    self.alertView.backgroundColor = rgba(246, 48, 93, 1);
    [self.alertBtn addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.alertBtn).inset(AUTO_MARGIN(3));
        make.height.width.mas_equalTo(10);
    }];
    [self.alertView setViewCornerRadiu:5];
    
    [self bind];
}

- (void)bind {
    kweakself(self);
    [RACObserve(kUserStore, userData) subscribeNext:^(id  _Nullable x) {
        [weakself.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(x[@"imgUrl"])] placeholderImage:kIMAGE(@"login_icon")];
        [ZCDataTool saveUserPortraint:x[@"imgUrl"]];
        weakself.nameL.text = checkSafeContent(x[@"nickName"]);
    }];
    
    [RACObserve(kUserStore, count) subscribeNext:^(id  _Nullable x) {
        if (kUserStore.count > 0) {
            weakself.alertView.hidden = NO;
        } else {
            weakself.alertView.hidden = YES;
        }
    }];
}

- (void)noticeOperate {
    [HCRouter router:@"ContactService" params:@{} viewController:self.superViewController];
}

- (void)iconClick {
    [HCRouter router:@"ProfileSet" params:@{} viewController:self.superViewController];
}

@end
