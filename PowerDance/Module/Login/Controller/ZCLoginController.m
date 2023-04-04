//
//  ZCLoginController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "ZCLoginController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "ZCTabBarController.h"
#import "ZCLoginAlertView.h"

@interface ZCLoginController ()<UITextViewDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic,strong) UIButton *selectBtn;
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

@property (nonatomic,strong) UIView *phoneView;

@property (nonatomic,strong) UIView *emailView;

@end

@implementation ZCLoginController

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
    
    UILabel *welcomeL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"手机号登录/注册", nil) font:AUTO_MARGIN(24) bold:YES color:[ZCConfigColor whiteColor]];
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
    
    UIButton *watchBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"随便看看", nil) font:AUTO_MARGIN(12) color:[ZCConfigColor whiteColor]];
    [self.view addSubview:watchBtn];
    [watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.view.mas_top).offset(STATUS_H);
        make.height.mas_equalTo(AUTO_MARGIN(44));
    }];
    kweakself(self);
    [[watchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself watchOperate];
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
    phoneView.hidden = YES;
    self.phoneView = phoneView;
    
    UIView *emailView = [[UIView alloc] init];
    [self.view addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(subL.mas_bottom).offset(AUTO_MARGIN(45));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [emailView setViewColorAlpha:0.4 color:[ZCConfigColor whiteColor]];
    [emailView setViewCornerRadiu:AUTO_MARGIN(25)];
    emailView.hidden = YES;
    self.emailView = emailView;
    
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
        
    [self.view addSubview:self.agreementL];
    
    [self.agreementL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeView.mas_bottom).offset(AUTO_MARGIN(45));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UIButton *loginBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"登录", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(self.agreementL.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
    }];
    self.loginBtn = loginBtn;
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself phoneLoginOperate];
    }];
    
    [loginBtn layoutIfNeeded];
    [self configureLoginBtnStatus:NO];
    
    if ([ZCDevice currentDevice].isUsingChinese) {
        phoneView.hidden = NO;
        [self createPhoneViewSubviews:phoneView];
        [self createWechatLogin];
    } else {
        emailView.hidden = NO;
        [self createEmailViewSubviews:emailView];
    }
 
    RACSignal *phoneSigal = self.phoneF.rac_textSignal;
    RACSignal *passwordSigal = self.passwordF.rac_textSignal;
    [[RACSignal combineLatest:@[phoneSigal, passwordSigal]] subscribeNext:^(RACTuple * _Nullable x) {
        NSString *phone = x.first;
        NSString *password = x.second;
        if ([ZCDevice currentDevice].isUsingChinese) {
            if (phone.length == 11 && password.length >= 6 ) {
                [weakself configureLoginBtnStatus:YES];
            } else {
                [weakself configureLoginBtnStatus:NO];
            }
        } else {
            if ([self isValidateEmail:phone] && password.length >= 6 ) {
                [weakself configureLoginBtnStatus:YES];
            } else {
                [weakself configureLoginBtnStatus:NO];
            }
        }
        if (self.signTimerFlag) {
        } else {
            if ([ZCDevice currentDevice].isUsingChinese) {
                if (phone.length == 11) {
                    [weakself configureCodeBtnStatus:YES];
                } else {
                    [weakself configureCodeBtnStatus:NO];
                }
            } else {
                if ([self isValidateEmail:phone]) {
                    [weakself configureCodeBtnStatus:YES];
                } else {
                    [weakself configureCodeBtnStatus:NO];
                }
            }
        }
    }];
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma -- mark 添加手机号子控件
- (void)createEmailViewSubviews:(UIView *)targetView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"login_email")];
    [targetView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.leading.mas_equalTo(targetView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    self.phoneF = [[UITextField alloc] init];
    [targetView addSubview:self.phoneF];
    self.phoneF.font = FONT_BOLD(14);
    self.phoneF.textColor = [ZCConfigColor whiteColor];
    [self.phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.top.bottom.mas_equalTo(targetView);
        make.trailing.mas_equalTo(targetView.mas_trailing).inset(20);
    }];
    self.phoneF.textAlignment = NSTextAlignmentLeft;
    self.phoneF.placeholder = NSLocalizedString(@"请输入邮箱", nil);
    self.phoneF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phoneF.placeholder attributes:@{NSForegroundColorAttributeName:rgba(255, 255, 255, 0.4)}];
}

#pragma -- mark 添加手机号子控件
- (void)createPhoneViewSubviews:(UIView *)targetView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"logo_iphone")];
    [targetView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView.mas_centerY);
        make.leading.mas_equalTo(targetView.mas_leading).offset(AUTO_MARGIN(15));
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *titleL = [self.view createSimpleLabelWithTitle:@"+86" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor whiteColor]];
    [targetView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconIv.mas_centerY);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.width.mas_equalTo(30);
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
        make.trailing.mas_equalTo(targetView.mas_trailing).inset(20);
    }];
    self.phoneF.textAlignment = NSTextAlignmentLeft;
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
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(15);
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
        make.trailing.mas_equalTo(self.codeBtn.mas_leading).inset(20);
    }];
    self.passwordF.textAlignment = NSTextAlignmentLeft;
    self.passwordF.keyboardType = UIKeyboardTypePhonePad;
    self.passwordF.placeholder = NSLocalizedString(@"请输入验证码", nil);
    self.passwordF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordF.placeholder attributes:@{NSForegroundColorAttributeName:rgba(255, 255, 255, 0.4)}];
}
#pragma -- mark 发送验证码
- (void)sendPhoneCodeOperate {
    //
    if ([ZCDevice currentDevice].isUsingChinese) {
        [ZCLoginManage sendPhoneCodeOperate:@{@"phone":checkSafeContent(self.phoneF.text)} completeHandler:^(id  _Nonnull responseObj) {
            if ([ZCDataTool judgeEffectiveData:responseObj[@"code"]]) {
                if ([responseObj[@"code"] integerValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSendedMsg:NSLocalizedString(@"发送成功", nil)];
                        [self startTimer];
                    });
                } else {
                    [self showSendedMsg:checkSafeContent(responseObj[@"subMsg"])];
                }
            }
        }];
    } else {
        [ZCLoginManage sendEmailCodeOperate:@{@"toEmail":checkSafeContent(self.phoneF.text)} completeHandler:^(id  _Nonnull responseObj) {
            if ([ZCDataTool judgeEffectiveData:responseObj[@"code"]]) {
                if ([responseObj[@"code"] integerValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSendedMsg:NSLocalizedString(@"发送成功", nil)];
                        [self startTimer];
                    });
                } else {
                    [self showSendedMsg:checkSafeContent(responseObj[@"subMsg"])];
                }
            }
        }];
    }
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

#pragma -- mark随便看看
- (void)watchOperate {
    ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController  = tabBar;
    [win makeKeyAndVisible];
}

#pragma -- mark 登录
- (void)phoneLoginOperate {
    if ([ZCDevice currentDevice].isUsingChinese) {
        [ZCLoginManage phoneCodeLoginOperate:@{@"phone":checkSafeContent(self.phoneF.text), @"smsCode":checkSafeContent(self.passwordF.text)} completeHandler:^(id  _Nonnull responseObj) {
            NSLog(@"%@", responseObj);
            if ([ZCDataTool judgeEffectiveData:responseObj[@"code"]]) {
                if ([responseObj[@"code"] integerValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"token"] = responseObj[@"data"];
                        dic[@"phone"] = checkSafeContent(self.phoneF.text);
                        [ZCUserInfo getuserInfoWithDic:dic];
                        NSLog(@"%@", kUserInfo.token);
                        [self showSendedMsg:NSLocalizedString(@"登录成功", nil)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
                            UIWindow *win = [UIApplication sharedApplication].keyWindow;
                            win.rootViewController  = tabBar;
                            [win makeKeyAndVisible];
                        });
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSendedMsg:responseObj[@"subMsg"]];
                    });
                }
            }
        }];
    } else {        
        [ZCLoginManage emailCodeLoginOperate:@{@"email":checkSafeContent(self.phoneF.text), @"code":checkSafeContent(self.passwordF.text)} completeHandler:^(id  _Nonnull responseObj) {
            if ([ZCDataTool judgeEffectiveData:responseObj[@"code"]]) {
                if ([responseObj[@"code"] integerValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"token"] = responseObj[@"data"];
                        dic[@"phone"] = checkSafeContent(self.phoneF.text);
                        [ZCUserInfo getuserInfoWithDic:dic];
                        NSLog(@"%@", kUserInfo.token);
                        [self showSendedMsg:NSLocalizedString(@"登录成功", nil)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
                            UIWindow *win = [UIApplication sharedApplication].keyWindow;
                            win.rootViewController  = tabBar;
                            [win makeKeyAndVisible];
                        });
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSendedMsg:responseObj[@"subMsg"]];
                    });
                }
            }
        }];
    }
}

- (void)createWechatLogin {
    
    UIView *authView = [[UIView alloc] init];
    [self.view addSubview:authView];
    [authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(60));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.width.mas_equalTo(AUTO_MARGIN(150));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    UIButton *apple = [[UIButton alloc] init];
    [apple setViewCornerRadiu:AUTO_MARGIN(25)];
    apple.backgroundColor = rgba(255, 255, 255, 0.3);
    
    UIButton *wechat = [[UIButton alloc] init];
    [wechat setViewCornerRadiu:AUTO_MARGIN(25)];
    wechat.backgroundColor = rgba(255, 255, 255, 0.3);
    
    if(@available(iOS 13.0, *)) {
        self.signThirdFlag = YES;
        if ([WXApi isWXAppInstalled]) {
            [authView addSubview:wechat];
            [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(authView.mas_leading);
                make.width.height.mas_equalTo(AUTO_MARGIN(50));
            }];
            [wechat setImage:kIMAGE(@"login_wechat") forState:UIControlStateNormal];
            [wechat addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
            
            [authView addSubview:apple];
            [apple mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(authView.mas_trailing);
                make.width.height.mas_equalTo(AUTO_MARGIN(50));
            }];
            [apple setImage:kIMAGE(@"login_apple") forState:UIControlStateNormal];
            [apple addTarget:self action:@selector(appleAuthRequest) forControlEvents:UIControlEventTouchUpInside];
        } else {
            
            [authView addSubview:apple];
            [apple mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(authView);
                make.height.width.mas_equalTo(AUTO_MARGIN(50));
            }];
            [apple setImage:kIMAGE(@"login_apple") forState:UIControlStateNormal];
            [apple addTarget:self action:@selector(appleAuthRequest) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        if ([WXApi isWXAppInstalled]) {
            self.signThirdFlag = YES;
            [authView addSubview:wechat];
            [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(authView.mas_centerX);
                make.width.height.mas_equalTo(AUTO_MARGIN(50));
            }];
            [wechat setImage:kIMAGE(@"login_wechat") forState:UIControlStateNormal];
            [wechat addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
        }
        apple.hidden = YES;
    }
    if (self.signThirdFlag) {
        UILabel *thirdL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"-其他方式登录-", nil) font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor whiteColor]];
        thirdL.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:thirdL];
        [thirdL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(authView.mas_top).inset(AUTO_MARGIN(20));
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(AUTO_MARGIN(97));
        }];
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
        [self.view addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(thirdL.mas_centerY);
            make.height.mas_equalTo(1);
            make.leading.mas_equalTo(self.view.mas_leading).offset(AUTO_MARGIN(50));
            make.trailing.mas_equalTo(thirdL.mas_leading).inset(AUTO_MARGIN(10));
        }];
        
        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
        [self.view addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(thirdL.mas_centerY);
            make.height.mas_equalTo(1);
            make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(50));
            make.leading.mas_equalTo(thirdL.mas_trailing).offset(AUTO_MARGIN(10));
        }];
    }
}

-(void)sendAuthRequest
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authRespBack:) name:@"kAuthWxBackKey" object:nil];
    //构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.openID = kWECHAT_APP_ID;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}


//通过code获取access_token，openid，unionid
- (void)authRespBack:(NSNotification *)noti {
    /*
     appid    是    应用唯一标识，在微信开放平台提交应用审核通过后获得
     secret    是    应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
     code    是    填写第一步获取的code参数
     grant_type    是    填authorization_code
     */
    NSString *code = noti.object;
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWECHAT_APP_ID, kWECHAT_APP_SECRET, code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data1 = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!data1) {
            return ;
        }
        
        // 授权成功，获取token、openID字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"token、openID字典===%@",dic);
        NSString *access_token = dic[@"access_token"];
        NSString *openid= dic[@"openid"];
        //         获取微信用户信息
        [self getUserInfoWithAccessToken:access_token WithOpenid:openid];
        
    });
}

-(void)getUserInfoWithAccessToken:(NSString *)access_token WithOpenid:(NSString *)openid
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 获取用户信息失败
            if (!data) {
                return ;
            }
            // 获取用户信息字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //用户信息中没有access_token 我将其添加在字典中
            [dic setValue:access_token forKey:@"token"];
            NSLog(@"用户信息字典:===%@",dic);
            //保存改用户信息(我用单例保存)
            [ZCDataTool saveUserWechatAuthInfo:dic];
            self.userDic = dic;
            //微信返回信息后,会跳到登录页面,添加通知进行其他逻辑操作
            [self checkWechatBindInfo:dic[@"openid"]];
        });
        
    });
}

- (void)loginWechatLoginOperate:(NSDictionary *)parms {
    NSDictionary *dic = @{
        @"city": checkSafeContent(parms[@"city"]),
        @"imgUrl": checkSafeContent(parms[@"headimgurl"]),
        @"phone": checkSafeContent(parms[@"phone"]),
        @"nickName": checkSafeContent(parms[@"nickname"]),
        @"openId": checkSafeContent(parms[@"openid"]),
        @"sex": [NSString stringWithFormat:@"%@", parms[@"sex"]],
        @"unionId":checkSafeContent(parms[@"unionId"])
    };
    [ZCLoginManage wechatAuthLoginOperate:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
                temDic[@"token"] = responseObj[@"data"];
                temDic[@"phone"] = checkSafeContent(dic[@"phone"]);
                [ZCUserInfo getuserInfoWithDic:temDic];
                NSLog(@"%@", kUserInfo.token);
                ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
                UIWindow *win = [UIApplication sharedApplication].keyWindow;
                win.rootViewController  = tabBar;
                [win makeKeyAndVisible];
            });
        }
    }];
    
}

- (void)checkWechatBindInfo:(NSString *)openId {
    NSDictionary *dic = @{@"openId":checkSafeContent(openId)};
    [ZCLoginManage checkWXAuthLoginBindInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 200) {
            NSDictionary *dic = responseObj[@"data"];
            if ([dic[@"check"] integerValue] == 1) {
                [HCRouter router:@"BindPhone" params:@{@"data":self.userDic} viewController:self animated:YES];
            } else {
                NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:self.userDic];
                [temDic setValue:checkSafeContent(dic[@"user"][@"phone"]) forKey:@"phone"];
                [self loginWechatLoginOperate:temDic];
            }
        }
    }];
}

- (UITextView *)agreementL {
    if (!_agreementL) {
        _agreementL = [[UITextView alloc] init];
        _agreementL.backgroundColor = [UIColor clearColor];
        _agreementL.textColor = [ZCConfigColor whiteColor];
        _agreementL.textAlignment = NSTextAlignmentCenter;
        _agreementL.editable = NO;
        _agreementL.delegate  = self;
        _agreementL.scrollEnabled = NO;
        _agreementL.font = AUTO_SYSTEM_FONT_SIZE(14);
        NSString *tips = NSLocalizedString(@"登录即代表同意《练氪用户协议》及《隐私政策》", nil);
        _agreementL.text = tips;
        NSString *linkString1 = NSLocalizedString(@"《隐私政策》", nil);
        NSRange linkRange1 = [tips rangeOfString:linkString1];
        NSString *linkString2 = NSLocalizedString(@"《练氪用户协议》", nil);
        NSRange linkRange2 = [tips rangeOfString:linkString2];
        _agreementL.linkTextAttributes = @{};
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:tips];
        [attributeString addAttributes:@{NSForegroundColorAttributeName:[ZCConfigColor whiteColor]} range:NSMakeRange(0, tips.length)];
        [attributeString addAttributes:@{NSLinkAttributeName: k_User_PRIVACY_URL} range:linkRange1];
//        [attributeString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName:[ZCConfigColor subTxtColor]} range:linkRange1];
        [attributeString addAttributes:@{NSFontAttributeName:FONT_BOLD(14), NSForegroundColorAttributeName:[ZCConfigColor cyanColor]} range:linkRange1];
        
        [attributeString addAttributes:@{NSLinkAttributeName: k_User_Agreement_URL} range:linkRange2];
//        [attributeString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName:[ZCConfigColor subTxtColor]} range:linkRange2];
        [attributeString addAttributes:@{NSFontAttributeName:FONT_BOLD(14), NSForegroundColorAttributeName:[ZCConfigColor cyanColor]} range:linkRange2];

        _agreementL.attributedText = attributeString;
    }
    return _agreementL;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    return YES;
}

//苹果第三方登录
-(void)appleAuthRequest{
    if(@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate=self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider=self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
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

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    NSLog(@"success");
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        NSLog(@"%@_%@_%@", familyName, givenName, email);
        NSData *identityToken = appleIDCredential.identityToken;
        NSData *authorizationCode = appleIDCredential.authorizationCode;
        NSLog(@"user--->%@", user);
        // 服务器验证需要使用的参数
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];

        NSLog(@"%@\n\n%@", identityTokenStr, authorizationCodeStr);
        [self checkAppleBindInfo:user];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        //// Sign in using an existing iCloud Keychain credential.
        ASPasswordCredential *pass = authorization.credential;
        NSString *username = pass.user;
        NSString *passw = pass.password;
    }
    //这里后台需要什么就传什么给他
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return [UIApplication sharedApplication].keyWindow;
}

- (void)checkAppleBindInfo:(NSString *)openId {
    NSDictionary *dic = @{@"openId":checkSafeContent(openId)};
    [ZCLoginManage checkWXAuthLoginBindInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 200) {
            NSDictionary *dic = responseObj[@"data"];
            if ([dic[@"check"] integerValue] == 1) {
                [HCRouter router:@"BindPhone" params:@{@"data":openId, @"type":@"apple"} viewController:self animated:YES];
            } else {
                NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
                [temDic setValue:checkSafeContent(dic[@"user"][@"phone"]) forKey:@"phone"];
                [temDic setValue:checkSafeContent(openId) forKey:@"iosId"];
                [self loginAppleLoginOperate:temDic];
            }
        }
    }];
}

- (void)loginAppleLoginOperate:(NSDictionary *)dic {
    [ZCLoginManage appleAuthLoginOperate:dic completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
                temDic[@"token"] = responseObj[@"data"];
                temDic[@"phone"] = checkSafeContent(dic[@"phone"]);
                [ZCUserInfo getuserInfoWithDic:temDic];
                NSLog(@"%@", kUserInfo.token);
                ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
                UIWindow *win = [UIApplication sharedApplication].keyWindow;
                win.rootViewController  = tabBar;
                [win makeKeyAndVisible];
            });
        }
    }];
}


- (void)agreementOperate:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

- (ZCLoginAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[ZCLoginAlertView alloc] init];
        _alertView.text = NSLocalizedString(@"验证码错误", nil);
    }
    return _alertView;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:kIMAGE(@"login_tick_nor") forState:UIControlStateNormal];
        [_selectBtn setImage:kIMAGE(@"login_tick_sel") forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(agreementOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
