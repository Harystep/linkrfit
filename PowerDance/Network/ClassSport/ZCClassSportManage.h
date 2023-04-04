//
//  ZCClassSportManage.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassSportManage : NSObject

/// 精品课程列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classGoodListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)recommendActionListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 课程分类
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classCategoryListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 课程列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 训练目标列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classTrainTargetListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 课程推荐列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classRecommendListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 课程详情
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classDetailInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 器械分类
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)instrumentCategoryListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 器械列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)instrumentListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 器械详情
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)instrumentDetailInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 动作列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)actionListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取所有动作列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)actionAllListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 动作详情
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)actionDetailInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 动作分类
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)actionCategoryInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)recordCourseTrainInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 获取器械动作/课程列表信息
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryEquipmentTrainListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 体能测试数据提交
/// @param params @{testId , duration  total}
/// @param completerHandler <#completerHandler description#>
+ (void)measurePhysicalInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询体能测试结果
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryPhysicalTestListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 记录自定义课程
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)recordCustomCourseTrainInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询 商城-推荐喜欢/上新 的器械
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryEquipmentFavListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 推荐训练计划
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryRecommendTrainPlanListURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询今日训练数据
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTodayTrainDataInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询总的训练数据
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTotalTrainDataInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询个人健康指数
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryUserTrainHealthyInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 提交训练计划
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)submitUserTrainPlanOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询绑定设备列表信息
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryUserBindDeviceListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)queryUserHomeBindDeviceListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

/// 绑定智能设备操作
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)bindSmartDeviceInfoOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

@end

NS_ASSUME_NONNULL_END
