//
//  ZCDataTool.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/8.
//

#import "ZCDataTool.h"
#import "ZCLoginController.h"
#import "ZCBaseNavController.h"

@implementation ZCDataTool

+ (NSArray *)convertWeightData {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 40; i < 200; i ++) {
        [dataArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return dataArr;
}
+ (NSArray *)convertHeightData {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 130; i < 240; i ++) {
        [dataArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return dataArr;
}

+ (NSArray *)convertAgeData {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 12; i < 150; i ++) {
        [dataArr addObject:[NSString stringWithFormat:@"%d%@", i, NSLocalizedString(@"岁", nil)]];
    }
    return dataArr;
}

+ (NSString *)convertKgToLb:(double)value {
    double lb = value / 0.453;
    return [NSString stringWithFormat:@"%.1f", lb];
}

+ (NSString *)reviseString:(NSString *)string {
    /* 直接传入精度丢失有问题的Double类型*/
    double conversionValue = (double)[string doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (double)convertMaxNumWithArray:(NSArray *)dataArr key:(NSString *)key {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        [array addObject:[self reviseString:dic[key]]];
    }
    CGFloat maxValue = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
    return maxValue;
}

+ (NSArray *)cityData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ZCCity" ofType:@"json"];
    NSData   *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
}

+ (void)loginOut {
    [ZCUserInfo logout];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    ZCBaseNavController *nav = [[ZCBaseNavController alloc] initWithRootViewController:[[ZCLoginController alloc] init]];
    win.rootViewController = nav;
    [win makeKeyAndVisible];
}

+ (void)saveTrainHistoryRecord:(NSString *)content {
    NSArray *dataArr = [self getTrainHistoryRecord];
    NSMutableArray *temArr = [NSMutableArray array];
    if (dataArr.count > 0) {
        [temArr addObjectsFromArray:dataArr];
    }
    if ([temArr containsObject:content]) {
        [temArr removeObject:content];
    }
    [temArr insertObject:content atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:temArr forKey:[self appendKeyContentContent:@"kTrainHistoryRecordKey"]];
}
+ (NSArray *)getTrainHistoryRecord {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kTrainHistoryRecordKey"]];
}

+ (NSString *)appendKeyContentContent:(NSString *)content {
    return [content stringByAppendingString:checkSafeContent(kUserInfo.phone)];
}

+ (void)saveTrainColorInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:dataArr forKey:@"kSaveTrainColorInfoKey"];
}

+ (NSArray *)getTrainColorInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kSaveTrainColorInfoKey"];
}

+ (NSString *)convertStringTimeToMouse:(NSString *)content {
    NSString *mouseStr;
    NSArray *timeArr = [content componentsSeparatedByString:@":"];
    if (timeArr.count == 3) {
        NSString *house = timeArr[0];
        NSString *minute = timeArr[1];
        NSString *mouse = timeArr[2];
        mouseStr = [NSString stringWithFormat:@"%tu", [house integerValue]*3600+[minute integerValue]*60+[mouse integerValue]];
    } else if (timeArr.count == 2) {
        NSString *minute = timeArr[0];
        NSString *mouse = timeArr[1];
        mouseStr = [NSString stringWithFormat:@"%tu", [minute integerValue]*60+[mouse integerValue]];
    } 
    return mouseStr;
}

+ (NSString *)convertMouseToTimeString:(NSInteger)mouse {
    
    NSInteger seconds = mouse;
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

+ (NSString *)convertMouseToMSTimeString:(NSInteger)mouse {
    
    NSInteger seconds = mouse;
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
    
}

+ (NSString *)convertMouseToMSUnitString:(NSInteger)mouse {
    
    NSInteger seconds = mouse;
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time;
    if ([str_second integerValue] > 0) {
        format_time = [NSString stringWithFormat:@"%.1f%@", mouse/60.0, NSLocalizedString(@"分钟", nil)];
    } else {
        format_time = [NSString stringWithFormat:@"%@%@",str_minute, NSLocalizedString(@"分钟", nil)];
    }
    return format_time;
    
}

+ (NSString *)randomColor {
    NSArray *colorArr = [self getTrainColorInfo];
    NSInteger count = colorArr.count;
    NSString *color = @"#6495ED";
    if(count > 0) {
        int index = arc4random()%count;
        color = colorArr[index];
    }
    return color;
}

+ (BOOL)judgeContentValue:(id)content {
    BOOL flag;
    if ([content isKindOfClass:[NSNull class]]) {
        flag = NO;
    } else if (content == nil) {
        flag = NO;
    } else {
        flag = YES;
    }
    return flag;
}

+ (void)saveVersionInfo:(NSDictionary *)content {
    [[NSUserDefaults standardUserDefaults] setValue:content forKey:@"kGetVersionInfoKey"];
}

+ (NSDictionary *)getVersionInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kGetVersionInfoKey"];
}

+ (void)saveTimerStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"kSaveTimerStatusKey"];
}
+ (BOOL)getTimerStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveTimerStatusKey"];
}

+ (void)saveUserWechatAuthInfo:(NSDictionary *)dic {
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"kSaveUserWechatAuthInfoKey"];
}
+ (NSDictionary *)getUserWechatAuthInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kSaveUserWechatAuthInfoKey"];
}

+ (void)saveTimerTypeStatus:(NSInteger)status {
    [[NSUserDefaults standardUserDefaults] setInteger:status forKey:@"kSaveTimerTypeStatusKey"];
}

+ (NSInteger)getTimerTypeStatus {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"kSaveTimerTypeStatusKey"];
}

+ (BOOL)judgeEffectiveData:(id)data {
    BOOL flag = NO;
    if ([data isKindOfClass:[NSNull class]]) {
        flag = NO;
    } else {
        flag = YES;
    }
    return flag;
}

+ (NSArray *)convertEffectiveData:(id)data {
    NSArray *arr = data;
    if ([data isKindOfClass:[NSNull class]]) {
        arr = @[];
    }
    return arr;
}

+ (void)saveHomeTrainListInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:dataArr forKey:[self appendKeyContentContent:@"kSaveHomeTrainListInfoKey"]];
}

+ (NSArray *)getHomeTrainListInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveHomeTrainListInfoKey"]];
}

+ (void)saveTrainActionListInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:[self appendKeyContentContent:@"kSaveTrainRecommendListInfoKey"]];
}

+ (NSArray *)getTrainActionListInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveTrainRecommendListInfoKey"]];
}

+ (void)saveTrainGoodListInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:[self appendKeyContentContent:@"kSaveTrainGoodListInfoKey"]];
}

+ (NSArray *)getTrainGoodListInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveTrainGoodListInfoKey"]];
}

+ (void)saveTrainTargetInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:[self appendKeyContentContent:@"kSaveTrainTargetInfoKey"]];
}

+ (NSArray *)getTrainTargetInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveTrainTargetInfoKey"]];
}

+ (NSArray *)convertEffectiveCacheData:(NSArray *)temArr {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *dic in temArr) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *keyStr in dic.allKeys) {
            if ([dic[keyStr] isEqual:[NSNull null]] || [dic[keyStr] isEqual:[NSNull class]]) {
            } else {
                [mutableDic setValue:checkSafeContent(dic[keyStr]) forKey:keyStr];
            }
        }
        [dataArr addObject:mutableDic];
    }
    return dataArr;
}

+ (void)saveShopGoodsCategoryInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:[self appendKeyContentContent:@"kSaveShopGoodsCategoryInfoKey"]];
}
+ (NSArray *)getShopGoodsCategoryInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveShopGoodsCategoryInfoKey"]];
}

+ (void)saveEquipmentCategoryInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:[self appendKeyContentContent:@"kSaveEquipmentCategoryInfoKey"]];
}
+ (NSArray *)getEquipmentCategoryInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveEquipmentCategoryInfoKey"]];
}

+ (void)saveShopGoodsCategoryTargetInfo:(NSArray *)dataArr source:(NSInteger)sourceId {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:[self appendKeyContentContent:[NSString stringWithFormat:@"%@-%tu", @"kSaveShopGoodsCategoryTargetInfoKey", sourceId]]];
}
+ (NSArray *)getShopGoodsCategoryTargetInfoWithSourceId:(NSInteger)sourceId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:[NSString stringWithFormat:@"%@-%tu", @"kSaveShopGoodsCategoryTargetInfoKey", sourceId]]];
}

+ (void)saveEquipmentListInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:[self appendKeyContentContent:@"kSaveEquipmentListInfoKey"]];
}
+ (NSArray *)getEquipmentListInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveEquipmentListInfoKey"]];
}

+ (void)saveHomeGuideSign:(NSInteger)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:[self appendKeyContentContent:@"kSaveHomeGuideSignKey"]];
}
+ (NSInteger)getHomeGuideSign {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self appendKeyContentContent:@"kSaveHomeGuideSignKey"]];
}
//自定义训练引导自动弹出
+ (void)saveCustomTrainGuideSign:(NSInteger)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:[self appendKeyContentContent:@"kSaveCustomTrainGuideSignKey"]];
}

+ (NSInteger)getCustomTrainGuideSign {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self appendKeyContentContent:@"kSaveCustomTrainGuideSignKey"]];
}

//自由练训练引导自动弹出
+ (void)saveCustomCourseGuideSign:(NSInteger)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:[self appendKeyContentContent:@"kSaveCustomCourseGuideSignKey"]];
}

+ (NSInteger)getCustomCourseGuideSign {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self appendKeyContentContent:@"kSaveCustomCourseGuideSignKey"]];
}

//自由练引导删除标记
+ (void)saveCustomCourseProfileSign:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:[self appendKeyContentContent:@"kSaveCustomCourseProfileSignKey"]];
}
+ (BOOL)getCustomCourseProfileSign {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self appendKeyContentContent:@"kSaveCustomCourseProfileSignKey"]];
}
//自定义训练引导删除标记
+ (void)saveCustomTrainProfileSign:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:[self appendKeyContentContent:@"kSaveCustomTrainProfileSignKey"]];
}
+ (BOOL)getCustomTrainCourseProfileSign {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self appendKeyContentContent:@"kSaveCustomTrainProfileSignKey"]];
}

+ (void)saveUserPortraint:(NSString *)url {
    [[NSUserDefaults standardUserDefaults] setValue:checkSafeContent(url) forKey:[self appendKeyContentContent:@"kSaveUserPortraintKey"]];
}
+ (NSString *)getUserPortraint {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self appendKeyContentContent:@"kSaveUserPortraintKey"]];
}

+ (void)signHasInputUserInfo:(BOOL)status {
    [[self standardUserDefaults] setBool:status forKey:[self appendKeyContentContent:@"kSignHasInputUserInfo"]];
}
+ (BOOL)getSignHasInputUserInfo {
    return [[self standardUserDefaults] boolForKey:[self appendKeyContentContent:@"kSignHasInputUserInfo"]];
}

+ (NSUserDefaults *)standardUserDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+ (void)signKnowSmartDeviceStatus:(BOOL)status code:(NSString *)code {
    [[self standardUserDefaults] setBool:status forKey:[NSString stringWithFormat:@"%@%@", @"kSignKnowSmartDeviceStatusKey", code]];
}
+ (BOOL)getSignKnowSmartDeviceStatusWithCode:(NSString *)code {
    return [[self standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@", @"kSignKnowSmartDeviceStatusKey", code]];
}

+ (void)saveCourseCategoryInfo:(NSArray *)dataArr {
    [[NSUserDefaults standardUserDefaults] setValue:[self convertEffectiveCacheData:dataArr] forKey:@"kSaveCourseCategoryInfoKey"];
}

+ (NSArray *)getCourseCategoryInfo {
    return [[self standardUserDefaults] valueForKey:@"kSaveCourseCategoryInfoKey"];
}

+ (void)saveHomeTrainPlanStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:[self appendKeyContentContent:@"kSaveHomeTrainPlanStatusKey"]];
}

+ (BOOL)getHomeTrainPlanStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self appendKeyContentContent:@"kSaveHomeTrainPlanStatusKey"]];
}

+ (void)judgeUserMode {
    if ([ZCUserInfo shareInstance].token == nil) {
        [ZCDataTool loginOut];
        return;
    }
}
//1 隐藏  0 显示
+ (void)saveUserShowCenterDataStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:[self appendKeyContentContent:@"kSaveUserShowCenterDataStatusKey"]];
}
 
+ (BOOL)getUserShowCenterDataStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self appendKeyContentContent:@"kSaveUserShowCenterDataStatusKey"]];
}

@end
