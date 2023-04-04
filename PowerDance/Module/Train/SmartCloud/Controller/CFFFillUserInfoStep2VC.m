//
//  CFFFillUserInfoStep2VC.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/26.
//

#import "CFFFillUserInfoStep2VC.h"
#import "CFFFillUserInfoViewStep2.h"

@interface CFFFillUserInfoStep2VC ()

@property (nonatomic,assign) BOOL isFromProfile;

@property (nonatomic,strong) CFFFillUserInfoViewStep2 *stepView2;

@property (nonatomic,strong) UIButton *btnLeft;

@end


@implementation CFFFillUserInfoStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNavStatus = YES;
    self.backStyle = UINavBackButtonColorStyleWhite;
    self.lblMsg.text = NSLocalizedString(@"体重目标", nil);
    self.lblSubMsg.text = NSLocalizedString(@"填写得越详细越能精准地了解自己的身体哦", nil);
  
    [self createSubviews];
    
    [self.btnBottom setTitle:NSLocalizedString(@"设置完成", nil) forState:UIControlStateNormal];
}

#pragma maek - funcs

- (void)createSubviews {
    [self.view addSubview:self.stepView2];
    self.stepView2.backgroundColor = [ZCConfigColor bgColor];
    [self.stepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kCFF_FILL_USER_INFO_TOP_HEIGHT);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.btnBottom];
    kweakself(self);
    [[self.btnBottom rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself jumpFinishOperate];
    }];
}

#pragma -- mark 跳转下一步
- (void)jumpFinishOperate {
    NSString *weight = kUserStore.saveData[@"targetWeight"];
    if ([weight integerValue] > 0) {
        [ZCProfileManage updateUserInfoOperate:@{@"targetWeight":weight} completeHandler:^(id  _Nonnull responseObj) {
            [HCRouter router:@"SmartCloud" params:@{@"back":@"1"} viewController:self animated:YES];
            [ZCDataTool signHasInputUserInfo:YES];
        }];
    } else {
        [self.view makeToast:NSLocalizedString(@"请设置目标体重", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

#pragma mark - lazylaod

- (CFFFillUserInfoViewStep2 *)stepView2 {
    if (!_stepView2) {
        _stepView2 = [[CFFFillUserInfoViewStep2 alloc] init];
    }
    return _stepView2;
}

- (UIButton *)btnLeft{
    if (!_btnLeft) {
        _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLeft setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
        kweakself(self);
        [[_btnLeft rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _btnLeft;
}

@end
