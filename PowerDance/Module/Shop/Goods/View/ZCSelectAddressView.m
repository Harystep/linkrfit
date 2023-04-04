//
//  ZCSelectAddressView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCSelectAddressView.h"

@interface ZCSelectAddressView ()

@end

@implementation ZCSelectAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.bottom.mas_equalTo(self);
    }];
    [contentView setViewBorderWithColor:1 color:rgba(43, 42, 51, 0.1)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTargetView)];
    [self addGestureRecognizer:tap];
    
    [self createSubViewsOnTargetView:contentView];
}

- (void)createSubViewsOnTargetView:(UIView *)targetView {
    
    UIImageView *downIv = [[UIImageView alloc] initWithImage:kIMAGE(@"select_down")];
    [targetView addSubview:downIv];
    [downIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView);
        make.trailing.mas_equalTo(targetView.mas_trailing).inset(AUTO_MARGIN(10));
        make.width.height.mas_equalTo(14);
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"省份", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [targetView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView);
        make.leading.mas_equalTo(targetView.mas_leading).inset(AUTO_MARGIN(12));
    }];
    
    self.contentF = [[UITextField alloc] init];
    self.contentF.font = FONT_BOLD(14);
    [targetView addSubview:self.contentF];
    self.contentF.enabled = NO;
    self.contentF.textAlignment = NSTextAlignmentRight;
    [self.contentF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView);
        make.trailing.mas_equalTo(downIv.mas_leading).inset(AUTO_MARGIN(8));
        make.leading.mas_equalTo(self.titleL.mas_trailing).inset(AUTO_MARGIN(8));
    }];
    
}

- (void)clickTargetView {
    BRAddressPickerMode mode = BRAddressPickerModeArea;
    kweakself(self);
    NSArray *dataArr = @[];
    if (self.addressMode == AddressTypeProvinceMode) {
        mode = BRAddressPickerModeProvince;
        BRAddressPickerView *pickerView = [[BRAddressPickerView alloc]
                                           initWithPickerMode:mode];
        pickerView.dataSourceArr = [ZCDataTool cityData];
        pickerView.resultBlock = ^(BRProvinceModel *province,
                                   BRCityModel *city,
                                   BRAreaModel *area) {
            if (weakself.contentF.text != nil && ![weakself.contentF.text isEqualToString:province.name]) {
                if (![weakself.provinceName isEqualToString:province.name]) {
                    if (weakself.changeProvinceBlock) {
                        weakself.changeProvinceBlock(province.name);
                    }
                }
            }
            if (weakself.saveProvinceBlock) {
                weakself.saveProvinceBlock(province.name);
            }
            weakself.contentF.text = province.name;
        };
        [pickerView show];
    } else {
        if (self.provinceName.length == 0 && self.model == nil) {
            [[ZCHud sharedInstance] showTextMsg:NSLocalizedString(@"请先选择省份", nil) dispaly:2.0 position:ZCHudPositionTypeTop];
            return;
        }
        dataArr = @[checkSafeContent(self.provinceName), @"", @""];
        BRAddressPickerView *pickerView = [[BRAddressPickerView alloc]
                                           initWithPickerMode:mode];
        pickerView.dataSourceArr = [ZCDataTool cityData];
        pickerView.defaultSelectedArr = dataArr;
        pickerView.resultBlock = ^(BRProvinceModel *province,
                                   BRCityModel *city,
                                   BRAreaModel *area) {
            
            if (![weakself.provinceName isEqualToString:province.name]) {
                if (weakself.changeProvinceBlock) {
                    weakself.changeProvinceBlock(province.name);
                }
            }
            weakself.contentF.text = [NSString stringWithFormat:@"%@ %@", city.name, area.name];
        };
        [pickerView show];
    }
    
}

- (void)setAddressMode:(AddressTypeMode)addressMode {
    _addressMode = addressMode;
    if (addressMode == AddressTypeProvinceMode) {
        self.titleL.text = NSLocalizedString(@"省份", nil);
        self.contentF.placeholder = NSLocalizedString(@"请选择省份", nil);
    } else if (addressMode == AddressTypeCityMode) {
        self.titleL.text = NSLocalizedString(@"市区", nil);
        self.contentF.placeholder = NSLocalizedString(@"请选择市区", nil);
    }
}

- (void)setModel:(ZCShopAddressModel *)model {
    _model = model;
    if (self.addressMode == AddressTypeProvinceMode) {
        self.titleL.text = model.province;
        self.contentF.placeholder = NSLocalizedString(@"请选择省份", nil);
        self.contentF.text = model.province;
        self.provinceName = model.province;
    } else {
        self.titleL.text = NSLocalizedString(@"市区", nil);
        self.contentF.placeholder = NSLocalizedString(@"请选择市区", nil);
        self.contentF.text = [NSString stringWithFormat:@"%@ %@", model.city, model.region];
    }
}

@end
