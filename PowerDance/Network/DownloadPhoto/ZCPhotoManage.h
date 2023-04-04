//
//  ZCPhotoManage.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPhotoManage : NSObject

- (void)newLoadData:(NSURL *)pathUrl completeHandler:(void (^)(id responseObj))completerHandler;

- (NSString *)videoFilePath;

@end

NS_ASSUME_NONNULL_END
