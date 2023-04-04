//
//  CFFPreferenceTool.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFPreferenceTool : NSObject

+ (void)saveFullFlashStatus:(BOOL)status;
+ (BOOL)getFullFlashStatus;

+ (void)saveUserGuideStatus:(BOOL)status;
+ (BOOL)getUserGuideStatus;

+ (void)saveSmartTypeInfo:(NSDictionary *)content;
+ (NSDictionary *)getSmartTypeInfo;

+ (void)saveUserDevIdInfo:(NSString *)content;
+ (NSString *)getUserDevIdInfo;

+ (void)saveVersionInfo:(NSDictionary *)content;
+ (NSDictionary *)getVersionInfo;

+ (void)saveUserCloudGuideStatus:(BOOL)status;

+ (BOOL)getUserCloudGuideStatus;

+ (void)saveUserRulerGuideStatus:(BOOL)status;

+ (BOOL)getUserRulerGuideStatus;

+ (void)saveUserScaleGuideStatus:(BOOL)status;

+ (BOOL)getUserScaleGuideStatus;

@end

NS_ASSUME_NONNULL_END
