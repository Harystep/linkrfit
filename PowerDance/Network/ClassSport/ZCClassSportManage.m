//
//  ZCClassSportManage.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/29.
//

#import "ZCClassSportManage.h"

#define kClassGoodListInfoURL         @"course/boutique"
#define kClassCategoryListInfoURL     @"course/tags"
#define kClassListInfoURL             @"course/list"
#define kClassTrainTargetListInfoURL  @"course/target/list"
#define kClassRecommendListInfoURL    @"course/recommend?count=10"
#define kClassDetailInfoURL           @"course/"

#define kInstrumentCategoryListURL @"apparatus/tags"
#define kInstrumentListURL         @"apparatus/list"
#define kInstrumentDetailURL       @"apparatus/"

#define kActionListURL @"course/action/list"
#define kActionDetailURL @"course/action/"
#define kActionCategoryURL @"course/action/tags"

#define kRecommendActionListURL @"user/recommend"

#define kRecordCourseTrainInfoURL @"course/save/record/v1"//课程记录
#define kRecordCustomCourseTrainInfoURL @"custom/course/save/record"// 自定义课程记录

#define kQueryEquipmentTrainListInfoURL @"test/list?apparatusId="//体能训练列表

#define kMeasurePhysicalInfoURL @"test/settlement"//体能测试计算

#define kQueryPhysicalTestListInfoURL @"test/history?testId="//测试结果

#define kQueryEquipmentFavListInfoURL @"product/likeAndNewest"//商品-推荐器械

#define kQueryRecommendTrainPlanListURL @"plan/list"//推荐训练计划

#define kQueryTrainBaseBMIInfoURL @"plan/info"//训练健康指数 plan/info?weight=68&height=175&foundation=1&sex=1  foundation:1:低  2:间接性训练   3:定期训练  sex=1 男 2 女

#define kQueryTodayTrainDataInfoURL @"user/record/today/data"//查询今天训练数据
#define kQueryTotalTrainDataInfoURL @"user/record/total/data"//查询总的训练数据

#define kQueryUserTrainHealthyInfoURL @"plan/info"//检测个人健康指数

#define kSubmitUserTrainPlanOperateURL @"plan/formulate"//制定训练计划

#define kQueryUserBindDeviceListInfoURL @"user/binding/list"//绑定设备列表信息

#define kUserBindDeviceInfoOperateURL @"/user/binding"//?apparatusId=25

@implementation ZCClassSportManage

/// 精品课程列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classGoodListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kClassGoodListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)recommendActionListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kRecommendActionListURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

/// 课程分类
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classCategoryListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kClassCategoryListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

/// 课程列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSInteger current = [params[@"current"] integerValue] >0?[params[@"current"] integerValue]:1;
    NSString *url = [NSString stringWithFormat:@"%@?current=%tu&size=12", kClassListInfoURL, current];
    [[ZCNetwork shareInstance] request_postWithApi:url params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

/// 训练目标列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classTrainTargetListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kClassTrainTargetListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

/// 课程推荐列表
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classRecommendListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kClassRecommendListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

/// 课程详情
/// @param params <#params description#>
/// @param completerHandler <#completerHandler description#>
+ (void)classDetailInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kClassDetailInfoURL, params[@"id"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)instrumentCategoryListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kInstrumentCategoryListURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}
//
+ (void)instrumentListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
//    NSString *url = [NSString stringWithFormat:@"%@?current=1&size=200", kInstrumentListURL];
    [[ZCNetwork shareInstance] request_getWithApi:kInstrumentListURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)instrumentDetailInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kInstrumentDetailURL, params[@"id"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)actionListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSInteger current = [params[@"current"] integerValue] >0?[params[@"current"] integerValue]:1;
    NSString *url = [NSString stringWithFormat:@"%@?current=%tu&size=12", kActionListURL, current];
    [[ZCNetwork shareInstance] request_postWithApi:url params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)actionAllListInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
//    NSInteger current = [params[@"current"] integerValue] >0?[params[@"current"] integerValue]:1;
//    NSString *url = [NSString stringWithFormat:@"%@?current=%tu&size=12", kActionListURL, current];
    [[ZCNetwork shareInstance] request_postWithApi:kActionListURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)actionDetailInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kActionDetailURL, params[@"id"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)actionCategoryInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kActionCategoryURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)recordCourseTrainInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kRecordCourseTrainInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        kProfileStore.customActionRefresh = YES;
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//kRecordCustomCourseTrainInfoURL
+ (void)recordCustomCourseTrainInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kRecordCustomCourseTrainInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        kProfileStore.customActionRefresh = YES;
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)queryEquipmentTrainListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kQueryEquipmentTrainListInfoURL, params[@"id"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//kMeasurePhysicalInfoURL
+ (void)measurePhysicalInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kMeasurePhysicalInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//kQueryPhysicalTestListInfoURL
+ (void)queryPhysicalTestListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kQueryPhysicalTestListInfoURL, params[@"id"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//kQueryEquipmentFavListInfoURL
+ (void)queryEquipmentFavListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
//    NSString *url = [NSString stringWithFormat:@"%@", kQueryEquipmentFavListInfoURL];
    [[ZCNetwork shareInstance] request_getWithApi:kQueryEquipmentFavListInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)queryRecommendTrainPlanListURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
//    NSString *url = [NSString stringWithFormat:@"%@", kQueryEquipmentFavListInfoURL];
    [[ZCNetwork shareInstance] request_getWithApi:kQueryRecommendTrainPlanListURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//
+ (void)queryTotalTrainDataInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryTotalTrainDataInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)queryTodayTrainDataInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryTodayTrainDataInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//
+ (void)queryUserTrainHealthyInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryUserTrainHealthyInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)submitUserTrainPlanOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kSubmitUserTrainPlanOperateURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//
+ (void)queryUserBindDeviceListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryUserBindDeviceListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

+ (void)queryUserHomeBindDeviceListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryUserBindDeviceListInfoURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

//
+ (void)bindSmartDeviceInfoOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kUserBindDeviceInfoOperateURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        kUserStore.refreshBindDevice = YES; 
        completerHandler(responseObj);
        } failed:^(id  _Nullable data) {
            
        }];
}

@end
