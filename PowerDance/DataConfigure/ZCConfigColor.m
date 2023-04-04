//
//  ZCConfigColor.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/28.
//

#import "ZCConfigColor.h"

@implementation ZCConfigColor

+ (UIColor *)txtColor {
    return rgba(32, 33, 33, 1);
//    return kColorHex(@"#2B2A33");
}

+ (UIColor *)point8TxtColor {
    return rgba(32, 33, 33, 0.8);
//    return RGBA_COLOR(0, 0, 0, 0.25);
}

+ (UIColor *)point6TxtColor {
    return rgba(32, 33, 33, 0.6);
//    return RGBA_COLOR(0, 0, 0, 0.25);
}

+ (UIColor *)subTxtColor {
    return rgba(32, 33, 33, 0.4);
//    return RGBA_COLOR(0, 0, 0, 0.25);
}

+ (UIColor *)whiteColor {
    return UIColor.whiteColor;
}

+ (UIColor *)cyanColor {
    return rgba(138, 205, 215, 1);
}

+ (UIColor *)bgColor {
    return rgba(246, 246, 246, 1);
//    UIColor.groupTableViewBackgroundColor;
}

+ (UIColor *)fieldBgColor {
    return rgba(173, 173, 173, 1);
}

+ (NSString *)blueColor {
    return @"#6495ED";
}

@end
