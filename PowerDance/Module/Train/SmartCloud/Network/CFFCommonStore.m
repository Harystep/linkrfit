//
//  CFFCommonStore.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/28.
//

#import "CFFCommonStore.h"

NSString *const kCFF_Api_User_Info_Update_url = @"user/updateUserInfo";
///手动更新体重
NSString *const kCFF_Api_Cloud_Scale_Update_Info = @"cloud/scale/update";
///保存记录
NSString *const kCFF_Api_Cloud_Scale_Update_record = @"cloud/scale/save";

NSString *const kCFF_Api_Cloud_Scale_Record_list = @"cloud/scale/list";

@implementation CFFCommonStore

+ (instancetype)shareInstance {
    static CFFCommonStore *_instance = nil;
    static dispatch_once_t _once;
    dispatch_once(&_once, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}


- (void)saveCloudWeightOperate:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                        failed:(RequestCompleteFailed)failed {
    [[ZCNetwork shareInstance] request_postWithApi:kCFF_Api_Cloud_Scale_Update_Info params:parm isNeedSVP:YES success:^(id  _Nonnull responseObj) {
            success(responseObj);
        } failed:^(id  _Nonnull data) {
            failed(data);
        }];
}

- (void)saveCloudWeightRecordOperate:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                              failed:(RequestCompleteFailed)failed {
    [[ZCNetwork shareInstance] request_postWithApi:kCFF_Api_Cloud_Scale_Update_record params:parm isNeedSVP:NO success:^(id  _Nonnull responseObj) {
            success(responseObj);
        } failed:^(id  _Nonnull data) {
            failed(data);
        }];
}
- (void)requestCloudRecordList:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                        failed:(RequestCompleteFailed)failed {
    [[ZCNetwork shareInstance] request_getWithApi:kCFF_Api_Cloud_Scale_Record_list params:parm isNeedSVP:NO success:^(id  _Nonnull responseObj) {
            success(responseObj);
        } failed:^(id  _Nonnull data) {
            failed(data);
        }];
}

@end
