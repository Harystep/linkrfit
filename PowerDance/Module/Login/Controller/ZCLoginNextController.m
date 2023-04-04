//
//  ZCLoginNextController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/9.
//

#import "ZCLoginNextController.h"
#import "ZCLoginAlertView.h"

@interface ZCLoginNextController ()

@property (nonatomic,strong) UITextField *phoneF;

@property (nonatomic,strong) ZCLoginAlertView *alertView;

@end

@implementation ZCLoginNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    UIImageView *bgIcon = [[UIImageView alloc] initWithImage:kIMAGE(@"login_next_bg")];
    [self.view addSubview:bgIcon];
    bgIcon.alpha = 0.85;
    [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.view);
        make.width.mas_equalTo(AUTO_MARGIN(252));
        make.height.mas_equalTo(AUTO_MARGIN(200)+NAV_BAR_HEIGHT);
    }];
    
    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"登录/注册 更精彩", nil) font:AUTO_MARGIN(20) bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    UILabel *subL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"未注册手机验证后自动登录", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.view addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(12));
    }];
    
    UIView *sepView = [[UIView alloc] init];
    [self.view addSubview:sepView];
    sepView.backgroundColor = rgba(43, 42, 51, 0.1);
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(1));
        make.top.mas_equalTo(subL.mas_bottom).offset(AUTO_MARGIN(105));
    }];
    
    self.phoneF = [[UITextField alloc] init];
    [self.view addSubview:self.phoneF];
    self.phoneF.font = FONT_BOLD(14);
    self.phoneF.textColor = [ZCConfigColor txtColor];
    [self.phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(22));
        make.bottom.mas_equalTo(sepView.mas_top).inset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    self.phoneF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneF.placeholder = NSLocalizedString(@"请输入手机号", nil);
    [self.phoneF becomeFirstResponder];
    
    ZCSimpleButton *phoneLogin = [[ZCSimpleButton alloc] init];
    [self.view addSubview:phoneLogin];
    [phoneLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgIcon.mas_bottom).offset(AUTO_MARGIN(25));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(56));
    }];
    phoneLogin.backgroundColor = kColorHex(@"#2B2A33");
    [phoneLogin setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    phoneLogin.titleLabel.font = AUTO_SYSTEM_FONT_SIZE(16);
    [phoneLogin addTarget:self action:@selector(sendPhoneCodeOperate) forControlEvents:UIControlEventTouchUpInside];
    [phoneLogin setViewCornerRadiu:AUTO_MARGIN(28)];
}

- (void)sendPhoneCodeOperate {
    [self.view endEditing:YES];
    if (self.phoneF.text.length != 11) {
        NSString *content = @"";
        if (self.phoneF.text.length == 0) {
            content = NSLocalizedString(@"请输入手机号", nil);
        } else {
            content = NSLocalizedString(@"手机号有误", nil);
        }
        [self showSendedMsg:content];
        return;
    }
    [ZCLoginManage sendPhoneCodeOperate:@{@"phone":self.phoneF.text} completeHandler:^(id  _Nonnull responseObj) {
        if ([ZCDataTool judgeEffectiveData:responseObj[@"code"]]) {
            if ([responseObj[@"code"] integerValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HCRouter router:@"LoginVerify" params:@{@"phone":checkSafeContent(self.phoneF.text)} viewController:self animated:YES];
                });
            } else {
                [self showSendedMsg:checkSafeContent(responseObj[@"subMsg"])];
            }
        } else {
            [self showSendedMsg:@"服务器出现异常"];
        }

    }];
}

- (void)showSendedMsg:(NSString *)content {
    [self.view addSubview:self.alertView];
    self.alertView.hidden = NO;
    if (content != nil) {
        self.alertView.text = content;
    } else {
        self.alertView.text = NSLocalizedString(@"发送成功", nil);
    }
    self.alertView.alertL.textColor = UIColor.whiteColor;
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(44);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.alertView.hidden = YES;
    });
}

- (ZCLoginAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[ZCLoginAlertView alloc] init];
        _alertView.text = NSLocalizedString(@"验证码错误", nil);
    }
    return _alertView;
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = @"";
    
}

@end
