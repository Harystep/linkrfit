//
//  ZCArrviveAddressView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCArrviveAddressView.h"

@interface ZCArrviveAddressView ()<UITextViewDelegate>

@end

@implementation ZCArrviveAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    
    UIView *regionView = [[UIView alloc] init];
    [self addSubview:regionView];
    [regionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(51);
        make.top.leading.trailing.mas_equalTo(self);
    }];
    
    UIView *detailView = [[UIView alloc] init];
    [self addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(75);
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(regionView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);;
    }];
    
    self.addressF = [self createInputView:regionView title:NSLocalizedString(@"所在地区", nil) placeStr:NSLocalizedString(@"省、市、区", nil)];
    
    [self setupDetailViewSubViews:detailView];
    
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
    
    UIButton *coverBtn = [[UIButton alloc] init];
    [tf addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(tf);
    }];
    [coverBtn addTarget:self action:@selector(selectAddressOperate) forControlEvents:UIControlEventTouchUpInside];
    
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
#pragma -- mark 选择地址
- (void)selectAddressOperate {
    BRAddressPickerView *pickerView = [[BRAddressPickerView alloc]
                                       initWithPickerMode:BRAddressPickerModeArea];
    pickerView.dataSourceArr = [ZCDataTool cityData];
    kweakself(self);
    pickerView.resultBlock = ^(BRProvinceModel *province,
                               BRCityModel *city,
                               BRAreaModel *area) {
        weakself.addressF.text = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
    };
    [pickerView show];
}

- (void)setupDetailViewSubViews:(UIView *)detailView {
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"详细地址", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [detailView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(detailView).offset(AUTO_MARGIN(18));
    }];
    
    UITextView *textF = [[UITextView alloc] init];
    textF.delegate = self;
    [detailView addSubview:textF];
    self.textF = textF;
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(detailView.mas_trailing).inset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(detailView.mas_leading).offset(AUTO_MARGIN(91));
        make.top.mas_equalTo(detailView.mas_top).offset(AUTO_MARGIN(11));
        make.bottom.mas_equalTo(detailView.mas_bottom).inset(AUTO_MARGIN(4));
    }];
    textF.font = FONT_BOLD(15);
    
    self.placeStrL = [self createSimpleLabelWithTitle:NSLocalizedString(@"小区、门牌号等", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.1)];
    [textF addSubview:self.placeStrL];
    [self.placeStrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(textF.mas_leading).offset(2);
        make.top.mas_equalTo(textF.mas_top).offset(6);
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeStrL.hidden = NO;
    } else {
        self.placeStrL.hidden = YES;
    }
    
}

- (void)setModel:(ZCShopAddressModel *)model {
    _model = model;
    
    self.textF.text = model.address;
    self.placeStrL.hidden = YES;
    self.addressF.text = [NSString stringWithFormat:@"%@ %@ %@", checkSafeContent(model.province), checkSafeContent(model.city) ,checkSafeContent(model.region)];
    
}

@end
