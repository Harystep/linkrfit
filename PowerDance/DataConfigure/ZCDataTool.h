//
//  ZCDataTool.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCDataTool : NSObject

+ (NSArray *)convertWeightData;
+ (NSArray *)convertHeightData;
+ (NSArray *)convertAgeData;
+ (NSString *)convertKgToLb:(double)value;

+ (NSString *)reviseString:(NSString *)string;

+ (double)convertMaxNumWithArray:(NSArray *)dataArr key:(NSString *)key;

+ (NSArray *)cityData;

+ (void)loginOut;

+ (void)saveTrainHistoryRecord:(NSString *)content;

+ (NSArray *)getTrainHistoryRecord;

+ (NSString *)convertStringTimeToMouse:(NSString *)content;

/// 将秒数转化为 时:分:秒
/// @param mouse 秒数
+ (NSString *)convertMouseToTimeString:(NSInteger)mouse;

/// 将秒数转化为 分:秒
/// @param mouse 秒数
+ (NSString *)convertMouseToMSTimeString:(NSInteger)mouse;

+ (void)saveTrainColorInfo:(NSArray *)dataArr;
+ (NSArray *)getTrainColorInfo;

+ (id)checkDatSafe:(id)data;

+ (NSString *)randomColor;

+ (BOOL)judgeContentValue:(id)content;

+ (void)saveVersionInfo:(NSDictionary *)content;
+ (NSDictionary *)getVersionInfo;

+ (void)saveTimerStatus:(BOOL)status;
+ (BOOL)getTimerStatus;

+ (void)saveUserWechatAuthInfo:(NSDictionary *)dic;
+ (NSDictionary *)getUserWechatAuthInfo;

/// 标记 选择计时器
/// @param status 1:大计时器  其他：小计时器
+ (void)saveTimerTypeStatus:(NSInteger)status;
+ (NSInteger)getTimerTypeStatus;
+ (BOOL)judgeEffectiveData:(id)data;
+ (NSArray *)convertEffectiveData:(id)data;

+ (void)saveHomeTrainListInfo:(NSArray *)dataArr;
+ (NSArray *)getHomeTrainListInfo;

+ (void)saveTrainActionListInfo:(NSArray *)dataArr;
+ (NSArray *)getTrainActionListInfo;

+ (void)saveTrainGoodListInfo:(NSArray *)dataArr;
+ (NSArray *)getTrainGoodListInfo;

+ (void)saveShopGoodsCategoryInfo:(NSArray *)dataArr;
+ (NSArray *)getShopGoodsCategoryInfo;

+ (void)saveShopGoodsCategoryTargetInfo:(NSArray *)dataArr source:(NSInteger)sourceId;
+ (NSArray *)getShopGoodsCategoryTargetInfoWithSourceId:(NSInteger)sourceId;

+ (void)saveEquipmentListInfo:(NSArray *)dataArr;
+ (NSArray *)getEquipmentListInfo;

+ (void)saveHomeGuideSign:(NSInteger)type;
+ (NSInteger)getHomeGuideSign;

+ (void)saveCustomTrainGuideSign:(NSInteger)type;
+ (NSInteger)getCustomTrainGuideSign;

+ (void)saveTrainTargetInfo:(NSArray *)dataArr;
+ (NSArray *)getTrainTargetInfo;

+ (void)saveCustomCourseProfileSign:(BOOL)status;
+ (BOOL)getCustomCourseProfileSign;

+ (void)saveCustomTrainProfileSign:(BOOL)status;
+ (BOOL)getCustomTrainCourseProfileSign;
//自由练训练引导自动弹出
+ (void)saveCustomCourseGuideSign:(NSInteger)type;
+ (NSInteger)getCustomCourseGuideSign;
//用户头像
+ (void)saveUserPortraint:(NSString *)url;
+ (NSString *)getUserPortraint;

/// 编辑设置用户信息
/// @param status <#status description#>
+ (void)signHasInputUserInfo:(BOOL)status;
+ (BOOL)getSignHasInputUserInfo;

+ (void)signKnowSmartDeviceStatus:(BOOL)status code:(NSString *)code;
+ (BOOL)getSignKnowSmartDeviceStatusWithCode:(NSString *)code;

/// 器械列表信息
/// @param dataArr <#dataArr description#>
+ (void)saveEquipmentCategoryInfo:(NSArray *)dataArr;
+ (NSArray *)getEquipmentCategoryInfo;

/// 课程分类信息
/// @param dataArr <#dataArr description#>
+ (void)saveCourseCategoryInfo:(NSArray *)dataArr;
+ (NSArray *)getCourseCategoryInfo;

+ (NSString *)convertMouseToMSUnitString:(NSInteger)mouse;

+ (void)saveHomeTrainPlanStatus:(BOOL)status;

+ (BOOL)getHomeTrainPlanStatus;

/// 判断用户浏览模式
+ (void)judgeUserMode;

+ (void)saveUserShowCenterDataStatus:(BOOL)status;
+ (BOOL)getUserShowCenterDataStatus;


@end

NS_ASSUME_NONNULL_END
