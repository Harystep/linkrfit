//
//  ZCPersonalHealthyDataController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/5.
//

#import "ZCPersonalHealthyDataController.h"

@interface ZCPersonalHealthyDataController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) UILabel *heightL;

@property (nonatomic,strong) UILabel *weightL;

@property (nonatomic,strong) UILabel *bmiL;

@property (nonatomic,strong) UIView  *weightView;
@property (nonatomic,strong) UIPickerView *weightPicker;
@property (nonatomic,strong) NSArray *heightArr;
@property (nonatomic,strong) NSArray *smallArr;
@property (nonatomic,strong) UIView *inputToolBar;
@property (nonatomic, copy) NSString *weightStr;
@property (nonatomic, copy) NSString *smallStr;
@property (nonatomic,strong) UILabel *targetL;
@property (nonatomic,strong) NSArray *targetArr;

@end

@implementation ZCPersonalHealthyDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"健康数据", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    [self createSubviewsWithTitle:NSLocalizedString(@"身高", nil) index:0];
    [self createSubviewsWithTitle:NSLocalizedString(@"体重", nil) index:1];
    [self createSubviewsWithTitle:@"BMI" index:2];
}

- (void)createSubviewsWithTitle:(NSString *)title index:(NSInteger)index {
    UIView *contentView = [[UIView alloc] init];
    contentView.tag = index;
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [self.view addSubview:contentView];
    CGFloat topMargin = index * 50;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(topMargin+AUTO_MARGIN(10));
        make.height.mas_equalTo(50);
        make.leading.trailing.mas_equalTo(self.view);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.textColor = [ZCConfigColor txtColor];
    titleL.font = FONT_BOLD(AUTO_MARGIN(14));
    titleL.numberOfLines = 0;
    titleL.lineBreakMode = NSLineBreakByCharWrapping;
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentView);
        make.leading.mas_equalTo(contentView.mas_leading).offset(15);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(60));
    }];
    titleL.text = title;
    
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = kIMAGE(@"profile_simple_arrow");
    [contentView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(12);
        make.centerY.mas_equalTo(titleL.mas_centerY);
    }];
    
    UILabel *contentL = [[UILabel alloc] init];
    contentL.textColor = [ZCConfigColor subTxtColor];
    contentL.font = FONT_BOLD(15);
    [contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL.mas_centerY);
        make.trailing.mas_equalTo(arrowIv.mas_leading).inset(AUTO_MARGIN(8));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [contentView addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(15);
        make.bottom.mas_equalTo(contentView);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    if (index == 0) {
        contentL.text = [NSString stringWithFormat:@"%@CM", checkSafeContent(self.params[@"height"])];
        self.heightL = contentL;
    } else if (index == 1) {
        contentL.text = [NSString stringWithFormat:@"%@KG", checkSafeContent(self.params[@"weight"])];
        self.weightL = contentL;
    } else {
        contentL.text = [NSString stringWithFormat:@"%@", checkSafeContent(self.params[@"bmi"])];
        self.bmiL = contentL;
        arrowIv.hidden = YES;
        lineView.hidden = YES;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [contentView addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    kweakself(self);
    switch (tap.view.tag) {
        case 0:
        {
            [BRStringPickerView showStringPickerWithTitle:NSLocalizedString(@"请选择身高(CM)", nil) dataSource:[ZCDataTool convertHeightData] defaultSelValue:nil resultBlock:^(id selectValue) {
                [weakself saveUserInfoWithData:@{@"height":selectValue}];
            }];
        }
            break;
        case 1:
        {
            self.heightArr = [ZCDataTool convertWeightData];
            [self addPickerView];
            NSString *value = @"40.0";
            NSArray *valueArr = [value componentsSeparatedByString:@"."];
            NSInteger first = [valueArr.firstObject integerValue];
            if (valueArr.count == 2) {
                NSInteger secord = [valueArr.lastObject integerValue];
                [self.weightPicker selectRow:first-40 inComponent:0 animated:YES];
                [self.weightPicker selectRow:secord inComponent:1 animated:YES];
                self.smallStr = [NSString stringWithFormat:@"%ld", secord];
            } else {
                [self.weightPicker selectRow:first-40 inComponent:0 animated:YES];
                [self.weightPicker selectRow:0 inComponent:1 animated:YES];
            }
            self.weightStr = [NSString stringWithFormat:@"%ld", first];
        }
            break;
            
        default:
            break;
    }
}

- (void)saveUserInfoWithData:(NSDictionary *)parm {
    
    [ZCProfileManage updateUserInfoOperate:parm completeHandler:^(id  _Nonnull responseObj) {
        [self queryUserBaseInfo];
    }];
}

#pragma -- mark 查询个人信息
- (void)queryUserBaseInfo {
    [ZCProfileManage getUserBaseInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"userinfo:%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.heightL.text = [NSString stringWithFormat:@"%@CM", checkSafeContent(dataDic[@"height"])];
            self.bmiL.text = [NSString stringWithFormat:@"%@", checkSafeContent(dataDic[@"bmi"])];
            self.weightL.text = [NSString stringWithFormat:@"%@KG", checkSafeContent(dataDic[@"weight"])];
        });
    }];
}

- (void)addPickerView {
    
    [self.view addSubview:self.maskBtn];
    [self.view addSubview:self.weightView];
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.weightView.frame = CGRectMake(0, SCREEN_H - 280, SCREEN_W, 280);
    }];
}

- (void)barCancelButtonClicked {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.weightView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, 280);
    } completion:^(BOOL finished) {
        self.weightView.hidden = YES;
        self.weightView = nil;
        self.maskBtn.hidden = YES;
    }];
}
- (void)maskBtnClick {
    [self barCancelButtonClicked];
}

- (void)barConfirmButtonClicked {
    NSString *content = [NSString stringWithFormat:@"%@.%@", self.weightStr, self.smallStr];
    NSLog(@"%@", content);
    [self saveUserInfoWithData:@{@"weight":content}];
    [self barCancelButtonClicked];
}

//设置每个选项显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.heightArr[row];
    }
    return self.smallArr[row];
}

//用户进行选择
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.weightStr = self.heightArr[row];
    } else {
        self.smallStr = self.smallArr[row];
    }
}

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//设置指定列包含的项数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.heightArr.count;
    }
    return self.smallArr.count;
}

- (UIView *)weightView {
    if (!_weightView) {
        _weightView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 270)];
        _weightView.backgroundColor = UIColor.whiteColor;
        [_weightView addSubview:self.inputToolBar];
        [_weightView addSubview:self.weightPicker];
        UILabel *rario = [self.view createSimpleLabelWithTitle:@"." font:30 bold:YES color:UIColor.blackColor];
        [_weightView addSubview:rario];
        [rario mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_weightView);
            make.centerY.mas_equalTo(_weightView).offset(10);
        }];
    }
    return _weightView;
}

- (UIPickerView *)weightPicker{
    if (!_weightPicker) {
        _weightPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_W, 270-44)];
        _weightPicker.delegate = self;
        _weightPicker.dataSource = self;
        _weightPicker.backgroundColor = [UIColor whiteColor];
    }
    return _weightPicker;
}

- (UIView *)inputToolBar {
    if (!_inputToolBar) {
        _inputToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44)];
        UIButton *sure = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:15 color:[ZCConfigColor txtColor]];
        [_inputToolBar addSubview:sure];
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_inputToolBar);
            make.trailing.mas_equalTo(_inputToolBar.mas_trailing).inset(AUTO_MARGIN(15));
        }];
        [sure addTarget:self action:@selector(barConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancel = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"取消", nil) font:15 color:[ZCConfigColor txtColor]];
        [_inputToolBar addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_inputToolBar);
            make.leading.mas_equalTo(_inputToolBar.mas_leading).offset(AUTO_MARGIN(15));
        }];
        
        UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"请选择体重(Kg)", nil) font:14 bold:NO color:UIColor.grayColor];
        [_inputToolBar addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_inputToolBar);
        }];
        [cancel addTarget:self action:@selector(barCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputToolBar;
}

- (NSArray *)smallArr {
    if (!_smallArr) {
        _smallArr = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];;
    }
    return _smallArr;
}

@end
