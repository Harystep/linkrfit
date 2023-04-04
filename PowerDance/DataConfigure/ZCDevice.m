//
//  ZCDevice.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "ZCDevice.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CFLocale.h>

#define KAppWindow                       [[UIApplication sharedApplication].delegate window]

static ZCDevice *_instance = nil;

@implementation ZCDevice

#pragma mark singleton
+ (instancetype)currentDevice {
    static dispatch_once_t _once;
    dispatch_once(&_once, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

- (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    // 获取设备标识Identifier
    NSString *identifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *type;
    if ([identifier isEqualToString:@"iPhone7,2"]) {
        type = @"iPhone 6";
    }else if ([identifier isEqualToString:@"iPhone7,1"]){
        type = @"iPhone 6 Plus";
    }else if ([identifier isEqualToString:@"iPhone8,1"]){
        type = @"iPhone 6s";
    }else if ([identifier isEqualToString:@"iPhone8,2"]){
        type = @"iPhone 6s Plus";
    }else if ([identifier isEqualToString:@"iPhone9,1"] || [identifier isEqualToString:@"iPhone9,3"]){
        type = @"iPhone 7";
    }else if ([identifier isEqualToString:@"iPhone9,2"] || [identifier isEqualToString:@"iPhone9,4"]){
        type = @"iPhone 7 Plus";
    }else if ([identifier isEqualToString:@"iPhone10,1"] || [identifier isEqualToString:@"iPhone10,4"]){
        type = @"iPhone 8";
    }else if ([identifier isEqualToString:@"iPhone10,2"] || [identifier isEqualToString:@"iPhone10,5"]){
        type = @"iPhone 8 Plus";
    }else if ([identifier isEqualToString:@"iPhone10,3"] || [identifier isEqualToString:@"iPhone10,6"]){
        type = @"iPhone X";
    }else if ([identifier isEqualToString:@"iPhone11,8"]){
        type = @"iPhone XR";
    }else if ([identifier isEqualToString:@"iPhone11,2"]){
        type = @"iPhone XS";
    }else if ([identifier isEqualToString:@"iPhone11,4"] || [identifier isEqualToString:@"iPhone11,6"]){
        type = @"iPhone XS Max";
    }else if ([identifier isEqualToString:@"iPhone12,1"]){
        type = @"iPhone 11";
    }else if ([identifier isEqualToString:@"iPhone12,3"]){
        type = @"iPhone 11 Pro";
    }else if ([identifier isEqualToString:@"iPhone12,5"]){
        type = @"iPhone 11 Pro Max";
    }else if ([identifier isEqualToString:@"iPhone12,8"]){
        type = @"iPhone SE (gen 2)";
    }else if ([identifier isEqualToString:@"iPhone13,1"]){
        type = @"iPhone 12 Mini";
    }else if ([identifier isEqualToString:@"iPhone13,2"]){
        type = @"iPhone 12";
    }else if ([identifier isEqualToString:@"iPhone13,3"]){
        type = @"iPhone 12 Pro";
    }else if ([identifier isEqualToString:@"iPhone13,4"]){
        type = @"iPhone 12 Pro Max";
    }else if ([identifier isEqualToString:@"i386"] || [identifier isEqualToString:@"x86_64"] ){
        type = @"Simulator";
    }else {
        type = @"Not Recognized";
    }
    return type;;
}


- (CFFScreenType)screenType {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    if (CGSizeEqualToSize(screenSize, CGSizeMake(375.0, 667.0)) && scale == 2.0) {
        return CFFScreenType_8_SE2;
    }else if(CGSizeEqualToSize(screenSize, CGSizeMake(414.0, 736.0)) && scale == 3.0){
        return CFFScreenType_8Plus;
    }else if(CGSizeEqualToSize(screenSize, CGSizeMake(375.0, 812.0)) && scale == 3.0){
        return CFFScreenType_X_Xs_11Pro_12Mini ;
    }else if(CGSizeEqualToSize(screenSize, CGSizeMake(414.0, 896.0)) && scale == 2.0){
        return CFFScreenType_XR_11;
    }else if(CGSizeEqualToSize(screenSize, CGSizeMake(414.0, 896.0)) && scale == 3.0){
        return CFFScreenType_XsMax_11ProMax;
    }else if(CGSizeEqualToSize(screenSize, CGSizeMake(390.0, 844.0)) && scale == 3.0){
        return CFFScreenType_12_12Pro;
    }else if(CGSizeEqualToSize(screenSize, CGSizeMake(428.0, 926.0)) && scale == 3.0){
        return CFFScreenType_12ProMax;
    }
    return CFFScreenType_Default;
}

- (NSString *)screenTypeName {
    NSString *typeName;
    switch (self.screenType) {
        case CFFScreenType_8_SE2:
            typeName = @"CFFScreenType_8_SE2";
            break;
        case CFFScreenType_8Plus:
            typeName = @"CFFScreenType_8Plus";
            break;
        case CFFScreenType_X_Xs_11Pro_12Mini:
            typeName = @"CFFScreenType_X_Xs_11Pro_12Mini";
            break;
        case CFFScreenType_XR_11:
            typeName = @"CFFScreenType_XR_11";
            break;
        case CFFScreenType_XsMax_11ProMax:
            typeName = @"CFFScreenType_XsMax_11ProMax";
            break;
        case CFFScreenType_12_12Pro:
            typeName = @"CFFScreenType_12_12Pro";
            break;
        case CFFScreenType_12ProMax:
            typeName = @"CFFScreenType_12ProMax";
            break;
        default:
            break;
    }
    return typeName;
}

- (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (BOOL) isIPhoneXAndLater {
    if (@available(iOS 11.0, *)) {
        if (KAppWindow.safeAreaInsets.bottom > 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (CGFloat)statusBarHeight {
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
            statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

@synthesize language;
- (NSString *)language{
    NSArray *languages = [NSLocale preferredLanguages];
    language = [languages objectAtIndex:0];
    return language;
    
   /*zh-Hans-CN 简体
     zh_Hans_SG 简体新加坡
     zh_Hans_MO 简体澳门
     zh_Hans_HK 简体香港
     zh_Hant_CN 繁体
     zh_Hant_TW 繁体台湾
     zh_Hant_MO 繁体澳门
     zh_Hant_HK 繁体香港
     */
}

@synthesize isUsingChinese;
- (BOOL)isUsingChinese{
    if ([self.language hasPrefix:@"zh-Hans"]) {
        return YES;
    }else if ([self.language hasPrefix:@"zh_Hant"]){
        return YES;
    }
    return NO;
}

@end
