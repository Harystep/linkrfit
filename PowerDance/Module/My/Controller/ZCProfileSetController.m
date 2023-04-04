//
//  CFFProfileSetController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/28.
//

#import "ZCProfileSetController.h"
#import "ZCProfileSimpleView.h"
#import "ZCChangeNickView.h"
#import "ZCDataTool.h"

@interface ZCProfileSetController ()<TZImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) ZCProfileSimpleView *simpleView;
@property (nonatomic,strong) UIImageView *icon;
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

@implementation ZCProfileSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"个人资料", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    self.weightStr = @"40";
    self.smallStr = @".0";    
    
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(15), 0, SCREEN_W - AUTO_MARGIN(15)*2, 95)];
    [headView setViewCornerRadiu:15];
    [contentView addSubview:headView];
    [self createHeaderView:headView];
    
    ZCProfileSimpleView *simpleView = [[ZCProfileSimpleView alloc] init];
    self.simpleView = simpleView;
    simpleView.backgroundColor = UIColor.whiteColor;
    [contentView addSubview:simpleView];
    [simpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(headView.mas_bottom).offset(10);
        make.height.mas_equalTo(3*50);
    }];
    [simpleView setViewCornerRadiu:15];
    
    UIView *targetView = [[UIView alloc] init];
    [contentView addSubview:targetView];
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(60));
        make.top.mas_equalTo(simpleView.mas_bottom).offset(10);
    }];
    targetView.backgroundColor = [ZCConfigColor whiteColor];
    [targetView setViewCornerRadiu:AUTO_MARGIN(10)];
    [self createTargetView:targetView];
    
    [self getUserInfo];
    
    [self getTargetListInfo];
}

- (void)tapClick {
    
    [HCRouter router:@"AddressManage" params:@{} viewController:self animated:YES block:^(id  _Nonnull value) {
        
    }];
}

- (void)getTargetListInfo {
    [ZCClassSportManage classTrainTargetListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        self.targetArr = [ZCDataTool convertEffectiveData:responseObj[@"data"]];
        [ZCDataTool saveTrainTargetInfo:self.targetArr];
    }];
}

- (void)createTargetView:(UIView *)targetView {
    
    UILabel *lb = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"地址管理", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [targetView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.leading.mas_equalTo(targetView.mas_leading).offset(15);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = kIMAGE(@"profile_simple_arrow");
    [targetView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(targetView.mas_trailing).inset(12);
        make.centerY.mas_equalTo(targetView.mas_centerY);
    }];
    
    self.targetL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:15 bold:YES color:[ZCConfigColor txtColor]];
    [targetView addSubview:self.targetL];
    [self.targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.trailing.mas_equalTo(arrowIv.mas_leading).inset(AUTO_MARGIN(8));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [targetView addGestureRecognizer:tap];
}

- (void)createHeaderView:(UIView *)headView {
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColor.whiteColor;
    [headView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(headView);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(headView.mas_top).offset(15);
    }];
    [contentView setViewCornerRadiu:15];
    
    UIImageView *icon = [[UIImageView alloc] init];    
    self.icon = icon;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(15);
        make.width.height.mas_equalTo(AUTO_MARGIN(60));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    [icon setViewCornerRadiu:AUTO_MARGIN(30)];
    [self.icon layoutIfNeeded];
    
//    UIImageView *arrow = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
//    [contentView addSubview:arrow];
//    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(contentView.mas_centerY);
//        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(12));
//    }];
    
    UILabel *lb = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"修改头像", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [headView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon.mas_centerY);
        make.leading.mas_equalTo(contentView.mas_leading).offset(15);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
    [contentView addGestureRecognizer:tap];
}

- (void)iconClick {
    TZImagePickerController *pick = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:pick animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@", photos);
    UIImage *theImage = photos[0];
    NSData *imgData = UIImageJPEGRepresentation(theImage, 0.2);
    NSString *base64string = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dic = @{@"base64":base64string};
    //[@"data:image/png;base64," stringByAppendingString:base64string]
       
    [ZCShopManage uploadPictureOperate:dic completeHandler:^(id  _Nonnull responseObj) {
        NSDictionary *dic = @{@"imgUrl":checkSafeContent(responseObj[@"data"])};
        [self saveUserInfoWithData:dic];
    }];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(void (^)(id _Nonnull))block {
    kweakself(self);
    switch ([eventName integerValue]) {
        case 0:
        {
            ZCChangeNickView *nick = [[ZCChangeNickView alloc] init];
            [nick showAlertView];
            nick.SaveNickOperate = ^(NSString * _Nonnull name) {
                [weakself saveUserInfoWithData:@{@"nickName":name}];
            };
        }
            break;
        case 1:
        {
            
            [BRStringPickerView showStringPickerWithTitle:NSLocalizedString(@"请选择性别", nil) dataSource:@[NSLocalizedString(@"男", nil), NSLocalizedString(@"女", nil)] defaultSelValue:nil resultBlock:^(id selectValue) {
                NSString *content = @"";
                if ([selectValue isEqualToString:NSLocalizedString(@"男", nil)]) {
                    content = @"0";
                } else {
                    content = @"1";
                }
                [weakself saveUserInfoWithData:@{@"sex":content}];
            }];
        }
            break;
        case 2:
        {
            [BRDatePickerView showDatePickerWithTitle:NSLocalizedString(@"请设置年龄", nil) dateType:BRDatePickerModeYMD defaultSelValue:nil resultBlock:^(NSString *selectValue) {
                NSArray *dataArr = [selectValue componentsSeparatedByString:@"-"];
                if (dataArr.count == 3) {
//                    selectValue = [NSString stringWithFormat:@"%@%@%@%@%@%@", dataArr[0], @"年", dataArr[1], @"月", dataArr[2], @"日"];
                    NSString *year = dataArr[0];
                    NSString *current = [NSString getCurrentDateWithFarmot:@"yyyy"];
                    NSInteger content = [current integerValue] - [year integerValue];
                    [weakself saveUserInfoWithData:@{@"age":@(content)}];
                }
            }];
        }
            break;
        case 3:
        {
            [BRStringPickerView showStringPickerWithTitle:NSLocalizedString(@"请选择身高(CM)", nil) dataSource:[ZCDataTool convertHeightData] defaultSelValue:nil resultBlock:^(id selectValue) {
                [weakself saveUserInfoWithData:@{@"height":selectValue}];
            }];
        }
            break;
        case 4:
        {
            self.heightArr = [ZCDataTool convertWeightData];
            [self addPickerView];
//            NSString *value = [NSString stringWithFormat:@"%@", userInfo[@"content"]];
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
        [self getUserInfo];
    }];
}

- (void)getUserInfo {
    kUserInfo;
    [ZCProfileManage getUserBaseInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.simpleView.dataDic = dataDic;
            NSDictionary *dic = dataDic[@"tag"];
            if ([ZCDataTool judgeEffectiveData:dic]) {
                if ([dataDic isKindOfClass:[NSDictionary class]]) {
                    self.targetL.text = dataDic[@"tag"][@"name"];
                }
            }
            kUserStore.userData = dataDic;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:kIMAGE(@"login_icon")];
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
