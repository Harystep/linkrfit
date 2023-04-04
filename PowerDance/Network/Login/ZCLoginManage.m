//
//  ZCLoginManage.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/22.
//

#import "ZCLoginManage.h"

#define kWXAuthLoginURL @"user/wechat/login"
#define kAppleAuthLoginURL @"user/ios/login"
#define kUserBluetoothSettingURL @"user/bluetooth/setting"
#define kCheckWXAuthLoginBindInfoURL @"user/check/wechat/login?openId="
#define kLoginSendEmailCodeURL @"timer/user/send/email"
#define kLoginEmailCodeURL @"timer/user/login"


@implementation ZCLoginManage

+ (void)sendPhoneCodeOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [kLoginSendCodeURL stringByAppendingFormat:@"?phone=%@", params[@"phone"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        [CFFHud showErrorWithTitle:NSLocalizedString(@"网络连接异常", nil)];
    }];
}

+ (void)sendEmailCodeOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    //
    [[ZCNetwork shareInstance] request_getWithApi:kLoginSendEmailCodeURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        [CFFHud showErrorWithTitle:NSLocalizedString(@"网络连接异常", nil)];
    }];
}

+ (void)emailCodeLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kLoginEmailCodeURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        [CFFHud showErrorWithTitle:NSLocalizedString(@"网络连接异常", nil)];
    }];
}

+ (void)phoneCodeLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kLoginOperateURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        [CFFHud showErrorWithTitle:NSLocalizedString(@"网络连接异常", nil)];
    }];
}

+ (void)wechatAuthLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kWXAuthLoginURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)appleAuthLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kAppleAuthLoginURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        [CFFHud showErrorWithTitle:NSLocalizedString(@"连接超时", nil)];
    }];
}

+ (void)checkWXAuthLoginBindInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kCheckWXAuthLoginBindInfoURL, params[@"openId"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        [CFFHud showErrorWithTitle:NSLocalizedString(@"连接超时", nil)];
    }];
}

+ (void)getUserBluetoothSettingInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kUserBluetoothSettingURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
            
    }];
}

@end
