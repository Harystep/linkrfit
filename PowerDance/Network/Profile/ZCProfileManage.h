//
//  ZCProfileManage.h
//  PowerDance
//
//  Created by PC-N121 on 2021/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kUserStore  [ZCProfileManage shareInstance]

@interface ZCProfileManage : NSObject

@property (nonatomic,strong) NSDictionary *userData;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,assign) NSInteger refreshTrainClass;//标记训练课程

@property (nonatomic,strong) NSMutableDictionary *saveData;//保存编辑值

@property (nonatomic,assign) NSInteger refreshBindDevice;//标记绑定设备

@property (nonatomic,copy) NSString *tokenBytes;

+ (instancetype)shareInstance;

+ (void)updateUserInfoOperate:(NSDictionary *)params completeHandler:(void (^)(id responseObj))completerHandler;

+ (void)getUserBaseInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 检测版本信息
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)checkAppVersionInfo:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

/// 查询训练总数据
/// @param parms <#parms description#>
/// @param completerHandler <#completerHandler description#>
+ (void)queryTrainTotalDataInfoURL:(NSDictionary *)parms completeHandler:(void (^)(id responseObj))completerHandler;

@end

NS_ASSUME_NONNULL_END
