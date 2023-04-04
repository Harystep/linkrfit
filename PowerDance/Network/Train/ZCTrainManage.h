//
//  ZCTrainManage.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainManage : NSObject
//查询器械分类
+ (void)queryEquipmentCategoryInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;
/// 查询器械分类相关列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryEquipmentListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询训练
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryEquipmentTrainListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取动作列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainActionListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 添加个性动作
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)addTrainActionOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取首页颜色
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainActionHomeColorInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取器械图标列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainEquipmentPatternListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 定制训练计划
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)createAutoTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 首页训练列表
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryHomeTrainListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 训练详情
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)collectTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)queryHistoryTrainDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 保存训练记录
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)saveTrainRecordOpereateInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getUserTrainDataInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 删除训练记录
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)deleteTrainInfoOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 定制自定义训练
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)createAutoActionTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)editAutoActionTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)deleteAutoActionTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getAutoActionTrainDataInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getAutoActionTrainDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 记录训练记录
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)recordTrainRecordInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取智能设备列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)querySmartDeviceListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取训练历史列表信息
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainHistoryListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询课程列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryCourseListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询课程分类信息
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryCourseTagListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 首页banner
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryHomeBannerListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询训练计划
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryUserTrainPlanListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 完成训练计划
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)finishTrainPlanClassOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询训练数据
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainPlanAllDataInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 根据时间查询训练课程
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainClassFromTimeURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

@end

NS_ASSUME_NONNULL_END
