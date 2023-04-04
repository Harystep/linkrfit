//
//  ZCTimerDownSetView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/10.
//

#import "ZCTimerDownSetView.h"
#import "ZGPickerView.h"

@interface ZCTimerDownSetView ()<ZGPickerViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *pickView;

@property (nonatomic,strong) ZGPickerView *picker;

@property (nonatomic,strong) ZGPickerView *minutePicker;

@property (nonatomic,strong) ZGPickerView *mousePicker;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *minuteArr;

@property (nonatomic,strong) NSMutableArray *mouseArr;

@end

@implementation ZCTimerDownSetView


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
    
    self.pickView = [[UIView alloc] init];
    [self addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(150));
    }];
    
    [self.pickView addSubview:self.picker];
    [self.pickView addSubview:self.minutePicker];
    [self.pickView addSubview:self.mousePicker];
    
    [self createSepViewLead:self.picker];
    [self createSepViewLead:self.minutePicker];
    self.mouseStr = self.mouseArr[15];
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

- (void)sureOperate {
    if ([self.mouseStr integerValue] == 0 && [self.minuteStr integerValue] == 0 && [self.valueStr integerValue] == 0) {
        [self makeToast:NSLocalizedString(@"请设置时间", nil) duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (self.sureRepeatOperate) {
        NSString *content = [NSString stringWithFormat:@"%@:%@:%@", [self convertTimeStringWithContent:self.valueStr], [self convertTimeStringWithContent:self.minuteStr], [self convertTimeStringWithContent:self.mouseStr]];
        self.sureRepeatOperate(content);
    }

}

- (NSString *)convertTimeStringWithContent:(NSString *)content {
    if (content.length == 1) {
        return [NSString stringWithFormat:@"0%@", content];
    } else {
        return content;
    }
}

- (void)createSepViewLead:(UIView *)view {
    UILabel *lb = [self createSimpleLabelWithTitle:@":" font:40 bold:YES color:[ZCConfigColor txtColor]];
    [self.pickView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.leading.mas_equalTo(view.mas_trailing).offset(AUTO_MARGIN(-5));
    }];
}

- (ZGPickerView *)picker {
    if (!_picker) {
        _picker = [[ZGPickerView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(60), 0, (SCREEN_W - AUTO_MARGIN(120))/3.0, AUTO_MARGIN(150))];
        _picker.tag = 1;
        _picker.contentFont = 50;
        _picker.pvDelegate = self;
        _picker.dataArr = self.dataArr;
                
    }
    return _picker;
}

- (ZGPickerView *)mousePicker {
    if (!_mousePicker) {
        _mousePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minutePicker.frame), 0, (SCREEN_W - AUTO_MARGIN(120))/3.0, AUTO_MARGIN(150))];
        _mousePicker.contentFont = 50;
        _mousePicker.tag = 3;
        _mousePicker.pvDelegate = self;
        _mousePicker.dataArr = self.mouseArr;
        _mousePicker.defaultSelectedRow = @[self.mouseArr[15]];
                
    }
    return _mousePicker;
}

- (ZGPickerView *)minutePicker {
    if (!_minutePicker) {
        _minutePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picker.frame), 0, (SCREEN_W - AUTO_MARGIN(120))/3.0, AUTO_MARGIN(150))];
        _minutePicker.tag = 2;
        _minutePicker.contentFont = 50;
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
        for (int i = 0; i < 60; i ++) {
            [_minuteArr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    return _minuteArr;
}

- (NSMutableArray *)mouseArr {
    if (!_mouseArr) {
        _mouseArr = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            [_mouseArr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    return _mouseArr;
}

@end
