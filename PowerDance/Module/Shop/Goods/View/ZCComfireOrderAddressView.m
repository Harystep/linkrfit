//
//  ZCComfireOrderAddressView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCComfireOrderAddressView.h"
#import "ZCShopAddressModel.h"

@interface ZCComfireOrderAddressView ()

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *phoneL;
@property (nonatomic,strong) UILabel *addressL;

@end

@implementation ZCComfireOrderAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    
    [self createTopViewSubViews:topView];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"JOHN", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(topView.mas_bottom).offset(AUTO_MARGIN(14));
    }];
    
    self.phoneL = [self createSimpleLabelWithTitle:NSLocalizedString(@"18500000000", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.phoneL];
    [self.phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameL.mas_trailing).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
    }];
    
    self.addressL = [self createSimpleLabelWithTitle:NSLocalizedString(@"江苏省苏州市吴中区工业园区创意产业园11", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.addressL];
    [self.addressL setContentLineFeedStyle];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(12));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
}
#pragma -- mark 添加子控件
- (void)createTopViewSubViews:(UIView *)topView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(43, 42, 51, 0.1);
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topView);
        make.height.mas_equalTo(1);
        make.trailing.mas_equalTo(topView.mas_trailing);
        make.leading.mas_equalTo(topView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"收件人", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [topView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView);
        make.leading.mas_equalTo(topView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [topView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.trailing.mas_equalTo(topView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAddress)];
    [topView addGestureRecognizer:tap];
}

- (void)setModel:(ZCShopAddressModel *)model {
    _model = model;
    self.nameL.text = checkSafeContent(model.realName);
    self.phoneL.text = checkSafeContent(model.phone);
    self.addressL.text = [NSString stringWithFormat:@"%@%@%@%@", checkSafeContent(model.province), checkSafeContent(model.city), checkSafeContent(model.region), checkSafeContent(model.address)];
}

- (void)changeAddress {
    [self routerWithEventName:@"1"];
}

@end
