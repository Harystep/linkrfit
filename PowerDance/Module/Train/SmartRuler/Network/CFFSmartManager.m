//
//  CFFSmartManager.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/9.
//

#import "CFFSmartManager.h"

NSString *const kCFF_Api_Smart_Device_list = @"device/list";

NSString *const kCFF_Api_User_Device_Binding     = @"user/device/binding";

//保存尺子记录
NSString *const kCFF_Api_Ruler_Data_Record_save = @"rules/save";

NSString *const kCFF_Api_Ruler_Data_Record_list = @"ruler/record/list";

@implementation CFFSmartManager

+ (void)queryDeviceListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kCFF_Api_Smart_Device_list params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)saveRulerRecordInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kCFF_Api_Ruler_Data_Record_save params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryRulerRecordInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kCFF_Api_Ruler_Data_Record_list params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)bindDeviceOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kCFF_Api_User_Device_Binding params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

@end
