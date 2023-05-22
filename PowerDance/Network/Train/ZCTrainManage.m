//
//  ZCTrainManage.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/22.
//

#import "ZCTrainManage.h"

#define kEquipmentCategoryInfoURL @"apparatus/tags"
#define kEquipmentListInfoURL @"apparatus/list"
#define kQueryEquipmentTrainListURL @"train/query"

#define kQueryActionListInfoURL @"action/item/list" //动作列表 keyword
#define kAddActionOperateURL @"action/item/customized" //添加个性动作
#define kQueryActionHomeColorListURL @"settings/list?type=colour" //颜色
#define kQueryActionPatternListURL @"settings/list?type=pattern" //器械
#define kCreateAutoTrainInfoURL @"train/customized"//定制训练

#define kGetHomeTrainListInfoURL @"train/list" //首页训练列表
#define kGetTrainDetailInfoURL @"train/detail" //训练详情
#define kCollectTrainPlanInfoURL @"train/copy"//添加到用户训练

#define kGetHistoryTrainListInfoURL @"train/record/list"//获取训练记录
#define kSaveTrainRecordInfoOperateURL @"train/save/record"//保存训练记录

#define kGetUserTrainDataInfoURL @"user/train/statistics"

#define kDeleteTrainOperateURL @"train/del?trainId="

#define kCreateAutoActionTrainInfoURL @"custom/course/upload"//定制动作自定义训练
#define kEditAutoActionTrainInfoURL @"custom/course/update"//编辑动作自定义训练
#define kDeleteAutoActionTrainInfoURL @"custom/course/"//删除动作自定义训练
#define kQueryAutoActionTrainInfoURL @"custom/course/list?current=1&size=100"//获取自定义动作信息
#define kQueryAutoActionTrainDetailInfoURL @"custom/course/"//自定义训练详情

#define kRecordCourseTrainInfoURL @"train/save/record/v1" //计时器编辑课程

#define kQuerySmartDeviceListInfoURL @"apparatus/all?intelligent=true"//获取智能设备列表

#define kQueryTrainHistoryListInfoURL @"train/record/list/"//获取训练历史列表信息

#define kQueryCourseListInfoURL @"course/list" //课程列表
#define kQueryCourseTagListInfoURL @"course/tags"//课程分类信息

#define kQueryHomeBannerListInfoURL @"banner/list"//首页banner
#define kQueryUserTrainPlanListInfoURL @"plan/list"//训练计划

#define kFinishTrainPlanClassOperateURL @"plan/finish"//http://localhost:9009/plan/finish?userPlanId=28

#define kQueryTrainPlanAllDataInfoURL @"user/record/statistics"//训练统计查询

#define kQueryTrainClassFromTimeURL @"user/record/list"//根据时间查询训练课程

#define kQueryHardwareVersionInfoURL @"version/hardware"///获取当前硬件版本信息

@implementation ZCTrainManage

+ (void)queryEquipmentCategoryInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kEquipmentCategoryInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryEquipmentListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parms];
    [dic setValue:@"20" forKey:@"size"];
    [[ZCNetwork shareInstance] request_getWithApi:kEquipmentListInfoURL params:dic isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryEquipmentTrainListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parms];
    [dic setValue:@"20" forKey:@"size"];
    [[ZCNetwork shareInstance] request_getWithApi:kQueryEquipmentTrainListURL params:dic isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryTrainActionListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = kQueryActionListInfoURL;
//    NSString *keyword = parms[@"keyword"];
//    if (keyword.length > 0) {
//        url = [url stringByAppendingFormat:@"?keyword=%@", parms[@"keyword"]];
//    }
//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [[ZCNetwork shareInstance] request_getWithApi:url params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)addTrainActionOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {

    [[ZCNetwork shareInstance] request_postWithApi:kAddActionOperateURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)createAutoTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {

    [[ZCNetwork shareInstance] request_postWithApi:kCreateAutoTrainInfoURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}


+ (void)queryTrainActionHomeColorInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryActionHomeColorListURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryTrainEquipmentPatternListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryActionPatternListURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryHomeTrainListInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kGetHomeTrainListInfoURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
//        completerHandler(data);
    }];
}

+ (void)queryTrainDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kGetTrainDetailInfoURL params:parms isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)collectTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [kCollectTrainPlanInfoURL stringByAppendingFormat:@"?trainId=%@", parms[@"trainId"]];
    [[ZCNetwork shareInstance] request_postWithApi:url params:@{} isNeedSVP:YES success:^(id  _Nullable responseObj) {
        kProfileStore.collectTrainRefresh = YES;
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        completerHandler(data);
    }];
}

+ (void)saveTrainRecordOpereateInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [kSaveTrainRecordInfoOperateURL stringByAppendingFormat:@"?trainId=%@", parms[@"trainId"]];
    [[ZCNetwork shareInstance] request_postWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        kProfileStore.recordTrainRefresh = YES;
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)queryHistoryTrainDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parms];
    [dic setValue:@"20" forKey:@"size"];
    [[ZCNetwork shareInstance] request_getWithApi:kGetHistoryTrainListInfoURL params:dic isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getUserTrainDataInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kGetUserTrainDataInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)deleteTrainInfoOperate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kDeleteTrainOperateURL, parms[@"trainId"]];
    [[ZCNetwork shareInstance] request_postWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)createAutoActionTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {

    [[ZCNetwork shareInstance] request_postWithApi:kCreateAutoActionTrainInfoURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        kProfileStore.customActionRefresh = YES;
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)editAutoActionTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {

    [[ZCNetwork shareInstance] request_postWithApi:kEditAutoActionTrainInfoURL params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        kProfileStore.customActionRefresh = YES;
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//kDeleteAutoActionTrainInfoURL

+ (void)deleteAutoActionTrainPlanOpereate:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {

    NSString *url = [NSString stringWithFormat:@"%@%@", kDeleteAutoActionTrainInfoURL, parms[@"id"]];
    [[ZCNetwork shareInstance] request_postWithApi:url params:parms isNeedSVP:YES success:^(id  _Nullable responseObj) {
        kProfileStore.customActionRefresh = YES;
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)getAutoActionTrainDataInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryAutoActionTrainInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//
+ (void)getAutoActionTrainDetailInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%lld",kQueryAutoActionTrainDetailInfoURL, [parms[@"id"] longLongValue]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

+ (void)recordTrainRecordInfo:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kRecordCourseTrainInfoURL params:params isNeedSVP:YES success:^(id  _Nullable responseObj) {
        kProfileStore.recordTrainRefresh = YES;
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//kQuerySmartDeviceListInfoURL
+ (void)querySmartDeviceListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQuerySmartDeviceListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {        
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//kQueryTrainHistoryListInfoURL
+ (void)queryTrainHistoryListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@%@", kQueryTrainHistoryListInfoURL, params[@"id"]];
    [[ZCNetwork shareInstance] request_getWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//kQueryCourseListInfoURL
+ (void)queryCourseListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@?size=10&current=%@", kQueryCourseListInfoURL, params[@"current"]];
    [[ZCNetwork shareInstance] request_postWithApi:url params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//kQueryCourseTagListInfoURL
+ (void)queryCourseTagListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryCourseTagListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//kQueryHomeBannerListInfoURL
+ (void)queryHomeBannerListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryHomeBannerListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//kQueryUserTrainPlanListInfoURL
+ (void)queryUserTrainPlanListInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryUserTrainPlanListInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}
//
+ (void)finishTrainPlanClassOperateURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    NSString *url = [NSString stringWithFormat:@"%@?userPlanId=%@", kFinishTrainPlanClassOperateURL, params[@"userPlanId"]];
    [[ZCNetwork shareInstance] request_postWithApi:url params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        kUserStore.refreshTrainClass = YES;
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//
+ (void)queryTrainPlanAllDataInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {    
    [[ZCNetwork shareInstance] request_getWithApi:kQueryTrainPlanAllDataInfoURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//
+ (void)queryTrainClassFromTimeURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_postWithApi:kQueryTrainClassFromTimeURL params:params isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

//
+ (void)queryHardwareVersionInfoURL:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler {
    [[ZCNetwork shareInstance] request_getWithApi:kQueryHardwareVersionInfoURL params:@{} isNeedSVP:NO success:^(id  _Nullable responseObj) {
        completerHandler(responseObj);
    } failed:^(id  _Nullable data) {
        
    }];
}

@end


