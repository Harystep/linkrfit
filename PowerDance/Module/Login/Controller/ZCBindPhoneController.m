//
//  ZCBindPhoneController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/10.
//

#import "ZCBindPhoneController.h"
#import "ZCTabBarController.h"
#import "ZCLoginAlertView.h"

@interface ZCBindPhoneController ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *agreementL;
@property (nonatomic,strong) ZCLoginAlertView *alertView;
@property (nonatomic,strong) NSDictionary *userDic;
@property (nonatomic,assign) NSInteger signThirdFlag;
@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) UITextField *phoneF;
@property (nonatomic,strong) UITextField *passwordF;

@property (nonatomic,strong) UIButton *codeBtn;

@property (nonatomic,assign) NSInteger signTimerFlag;//标记正在倒计时

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger mouse;//

@end

@implementation ZCBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mouse = 60;
    
    UIImageView *bgIcon = [[UIImageView alloc] init];
    bgIcon.image = kIMAGE(@"logo_bg");
    [bgIcon setViewContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:bgIcon];
    [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIButton *maskBtn = [[UIButton alloc] init];
    [self.view addSubview:maskBtn];
    [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    maskBtn.backgroundColor = [ZCConfigColor txtColor];
    maskBtn.alpha = 0.6;
    
    UILabel *welcomeL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"绑定手机号", nil) font:AUTO_MARGIN(24) bold:YES color:[ZCConfigColor whiteColor]];
    [self.view addSubview:welcomeL];
    [welcomeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_BAR_HEIGHT+AUTO_MARGIN(30));
    }];
    
    UILabel *subL = [self .view createSimpleLabelWithTitle:NSLocalizedString(@"练氪-家庭智能健身专家", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor whiteColor]];
    [self.view addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(welcomeL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    UIView *phoneView = [[UIView alloc] init];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(subL.mas_bottom).offset(AUTO_MARGIN(45));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [phoneView setViewColorAlpha:0.4 color:[ZCConfigColor whiteColor]];
    [phoneView setViewCornerRadiu:AUTO_MARGIN(25)];
    [self createPhoneViewSubviews:phoneView];
    
    UIView *codeView = [[UIView alloc] init];
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(phoneView.mas_bottom).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [codeView setViewColorAlpha:0.4 color:[ZCConfigColor whiteColor]];
    [codeView setViewCornerRadiu:AUTO_MARGIN(25)];
    [self createCodeViewSubviews:codeView];
            
    UIButton *loginBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"确认绑定", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(codeView.mas_bottom).offset(AUTO_MARGIN(40));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
    }];
    self.loginBtn = loginBtn;
    kweakself(self);
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself phoneLoginOperate];
    }];
    
    [loginBtn layoutIfNeeded];
    [self configureLoginBtnStatus:NO];
 
    RACSignal *phoneSigal = self.phoneF.rac_textSignal;
    RACSignal *passwordSigal = self.passwordF.rac_textSignal;
    [[RACSignal combineLatest:@[phoneSigal, passwordSigal]] subscribeNext:^(RACTuple * _Nullable x) {
        NSString *phone = x.first;
        NSString *password = x.second;
        if (phone.length == 11 && password.length >= 6 ) {
            [weakself configureLoginBtnStatus:YES];
        } else {
            [weakself configureLoginBtnStatus:NO];
        }
        if (self.signTimerFlag) {
        } else {
            if (phone.length == 11) {
                [weakself configureCodeBtnStatus:YES];
            } else {
                [weakself configureCodeBtnStatus:NO];
            }
        }
    }];
    
    self.showNavStatus = YES;
    self.backStyle = UINavBackButtonColorStyleWhite;
}

#pragma -- mark 添加手机号子控件
- (void)createPhoneViewSubviews:(UIView *)targetView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"logo_iphone")];
    [targetView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.leading.mas_equalTo(targetView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    UILabel *titleL = [self.view createSimpleLabelWithTitle:@"+86" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor whiteColor]];
    [targetView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconIv.mas_centerY);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [targetView addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor whiteColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.leading.mas_equalTo(titleL.mas_trailing).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(35));
    }];
    
    self.phoneF = [[UITextField alloc] init];
    [targetView addSubview:self.phoneF];
    self.phoneF.font = FONT_BOLD(14);
    self.phoneF.textColor = [ZCConfigColor whiteColor];
    [self.phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lineView.mas_trailing).offset(AUTO_MARGIN(10));
        make.top.bottom.mas_equalTo(targetView);
        make.width.mas_equalTo(AUTO_MARGIN(150));
    }];
    self.phoneF.keyboardType = UIKeyboardTypePhonePad;
    self.phoneF.placeholder = NSLocalizedString(@"请输入11位手机号码", nil);
    self.phoneF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phoneF.placeholder attributes:@{NSForegroundColorAttributeName:rgba(255, 255, 255, 0.4)}];
}
#pragma -- mark 添加验证码视图子控件
- (void)createCodeViewSubviews:(UIView *)targetView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"logo_code")];
    [targetView addSubview:iconIv];
    iconIv.contentMode = UIViewContentModeCenter;
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.leading.mas_equalTo(targetView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    self.codeBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"获取验证码", nil) font:AUTO_MARGIN(12) color:[ZCConfigColor subTxtColor]];
    [targetView addSubview:self.codeBtn];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(84));
        make.height.mas_equalTo(AUTO_MARGIN(34));
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.trailing.mas_equalTo(targetView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    [self.codeBtn setViewCornerRadiu:AUTO_MARGIN(17)];
    [self configureCodeBtnStatus:NO];
    kweakself(self);
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself sendPhoneCodeOperate];
    }];
    
    self.passwordF = [[UITextField alloc] init];
    [targetView addSubview:self.passwordF];
    self.passwordF.font = FONT_BOLD(14);
    self.passwordF.textColor = [ZCConfigColor whiteColor];
    [self.passwordF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.top.bottom.mas_equalTo(targetView);
        make.width.mas_equalTo(AUTO_MARGIN(80));
    }];
    self.passwordF.keyboardType = UIKeyboardTypePhonePad;
    self.passwordF.placeholder = NSLocalizedString(@"请输入验证码", nil);
    self.passwordF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordF.placeholder attributes:@{NSForegroundColorAttributeName:rgba(255, 255, 255, 0.4)}];
}
#pragma -- mark 发送验证码
- (void)sendPhoneCodeOperate {
    [ZCLoginManage sendPhoneCodeOperate:@{@"phone":checkSafeContent(self.phoneF.text)} completeHandler:^(id  _Nonnull responseObj) {
        if ([ZCDataTool judgeEffectiveData:responseObj[@"code"]]) {
            if ([responseObj[@"code"] integerValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startTimer];
                });
            } else {
                [self showSendedMsg:checkSafeContent(responseObj[@"subMsg"])];
            }
        }
    }];
}
#pragma -- mark 60s倒计时时间
- (void)mouseOperate {
    self.mouse --;
    self.signTimerFlag = YES;
    if (self.mouse == 0) {
        self.signTimerFlag = NO;
        self.mouse = 60;
        [self configureCodeBtnStatus:YES];
        [self.codeBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [self fireTimer];
    } else {
        self.codeBtn.userInteractionEnabled = NO;
        [self.codeBtn setTitleColor:[ZCConfigColor cyanColor] forState:UIControlStateNormal];
        self.codeBtn.backgroundColor = [ZCConfigColor whiteColor];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%zds%@", self.mouse, NSLocalizedString(@"后获取", nil)] forState:UIControlStateNormal];
    }
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(mouseOperate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)fireTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma -- mark 配置登录按钮状态
- (void)configureLoginBtnStatus:(BOOL)status {
    if (status) {
        self.loginBtn.alpha = 1.0;
    } else {
        self.loginBtn.alpha = 0.4;
    }
    [self.loginBtn configureLeftToRightViewColorGradient:self.loginBtn width:SCREEN_W-AUTO_MARGIN(20)*2 height:AUTO_MARGIN(50) one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:AUTO_MARGIN(25)];
    self.loginBtn.userInteractionEnabled = status;
}

- (void)configureCodeBtnStatus:(BOOL)status {
    if (status) {
        self.codeBtn.backgroundColor = [ZCConfigColor whiteColor];
        [self.codeBtn setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
    } else {
        self.codeBtn.backgroundColor = rgba(255, 255, 255, 0.4);
        [self.codeBtn setTitleColor:[ZCConfigColor subTxtColor] forState:UIControlStateNormal];
    }
    self.codeBtn.userInteractionEnabled = status;
}

#pragma -- mark 登录
- (void)phoneLoginOperate {
    
    if ([checkSafeContent(self.params[@"type"]) isEqualToString:@"apple"]) {
            NSDictionary *dic = @{
                @"phone":checkSafeContent(self.phoneF.text),
                @"iosId":checkSafeContent(self.params[@"data"]),
                @"smsCode":checkSafeContent(self.passwordF.text)
            };
            [ZCLoginManage appleAuthLoginOperate:dic completeHandler:^(id  _Nonnull responseObj) {
                NSLog(@"%@", responseObj);
                if ([responseObj[@"code"] integerValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"token"] = responseObj[@"data"];
                        dic[@"phone"] = self.phoneF.text;
                        [ZCUserInfo getuserInfoWithDic:dic];
                        NSLog(@"%@", kUserInfo.token);
                        ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
                        UIWindow *win = [UIApplication sharedApplication].keyWindow;
                        win.rootViewController  = tabBar;
                        [win makeKeyAndVisible];
                    });
                }
            }];
        } else {
            NSDictionary *parms = self.params[@"data"];
            NSDictionary *dic = @{
                @"city": checkSafeContent(parms[@"city"]),
                @"imgUrl": checkSafeContent(parms[@"headimgurl"]),
                @"phone": checkSafeContent(self.phoneF.text),
                @"nickName": checkSafeContent(parms[@"nickname"]),
                @"openId": checkSafeContent(parms[@"openid"]),
                @"sex": [NSString stringWithFormat:@"%@", parms[@"sex"]],
                @"unionId":checkSafeContent(parms[@"unionId"]),
                @"smsCode":checkSafeContent(self.passwordF.text)
            };
            [ZCLoginManage wechatAuthLoginOperate:dic completeHandler:^(id  _Nonnull responseObj) {
                NSLog(@"%@", responseObj);
                if ([responseObj[@"code"] integerValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"token"] = responseObj[@"data"];
                        dic[@"phone"] = self.phoneF.text;
                        [ZCUserInfo getuserInfoWithDic:dic];
                        NSLog(@"%@", kUserInfo.token);
                        ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
                        UIWindow *win = [UIApplication sharedApplication].keyWindow;
                        win.rootViewController  = tabBar;
                        [win makeKeyAndVisible];
                    });
                }
            }];
        }
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



@end
