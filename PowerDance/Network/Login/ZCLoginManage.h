//
//  ZCLoginManage.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCLoginManage : NSObject

+ (void)sendPhoneCodeOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)phoneCodeLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)wechatAuthLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getUserBluetoothSettingInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)checkWXAuthLoginBindInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)appleAuthLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)sendEmailCodeOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)emailCodeLoginOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

@end

NS_ASSUME_NONNULL_END
