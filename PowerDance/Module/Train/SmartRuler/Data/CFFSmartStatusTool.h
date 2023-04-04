//
//  CFFSmartStatusTool.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFSmartStatusTool : NSObject

+ (void)saveSmartStatus:(NSInteger)status;
+ (NSInteger)getSmartStatus;

@end

NS_ASSUME_NONNULL_END
