//
//  CFFCommonStore.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import "CFFBaseStore.h"

#define kCFF_COMMON_STORE  [CFFCommonStore shareInstance]

typedef void (^RequestCompleteSuccess)(id  _Nullable responseObject);
typedef void (^RequestCompleteFailed)(NSError * _Nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface CFFCommonStore : CFFBaseStore

@property (nonatomic,assign) double weight;

@property (nonatomic,assign) NSInteger recordCount;
@property (nonatomic,assign) NSInteger recordWaistCount;

+ (instancetype)shareInstance ;
 
- (void)saveCloudWeightOperate:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                        failed:(RequestCompleteFailed)failed;
- (void)saveCloudWeightRecordOperate:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                        failed:(RequestCompleteFailed)failed;
- (void)requestCloudRecordList:(NSDictionary *)parm Success:(RequestCompleteSuccess)success
                        failed:(RequestCompleteFailed)failed;

@end

NS_ASSUME_NONNULL_END
