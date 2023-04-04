//
//  CFFInputBirthdayCard.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFInputBirthdayCard.h"



@interface CFFInputBirthdayCard ()

@property (nonatomic,strong) NSDate *date;

@property (nonatomic,strong) UIView *containerTitle;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblTitleEng;

@property (nonatomic,strong) UIView *containerDate;
@property (nonatomic,strong) UILabel *lblYear;
@property (nonatomic,strong) UILabel *lblMonth;
@property (nonatomic,strong) UILabel *lblDay;

@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;

@property (nonatomic,strong) UITextField *invisibleTxt;

@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIToolbar *inputToolBar;



@end

@implementation CFFInputBirthdayCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kCFF_COLOR_GRAY_COMMON;
        
        [self addSubview:self.invisibleTxt];
        self.invisibleTxt.inputView = self.datePicker;
        self.invisibleTxt.inputAccessoryView = self.inputToolBar;
        
        [self addSubview:self.containerTitle];
        [self.containerTitle addSubview:self.lblTitle];
        [self.containerTitle addSubview:self.lblTitleEng];
        
        [self addSubview:self.containerDate];
        
        [self.containerDate addSubview:self.lblYear];
        [self.containerDate addSubview:self.lblMonth];
        [self.containerDate addSubview:self.lblDay];
        [self.containerDate addSubview:self.line1];
        [self.containerDate addSubview:self.line2];
        
        [self makeConstraints];
        
        [self setDate:[NSDate date]];
        
        @weakify(self);
        [self addTapGestureWithAction:^{
            @strongify(self);
            [self.invisibleTxt becomeFirstResponder];
        }];
    }
    return self;
}

- (void)makeConstraints {
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"stepOneAgeAlert", nil) font:12 bold:NO color:RGBA_COLOR(0, 0, 0, 0.5)];
    [self addSubview:titleL];
    titleL.numberOfLines = 0;
    titleL.lineBreakMode = NSLineBreakByCharWrapping;
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    [self.containerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.containerTitle);
            
    }];
    [self.lblTitleEng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.containerTitle);
        make.top.equalTo(self.lblTitle.mas_bottom).offset(2);
    }];
    
    
    [self.containerDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-22);
        make.height.equalTo(@20);
        make.centerY.equalTo(self);
    }];
    
    [self.lblYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerDate).offset(20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.containerDate);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblYear.mas_right).offset(20);
        make.height.equalTo(@20);
        make.width.equalTo(@(kCFF_SINGLE_LINE_WIDTH));
        make.centerY.equalTo(self.containerDate);
    }];
    
    [self.lblMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.mas_right).offset(20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.containerDate);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblMonth.mas_right).offset(20);
        make.height.equalTo(@20);
        make.width.equalTo(@(kCFF_SINGLE_LINE_WIDTH));
        make.centerY.equalTo(self.containerDate);
    }];
    
    [self.lblDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2.mas_right).offset(20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.containerDate);
        make.right.equalTo(self.containerDate).offset(-20);
    }];
}

- (void)barCancelButtonClicked{
    [self.invisibleTxt endEditing:YES];
}

- (void)barConfirmButtonClicked {
    [self.invisibleTxt endEditing:YES];
    NSDate *date = self.datePicker.date;
    [self setDate:date];
}

- (void)setDate:(NSDate *)date {
    _date = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"%@",dateStr);
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *yyyy = [self cff_objectAtIndex:0 data:arr];
    NSString *MM = [self cff_objectAtIndex:1 data:arr];
    NSString *dd = [self cff_objectAtIndex:2 data:arr];
    NSString *current = [NSString getCurrentDateWithFarmot:@"yyyy"];
    NSInteger age = [current integerValue] - [yyyy integerValue];
    if (age > 0) {        
        [kUserStore.saveData setValue:@(age) forKey:@"age"];
    }
    self.lblYear.text = [NSString stringWithFormat:@"%@%@",yyyy,NSLocalizedString(@"年", nil)];
    self.lblMonth.text = [NSString stringWithFormat:@"%@%@",MM,NSLocalizedString(@"月", nil)];
    self.lblDay.text = [NSString stringWithFormat:@"%@%@",dd,NSLocalizedString(@"日", nil)];
}

- (id)cff_objectAtIndex:(NSUInteger)index data:(NSArray *)dataArr{
    if (index > dataArr.count - 1) {
        return nil;
    }
    return [dataArr objectAtIndex:index];
}

#pragma mark : lazy load

- (UIView *)containerTitle {
    if (!_containerTitle) {
        _containerTitle = [[UIView alloc] init];
    }
    return _containerTitle;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.text = NSLocalizedString(@"生日", nil);
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = FONT_SYSTEM(14);
    }
    return _lblTitle;
}

- (UILabel *)lblTitleEng {
    if (!_lblTitleEng) {
        _lblTitleEng = [[UILabel alloc] init];
        _lblTitleEng.text = @"birthday";
        _lblTitleEng.textColor = [UIColor grayColor];
        _lblTitleEng.font = FONT_SYSTEM(14);
    }
    return _lblTitleEng;
}


- (UIView *)containerDate {
    if (!_containerDate) {
        _containerDate = [[UIView alloc] init];
    }
    return _containerDate;
}

- (UILabel *)lblYear {
    if (!_lblYear) {
        _lblYear = [[UILabel alloc] init];
        _lblYear.text = @"0000";
        _lblYear.textColor = [UIColor blackColor];
        _lblYear.font = FONT_SYSTEM(14);
    }
    return _lblYear;
}

- (UILabel *)lblMonth {
    if (!_lblMonth) {
        _lblMonth = [[UILabel alloc] init];
        _lblMonth.text = @"00";
        _lblMonth.textColor = [UIColor blackColor];
        _lblMonth.font = FONT_SYSTEM(14);
    }
    return _lblMonth;
}

- (UILabel *)lblDay {
    if (!_lblDay) {
        _lblDay = [[UILabel alloc] init];
        _lblDay.text = @"00";
        _lblDay.textColor = [UIColor blackColor];
        _lblDay.font = FONT_SYSTEM(14);
    }
    return _lblDay;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor grayColor];
    }
    return _line1;;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor grayColor];
    }
    return _line2;;
}

- (UITextField *)invisibleTxt {
    if (!_invisibleTxt) {
        _invisibleTxt = [[UITextField alloc] init];
    }
    return _invisibleTxt;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 0, kCFF_SCREEN_WIDTH, 180);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            
        }
        _datePicker.backgroundColor = [UIColor whiteColor];
        if ([ZCDevice currentDevice].isUsingChinese) {
            _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
        }else{
            _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        }
        
        _datePicker.maximumDate = [NSDate date];
    }
    return _datePicker;
}

- (UIToolbar *)inputToolBar {
    if (!_inputToolBar) {
        _inputToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kCFF_SCREEN_WIDTH, 44)];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(barCancelButtonClicked)];
        UIBarButtonItem *spacelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(barConfirmButtonClicked)];
        
        _inputToolBar.items = @[cancelBtn,spacelBtn,confirmBtn];
    }
    return _inputToolBar;
}

@end
