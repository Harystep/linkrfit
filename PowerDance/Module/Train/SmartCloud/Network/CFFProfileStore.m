//
//  CFFProfileStore.m
//  CofoFit
//
//  Created by PC-N121 on 2021/5/7.
//

#import "CFFProfileStore.h"
#import "ZCProfileManage.h"

#define kGetUsetBaseInfoURL @"user/info"
#define kUpdateUsetInfoOperateURL @"user/update"
#define kUpdateUsetTargetInfoOperateURL @""

@implementation CFFProfileStore

#pragma mark - singleton

+ (instancetype)shareInstance {
    static CFFProfileStore *_instance = nil;
    static dispatch_once_t _once;
    dispatch_once(&_once, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

#pragma mark - getter setter

- (NSMutableArray *)userDataList {
    if (!_userDataList) {
        _userDataList = [NSMutableArray array];
    }
    return _userDataList;
}

- (NSMutableDictionary *)userInfoDic {
    if (!_userInfoDic) {
        _userInfoDic = [NSMutableDictionary dictionary];
    }
    return _userInfoDic;
}

#pragma  mark - api
- (void)requestUserTargetInfo:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                    failed:(RequestCompleteFailed)failed {
    [[ZCNetwork shareInstance] request_postWithApi:kUpdateUsetTargetInfoOperateURL params:parm isNeedSVP:YES success:^(id  _Nullable responseObj) {
        success(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

- (void)updateUserInfo:(NSDictionary *)parm success:(RequestCompleteSuccess)success
                failed:(RequestCompleteFailed)failed {    
//    [[ZCNetwork shareInstance] request_postWithApi:kUpdateUsetInfoOperateURL params:parm isNeedSVP:YES success:^(id  _Nullable responseObj) {
//
//    } failed:^(id  _Nullable data) {
//
//    }];    
    [ZCProfileManage updateUserInfoOperate:parm completeHandler:^(id  _Nonnull responseObj) {
        success(responseObj);
    }];
}

@end

