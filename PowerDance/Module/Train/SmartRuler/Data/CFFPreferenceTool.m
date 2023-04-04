//
//  CFFPreferenceTool.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/8.
//

#import "CFFPreferenceTool.h"

@implementation CFFPreferenceTool

+ (void)saveFullFlashStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"kSaveFullFlashStatusKey"];
}

+ (BOOL)getFullFlashStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveFullFlashStatusKey"];
}

+ (void)saveUserGuideStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"kSaveUserGuideStatusKey"];
}

+ (BOOL)getUserGuideStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveUserGuideStatusKey"];
}

+ (void)saveUserRulerGuideStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"kSaveUserRulerGuideStatusKey"];
}

+ (BOOL)getUserRulerGuideStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveUserRulerGuideStatusKey"];
}

+ (void)saveUserScaleGuideStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"kSaveUserScaleGuideStatusKey"];
}

+ (BOOL)getUserScaleGuideStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveUserScaleGuideStatusKey"];
}

+ (void)saveUserCloudGuideStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"kSaveUserCloudGuideStatusKey"];
}

+ (BOOL)getUserCloudGuideStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveUserCloudGuideStatusKey"];
}

+ (void)saveSmartTypeInfo:(NSDictionary *)content {        
    [[NSUserDefaults standardUserDefaults] setValue:content forKey:@"kSaveSmartTypeInfoKey"];
}

+ (NSDictionary *)getSmartTypeInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kSaveSmartTypeInfoKey"];
}

+ (void)saveUserDevIdInfo:(NSString *)content {
    [[NSUserDefaults standardUserDefaults] setValue:content forKey:@"kSaveUserDevIdInfoKey"];
}
+ (NSString *)getUserDevIdInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kSaveUserDevIdInfoKey"];
}

+ (void)saveVersionInfo:(NSDictionary *)content {
    [[NSUserDefaults standardUserDefaults] setValue:content forKey:@"kGetVersionInfoKey"];
}

+ (NSDictionary *)getVersionInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kGetVersionInfoKey"];
}

@end
