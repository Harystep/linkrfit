//
//  ZCLoginVerifyController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/9.
//

#import "ZCLoginVerifyController.h"
#import "ZCLoginAlertView.h"
#import "HWTextCodeView.h"
#import "ZCTabBarController.h"

@interface ZCLoginVerifyController ()

@property (nonatomic,strong) ZCLoginAlertView *alertView;

@property (nonatomic,strong) UIButton *mouseBtn;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) HWTextCodeView *codeView;

@end

@implementation ZCLoginVerifyController

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
    
    UILabel *subL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"验证码已经发送到您的手机", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.view addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(12));
    }];
    
    [self.view addSubview:self.mouseBtn];
    [self.mouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgIcon.mas_bottom).offset(AUTO_MARGIN(14));
        make.leading.mas_equalTo(self.view.mas_leading).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(30));
        make.width.mas_equalTo(AUTO_MARGIN(120));
    }];
    
    HWTextCodeView *codeView = [[HWTextCodeView alloc] initWithCount:6 margin:20];
    codeView.frame = CGRectMake(AUTO_MARGIN(20), AUTO_MARGIN(145)+NAV_BAR_HEIGHT, SCREEN_W - AUTO_MARGIN(40), 50);
    [self.view addSubview:codeView];
    self.codeView = codeView;
    
    [self startTimer];
    
    [self showSendedMsg:@"验证码已发送"];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"verify"]) {
        [self loginOperate:userInfo[@"code"]];
    }
}

- (void)loginOperate:(NSString *)smsCode {
    [ZCLoginManage phoneCodeLoginOperate:@{@"phone":self.params[@"phone"], @"smsCode":smsCode} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        if ([ZCDataTool judgeEffectiveData:responseObj[@"code"]]) {            
            if ([responseObj[@"code"] integerValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"token"] = responseObj[@"data"];
                    dic[@"phone"] = self.params[@"phone"];
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
                    [self.codeView setViewFirstResponse];
                });
            }
        } else {
            [self showSendedMsg:@"服务器出现异常"];
        }
    }];
}

- (void)sendPhoneCodeOperate {
    [ZCLoginManage sendPhoneCodeOperate:@{@"phone":self.params[@"phone"]} completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showSendedMsg:NSLocalizedString(@"验证码已发送", nil)];
            });
        } else {
            [self showSendedMsg:checkSafeContent(responseObj[@"subMsg"])];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.alertView.hidden = YES;
    });
}


- (void)mouseOperate {
    self.index --;
    if (self.index == 0) {
        self.index = 60;
        [self.mouseBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [self.mouseBtn setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
        self.mouseBtn.userInteractionEnabled = YES;
        [self fireTimer];
    } else {
        self.mouseBtn.userInteractionEnabled = NO;
        [self.mouseBtn setTitleColor:rgba(43, 42, 51, 0.5) forState:UIControlStateNormal];
        [self.mouseBtn setTitle:[NSString stringWithFormat:@"重新获取（%zds）", self.index] forState:UIControlStateNormal];
    }
}

- (void)mouseBtnRefresh {
    [self startTimer];
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(mouseOperate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)fireTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = @"";
    self.index = 60;
}

- (ZCLoginAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[ZCLoginAlertView alloc] init];
        _alertView.text = NSLocalizedString(@"验证码错误", nil);
    }
    return _alertView;
}

- (UIButton *)mouseBtn {
    if (!_mouseBtn) {
        _mouseBtn = [[UIButton alloc] init];
        [_mouseBtn setTitleColor:rgba(43, 42, 51, 0.5) forState:UIControlStateNormal];
        _mouseBtn.titleLabel.font = FONT_SYSTEM(14);
        [_mouseBtn setTitle:NSLocalizedString(@"重新获取（60s）", nil) forState:UIControlStateNormal];
        _mouseBtn.userInteractionEnabled = NO;
        _mouseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_mouseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_mouseBtn addTarget:self action:@selector(mouseBtnRefresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mouseBtn;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
