//
//  CFFProfileStore.h
//  CofoFit
//
//  Created by PC-N121 on 2021/5/7.
//

#import <Foundation/Foundation.h>
#import "CFFBaseStore.h"

#define kCFF_PROFILE_STORE  [CFFProfileStore shareInstance]

typedef void (^RequestCompleteSuccess)(id  _Nullable responseObject);
typedef void (^RequestCompleteFailed)(NSError * _Nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface CFFProfileStore : CFFBaseStore

@property (nonatomic,assign) BOOL needRefreshTarget;

@property (nonatomic,strong) NSMutableArray *userDataList;
@property (nonatomic,strong) NSMutableDictionary *userInfoDic;
@property (nonatomic, copy) NSString *iconStr;

+ (instancetype)shareInstance;

//修改目标
- (void)requestUserTargetInfo:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                       failed:(RequestCompleteFailed)failed;

//更新用户信息
- (void)updateUserInfo:(NSDictionary *)parm success:(RequestCompleteSuccess)success
                failed:(RequestCompleteFailed)failed;

@end

NS_ASSUME_NONNULL_END
