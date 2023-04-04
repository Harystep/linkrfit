//
//  ZCProfileStore.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import <Foundation/Foundation.h>

#define kProfileStore  [ZCProfileStore shareInstance]

NS_ASSUME_NONNULL_BEGIN

@interface ZCProfileStore : NSObject

@property (nonatomic,assign) BOOL collectTrainRefresh;//收藏训练
@property (nonatomic,assign) BOOL recordTrainRefresh;//记录训练
@property (nonatomic,assign) BOOL customActionRefresh;//自定义动作训练

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
