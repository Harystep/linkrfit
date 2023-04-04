//
//  CFFSmartManager.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import "CFFDataTool.h"


NS_ASSUME_NONNULL_BEGIN

@interface CFFSmartManager : NSObject


/// 获取设备列表信息
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryDeviceListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 保存腰围尺记录
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)saveRulerRecordInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取腰围尺记录
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryRulerRecordInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 绑定操作
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)bindDeviceOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

@end

NS_ASSUME_NONNULL_END
