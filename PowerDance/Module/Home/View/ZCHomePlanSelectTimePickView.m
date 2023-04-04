//
//  ZCHomePlanSelectTimePickView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/30.
//

#import "ZCHomePlanSelectTimePickView.h"
#import "ZGPickerView.h"

@interface ZCHomePlanSelectTimePickView ()<ZGPickerViewDelegate>

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *pickView;

@property (nonatomic,strong) ZGPickerView *picker;

@property (nonatomic,strong) ZGPickerView *minutePicker;

@property (nonatomic,strong) ZGPickerView *mousePicker;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *minuteArr;

@property (nonatomic,strong) NSMutableArray *mouseArr;

@end

@implementation ZCHomePlanSelectTimePickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
              
    self.pickView = [[UIView alloc] init];
    [self addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.pickView addSubview:self.picker];
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(self.pickView.mas_leading).offset(AUTO_MARGIN(45));
        make.width.mas_equalTo(AUTO_MARGIN(90));
    }];
    
    [self.pickView addSubview:self.minutePicker];
    [self.minutePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.pickView.mas_centerX);
        make.width.mas_equalTo(AUTO_MARGIN(50));
    }];
    [self.pickView addSubview:self.mousePicker];
    [self.mousePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(self.pickView.mas_trailing).inset(AUTO_MARGIN(66));
        make.width.mas_equalTo(AUTO_MARGIN(50));
    }];
       
    self.valueStr = self.dataArr[40];
    self.minuteStr = self.minuteArr[0];
    self.mouseStr = self.mouseArr[0];
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

- (ZGPickerView *)picker {
    if (!_picker) {
        _picker = [[ZGPickerView alloc] initWithFrame:CGRectMake(0, 0, AUTO_MARGIN(90), AUTO_MARGIN(109))];
        _picker.tag = 1;
        _picker.pvDelegate = self;
        _picker.dataArr = self.dataArr;
        _picker.selectedTextColor = rgba(138, 205, 215, 1);
        _picker.contentFont = 19;
        _picker.defaultSelectedRow = @[@(40)];
    }
    return _picker;
}

- (ZGPickerView *)mousePicker {
    if (!_mousePicker) {
        _mousePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(0, 0, AUTO_MARGIN(60), AUTO_MARGIN(109))];
        _mousePicker.tag = 3;
        _mousePicker.pvDelegate = self;
        _mousePicker.dataArr = self.mouseArr;        
        _mousePicker.selectedTextColor = rgba(138, 205, 215, 1);
        _mousePicker.contentFont = 19;
        
    }
    return _mousePicker;
}

- (ZGPickerView *)minutePicker {
    if (!_minutePicker) {
        _minutePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(0, 0, AUTO_MARGIN(60), AUTO_MARGIN(109))];
        _minutePicker.tag = 2;
        _minutePicker.pvDelegate = self;
        _minutePicker.dataArr = self.minuteArr;
        _minutePicker.selectedTextColor = rgba(138, 205, 215, 1);
        _minutePicker.contentFont = 19;
    }
    return _minutePicker;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (int i = 1950; i < 2023; i ++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%d%@", i, NSLocalizedString(@"age_年", nil)]];
        }
    }
    return _dataArr;
}

- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
        for (int i = 1; i < 13; i ++) {
            [_minuteArr addObject:[NSString stringWithFormat:@"%02d%@", i, NSLocalizedString(@"age_月", nil)]];
        }
    }
    return _minuteArr;
}

- (NSMutableArray *)mouseArr {
    if (!_mouseArr) {
        _mouseArr = [NSMutableArray array];
        for (int i = 1; i < 31; i ++) {
            [_mouseArr addObject:[NSString stringWithFormat:@"%02d%@", i, NSLocalizedString(@"age_日", nil)]];
        }
    }
    return _mouseArr;
}


@end
