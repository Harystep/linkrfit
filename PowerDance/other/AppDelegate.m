//
//  AppDelegate.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/26.
//

#import "AppDelegate.h"
#import "ZCTabBarController.h"
#import "ZCLoginController.h"
#import "ZCBaseNavController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (nonatomic,assign) UIBackgroundTaskIdentifier bgTask;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [HBRouter loadConfigPlist:nil];
    [self initializationWindow];
//    NSError *setCategoryErr = nil;
//    NSError *activationErr  = nil;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
//    [[AVAudioSession sharedInstance] setActive:YES  error:&activationErr];
    sleep(1.0);
    return YES;
}

- (void)initializationWindow {
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = NSLocalizedString(@"确定", nil);
    // 初始化窗口
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    // 添加跟视图控制器
    NSLog(@"token--->%@", kUserInfo.token);
    if (kUserInfo.token.length > 0) {
        kUserInfo.status = NO;
        ZCTabBarController *tabBar = [[ZCTabBarController alloc] init];
        self.window.rootViewController  = tabBar;
        [self.window makeKeyAndVisible];
    } else {
        ZCLoginController *login = [[ZCLoginController alloc] init];
        ZCBaseNavController *nav = [[ZCBaseNavController alloc] initWithRootViewController:login];
        self.window.rootViewController  = nav;
        [self.window makeKeyAndVisible];
    }
    
    [WXApi registerApp:kWECHAT_APP_ID universalLink:@"https://www.targetsiot.com/ios/"];
}
- (void)onReq:(BaseReq*)req {}

- (void)onResp:(BaseResp*)resp {
    if ([resp isMemberOfClass:[PayResp class]]) {
        PayResp *response = (PayResp*)resp;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                // 订单支付成功
                userInfo[@"status"]  = @"200";
                userInfo[@"message"] = @"支付成功";
                
              break;
                
            default: NSLog(@"支付失败，retcode=%d",resp.errCode);
                userInfo[@"status"]  = @"405";
                
                
                if (resp.errCode == -2) {
                    userInfo[@"message"] = @"已取消交易";
                    [UIApplication.sharedApplication.keyWindow makeToast:@"已取消交易"
                                                                duration:2.0
                                                                position:CSToastPositionCenter];
                } else {
                    userInfo[@"message"] = @"支付失败";
                    [UIApplication.sharedApplication.keyWindow makeToast:@"支付失败"
                                                                duration:2.0
                                                                position:CSToastPositionCenter];
                }
              break;
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayResultNotification
//                                                            object:nil
//                                                          userInfo:userInfo];
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        switch (resp.errCode) {
                
            case WXSuccess: {
                SendAuthResp *msg = (SendAuthResp *)resp;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kAuthWxBackKey" object:checkSafeContent(msg.code)];
            } break;
            default: {
            } break;
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    NSLog(@"come here---%@", url);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                // 订单支付成功
                userInfo[@"status"]  = @"200";
                userInfo[@"message"] = @"支付成功";
                
            } else if ([resultDic[@"resultStatus"] integerValue] == 8000) {
                // 正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                userInfo[@"status"]  = @"401";
                userInfo[@"message"] = @"正在处理";
                
            } else if ([resultDic[@"resultStatus"] integerValue] == 4000) {
                // 订单支付失败
                userInfo[@"status"]  = @"400";
                userInfo[@"message"] = @"支付失败";
                [UIApplication.sharedApplication.keyWindow makeToast:@"支付失败"
                                                            duration:2.0
                                                            position:CSToastPositionCenter];
                
            } else if ([resultDic[@"resultStatus"] integerValue] == 5000) {
                // 重复请求
                userInfo[@"status"]  = @"402";
                userInfo[@"message"] = @"重复请求";
                
            } else if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                // 用户中途取消
                userInfo[@"status"]  = @"403";
                userInfo[@"message"] = @"用户取消";
                [UIApplication.sharedApplication.keyWindow makeToast:@"已取消交易"
                                                            duration:2.0
                                                            position:CSToastPositionCenter];
                
            } else if ([resultDic[@"resultStatus"] integerValue] == 6002) {
                // 网络连接出错
                userInfo[@"status"]  = @"100";
                userInfo[@"message"] = @"网络错误";
                [UIApplication.sharedApplication.keyWindow makeToast:@"网络错误请检查网络"
                                                            duration:2.0
                                                            position:CSToastPositionCenter];
                
            } else if ([resultDic[@"resultStatus"] integerValue] == 6004) {
                // 支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                userInfo[@"status"]  = @"404";
                userInfo[@"message"] = @"支付未知";
                
            } else {
                // 其它支付错误
                userInfo[@"status"]  = @"500";
                userInfo[@"message"] = @"未知错误";
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayResultNotification
//                                                                object:nil
//                                                              userInfo:userInfo];
        }];
    } else if ([url.host isEqualToString:@"oauth"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[NSNotificationCenter defaultCenter] postNotificationName:kAppDidBecomeActiveKey object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppEnterBackgroundKey object:nil];
}

@end
