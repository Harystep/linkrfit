//
//  ZCPowerStationSetView.m
//  PowerDance
//
//  Created by oneStep on 2023/5/9.
//

#import "ZCPowerStationSetView.h"
#import "ZGPickerView.h"

@interface ZCPowerStationSetView ()<ZGPickerViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *pickView;

@property (nonatomic,strong) ZGPickerView *picker;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *valueStr;

@end

@implementation ZCPowerStationSetView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = rgba(0, 0, 0, 0.4);
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [_maskBtn addTarget:self action:@selector(maskBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    contentView.frame = CGRectMake((SCREEN_W - AUTO_MARGIN(291))/2.0, AUTO_MARGIN(230), AUTO_MARGIN(291), AUTO_MARGIN(240));
    self.contentView = contentView;
    [self addSubview:self.contentView];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(contentView).offset(AUTO_MARGIN(20));
    }];
    
    self.pickView = [[UIView alloc] init];
    [contentView addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    
    [self.pickView addSubview:self.picker];
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.pickView);
        make.bottom.top.mas_equalTo(self.pickView);
        make.width.mas_equalTo(AUTO_MARGIN(60));
    }];
    
    UIImageView *leftIv = [[UIImageView alloc] initWithImage:kIMAGE(@"sport_arrow_left")];
    [contentView addSubview:leftIv];
    [leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.picker.mas_trailing);
        make.centerY.mas_equalTo(self.picker);
    }];

    
    UIImageView *rightIv = [[UIImageView alloc] initWithImage:kIMAGE(@"sport_arrow_right")];
    [contentView addSubview:rightIv];
    [rightIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.picker.mas_leading);
        make.centerY.mas_equalTo(self.picker);
    }];
    
    UIButton *sure = [self createSimpleButtonWithTitle:NSLocalizedString(@"完成", nil) font:14 color:[ZCConfigColor whiteColor]];
    sure.backgroundColor = [ZCConfigColor txtColor];
    [contentView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(27));
        make.width.mas_equalTo(AUTO_MARGIN(187));
        make.height.mas_equalTo(AUTO_MARGIN(42));
    }];
    [sure addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)ZGPickerView:(ZGPickerView *)pickerView currentComponent:(NSInteger)currentComponent currentRow:(NSInteger)currentRow {
    self.valueStr = self.dataArr[currentRow];
}

- (void)maskBtnClick {
    [self hideAlertView];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    [self removeFromSuperview];
}

- (void)sureOperate {
    if (self.sureRepeatOperate) {
        self.sureRepeatOperate(self.valueStr);
    }
    [self hideAlertView];
}

- (void)setConfigureArr:(NSArray *)configureArr {
    _configureArr = configureArr;
    self.dataArr = [NSMutableArray arrayWithArray:configureArr];
    _picker.dataArr = self.dataArr;
    self.valueStr = self.dataArr[0];
    _picker.defaultSelectedRow = @[@"0"];
}

- (void)setDefValue:(NSString *)defValue {
    _defValue = defValue;
    NSInteger num = [self.dataArr[0] integerValue];
    NSInteger targetNum = [defValue integerValue];
    NSString *targetStr = [NSString stringWithFormat:@"%tu", targetNum-num];
    _picker.defaultSelectedRow = @[targetStr];
    self.valueStr = targetStr;
}

- (ZGPickerView *)picker {
    if (!_picker) {
        _picker = [[ZGPickerView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(231)/2.0, 0, AUTO_MARGIN(60), AUTO_MARGIN(100))];
        _picker.pvDelegate = self;
                
    }
    return _picker;
}

@end
