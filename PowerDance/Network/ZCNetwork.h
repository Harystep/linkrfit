//
//  ZCNetwork.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import <Foundation/Foundation.h>
#import "ZCLoginManage.h"
#import "ZCTrainManage.h"
#import "ZCShopManage.h"
#import "ZCClassSportManage.h"
#import "CFFSmartManager.h"
#import "CFFCommonStore.h"
#import "CFFProfileStore.h"

//错误代码示例
typedef NS_ENUM(NSUInteger, CFFApiReponseResultCode) {
    CFFApiErrorCode_Default     = 0,//
    CFFApiErrorCode_Success = 200,//成功
    CFFApiErrorCode_Token_Expired = 401,//token过期，安全验证不通过
};

typedef void(^CompleteHandler)(id _Nullable responseObj);
typedef void(^FaildureHandler)(id _Nullable data);


NS_ASSUME_NONNULL_BEGIN

@interface ZCNetwork : NSObject

+ (instancetype)shareInstance;

- (void)request_getWithApi:(NSString *)api
                    params:(nullable id)params
                    isNeedSVP:(BOOL)isNeed
                   success:(CompleteHandler)success
                    failed:(FaildureHandler)failed;

- (void)request_postWithApi:(NSString *)api
                    params:(nullable id)params
                    isNeedSVP:(BOOL)isNeed
                   success:(CompleteHandler)success
                     failed:(FaildureHandler)failed;

@end

NS_ASSUME_NONNULL_END
