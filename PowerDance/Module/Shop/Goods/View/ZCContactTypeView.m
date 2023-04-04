//
//  ZCContactTypeView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCContactTypeView.h"

@interface ZCContactTypeView ()


@end

@implementation ZCContactTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    
    UIView *nameView = [[UIView alloc] init];
    [self addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(51);
    }];
    self.nameF = [self createInputView:nameView title:NSLocalizedString(@"收货人", nil) placeStr:NSLocalizedString(@"请输入姓名", nil)];
    
    UIView *phoneView = [[UIView alloc] init];
    [self addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(nameView.mas_bottom);
        make.height.mas_equalTo(51);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];    
    self.phoneF = [self createInputView:phoneView title:NSLocalizedString(@"联系电话", nil) placeStr:NSLocalizedString(@"手机号码", nil)];
    
}

- (UITextField *)createInputView:(UIView *)view title:(NSString *)title placeStr:(NSString *)placeStr {
      
    UILabel *nameL = [self createSimpleLabelWithTitle:title font:14 bold:YES color:[ZCConfigColor txtColor]];
    nameL.text = title;
    [view addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(18));
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    [view addSubview:tf];
    tf.textAlignment = NSTextAlignmentLeft;
    tf.placeholder = placeStr;
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(view.mas_trailing);
        make.top.bottom.mas_equalTo(view);
        make.leading.mas_equalTo(view.mas_leading).offset(105);
    }];
    tf.font = FONT_BOLD(15);
    tf.textColor = [ZCConfigColor txtColor];
    
    UIView *lineView = [[UIView alloc] init];
    [view addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(view).inset(AUTO_MARGIN(18));
        make.bottom.mas_equalTo(view.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    return tf;
}

- (void)setModel:(ZCShopAddressModel *)model {
    _model = model;
    self.nameF.text = model.realName;
    self.phoneF.text = model.phone;
}

@end
