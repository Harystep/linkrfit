//
//  ZCProfileManage.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/3.
//

#import "ZCProfileManage.h"

#define kGetUsetBaseInfoURL @"user/info"
#define kUpdateUsetInfoOperateURL @"user/update"
#define kCheckAppVersionURL @"version?type=ios"
#define kQueryTrainTotalDataInfoURL @"user/record/total/data"//

@implementation ZCProfileManage

+ (instancetype)shareInstance {
    static dispatch_once_t _once;
    static ZCProfileManage *_instance = nil;
    dispatch_once(&_once, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
            [_instance cleanOldData];
        }
    });
    return _instance;
}

- (void)cleanOldData {
    self.saveData = [NSMutableDictionary dictionary];
}

+ (void)updateUserInfoOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kUpdateUsetInfoOperateURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {        
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getUserBaseInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kGetUsetBaseInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        kUserStore.userData = responseObj[@"data"];
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)checkAppVersionInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kCheckAppVersionURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//
+ (void)queryTrainTotalDataInfoURL:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryTrainTotalDataInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

@end
