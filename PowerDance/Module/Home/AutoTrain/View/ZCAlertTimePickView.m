//
//  ZCAlertTimePickView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import "ZCAlertTimePickView.h"
#import "ZGPickerView.h"

@interface ZCAlertTimePickView ()<ZGPickerViewDelegate>

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *pickView;

@property (nonatomic,strong) ZGPickerView *picker;

@property (nonatomic,strong) ZGPickerView *minutePicker;

@property (nonatomic,strong) ZGPickerView *mousePicker;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *minuteArr;

@property (nonatomic,strong) NSMutableArray *mouseArr;

@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic, copy) NSString *mouseStr;
@property (nonatomic, copy) NSString *minuteStr;

@end

@implementation ZCAlertTimePickView

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
        self.valueStr = @"0";
        self.minuteStr = @"0";
        self.mouseStr = @"0";
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
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"该动作组需要重复训练吗？", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
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
    [self.pickView addSubview:self.minutePicker];
    [self.pickView addSubview:self.mousePicker];
    
    [self createSepViewLead:self.picker];
    [self createSepViewLead:self.minutePicker];
    
    UIImageView *leftIv = [[UIImageView alloc] initWithImage:kIMAGE(@"sport_arrow_left")];
    [contentView addSubview:leftIv];
    [leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mousePicker.mas_trailing);
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
    self.mouseStr = self.mouseArr[15];
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
    if (pickerView.tag == 2) {
        self.minuteStr = self.minuteArr[currentRow];
    } else if (pickerView.tag == 1) {
        self.valueStr = self.dataArr[currentRow];
    } else if (pickerView.tag == 3){
        self.mouseStr = self.mouseArr[currentRow];
    }
         
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
    if (self.close) {        
    } else {
        if ([self.mouseStr integerValue] == 0 && [self.minuteStr integerValue] == 0 && [self.valueStr integerValue] == 0) {
            [self makeToast:NSLocalizedString(@"请设置时间", nil) duration:1.5 position:CSToastPositionCenter];
            return;
        }
    }
    if (self.sureRepeatOperate) {
        NSString *content = [NSString stringWithFormat:@"%@:%@:%@", [self convertTimeStringWithContent:self.valueStr], [self convertTimeStringWithContent:self.minuteStr], [self convertTimeStringWithContent:self.mouseStr]];
        self.sureRepeatOperate(content);
    }
    [self hideAlertView];
}

- (NSString *)convertTimeStringWithContent:(NSString *)content {
    if (content.length == 1) {
        return [NSString stringWithFormat:@"0%@", content];
    } else {
        return content;
    }
}

- (void)createSepViewLead:(UIView *)view {
    UILabel *lb = [self createSimpleLabelWithTitle:@":" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self.pickView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.leading.mas_equalTo(view.mas_trailing);
    }];
}

- (void)setHourType:(NSInteger)hourType {
    _dataArr = [NSMutableArray array];
    NSInteger hours;
    if (hourType) {//12
        hours = 12;
    } else {
        hours = 24;
    }
    for (int i = 0; i < hours; i ++) {
        [_dataArr addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    self.picker.dataArr = _dataArr;
    [self.picker reloadAllComponents];
}

- (ZGPickerView *)picker {
    if (!_picker) {
        _picker = [[ZGPickerView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(140)/2.0, 0, AUTO_MARGIN(50), AUTO_MARGIN(100))];
        _picker.tag = 1;
        _picker.pvDelegate = self;
        _picker.dataArr = self.dataArr;
                
    }
    return _picker;
}

- (ZGPickerView *)mousePicker {
    if (!_mousePicker) {
        _mousePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minutePicker.frame), 0, AUTO_MARGIN(50), AUTO_MARGIN(100))];
        _mousePicker.tag = 3;
        _mousePicker.pvDelegate = self;
        _mousePicker.dataArr = self.mouseArr;
        _mousePicker.defaultSelectedRow = @[self.mouseArr[15]];
                
    }
    return _mousePicker;
}

- (ZGPickerView *)minutePicker {
    if (!_minutePicker) {
        _minutePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picker.frame), 0, AUTO_MARGIN(50), AUTO_MARGIN(100))];
        _minutePicker.tag = 2;
        _minutePicker.pvDelegate = self;
        _minutePicker.dataArr = self.minuteArr;
                
    }
    return _minutePicker;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    return _dataArr;
}

- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
        for (int i = 0; i < 61; i ++) {
            [_minuteArr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    return _minuteArr;
}

- (NSMutableArray *)mouseArr {
    if (!_mouseArr) {
        _mouseArr = [NSMutableArray array];
        for (int i = 0; i < 61; i ++) {
            [_mouseArr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    return _mouseArr;
}


@end
