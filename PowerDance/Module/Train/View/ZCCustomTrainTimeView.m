//
//  ZCCustomTrainTimeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/12.
//

#import "ZCCustomTrainTimeView.h"
#import "ZGPickerView.h"

@interface ZCCustomTrainTimeView ()<ZGPickerViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *pickView;

@property (nonatomic,strong) ZGPickerView *picker;

@property (nonatomic,strong) ZGPickerView *minutePicker;

@property (nonatomic,strong) ZGPickerView *mousePicker;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *minuteArr;

@property (nonatomic,strong) NSMutableArray *mouseArr;

@end

@implementation ZCCustomTrainTimeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.valueStr = @"0";
        self.minuteStr = @"00";
        self.mouseStr = @"00";
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
        make.height.mas_equalTo(AUTO_MARGIN(142));
    }];
    
    [self.pickView addSubview:self.minutePicker];
    [self.pickView addSubview:self.mousePicker];
    
    [self createSepViewLead:self.minutePicker];
    self.mouseStr = self.mouseArr[10];
}

- (void)ZGPickerView:(ZGPickerView *)pickerView currentComponent:(NSInteger)currentComponent currentRow:(NSInteger)currentRow {
    if (pickerView.tag == 2) {
        self.minuteStr = self.minuteArr[currentRow];
    } else if (pickerView.tag == 3){
        self.mouseStr = self.mouseArr[currentRow];
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
    UILabel *lb = [self createSimpleLabelWithTitle:@":" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self.pickView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.leading.mas_equalTo(view.mas_trailing);
    }];
}

- (void)setMouseStr:(NSString *)mouseStr {
    _mouseStr = mouseStr;
    self.mousePicker.defaultSelectedRow = @[mouseStr];
}

- (void)setMinuteStr:(NSString *)minuteStr {
    _minuteStr = minuteStr;
    self.minutePicker.defaultSelectedRow = @[minuteStr];
}

- (ZGPickerView *)mousePicker {
    if (!_mousePicker) {
        _mousePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minutePicker.frame), 0, AUTO_MARGIN(50), AUTO_MARGIN(142))];
        _mousePicker.contentFont = 20;
        _mousePicker.tag = 3;
        _mousePicker.selectedTextColor = [ZCConfigColor txtColor];
        _mousePicker.normalTextColor = UIColor.grayColor;
        _mousePicker.pvDelegate = self;
        _mousePicker.dataArr = self.mouseArr;
        _mousePicker.defaultSelectedRow = @[self.mouseArr[10]];
                
    }
    return _mousePicker;
}

- (ZGPickerView *)minutePicker {
    if (!_minutePicker) {
        _minutePicker = [[ZGPickerView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(100), 0, AUTO_MARGIN(50), AUTO_MARGIN(142))];
        _minutePicker.tag = 2;
        _minutePicker.selectedTextColor = [ZCConfigColor txtColor];
        _minutePicker.normalTextColor = UIColor.grayColor;
        _minutePicker.contentFont = 20;
        _minutePicker.pvDelegate = self;
        _minutePicker.dataArr = self.minuteArr;
        _mousePicker.defaultSelectedRow = @[self.minuteArr[10]];
                
    }
    return _minutePicker;
}

- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
        for (int i = 0; i < 100; i ++) {
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
