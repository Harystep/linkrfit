//
//  ZCConstantMacro.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#ifndef ZCConstantMacro_h
#define ZCConstantMacro_h

#define RGBA_COLOR(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define rgba(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB_COLOR(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define kColorHex(string) [UIColor colorWithHexString:string]
// 屏幕宽高
#define SCREEN_W    [UIScreen mainScreen].bounds.size.width
#define SCREEN_H    [UIScreen mainScreen].bounds.size.height
#define SCREEN_S    (SCREEN_W/375.0)

#define MAINWINDOW [UIApplication sharedApplication].keyWindow

#define kPlayVideoFinishKey @"kPlayVideoFinishKey"
#define kAppDidBecomeActiveKey @"kAppDidBecomeActiveKey"
#define kAppEnterBackgroundKey @"kAppEnterBackgroundKey"

// 自适应字体大小
#define AUTO_FONT_SIZE(size)           size*(SCREEN_W/375.0)
#define AUTO_SYSTEM_FONT_SIZE(size)    [UIFont systemFontOfSize:AUTO_FONT_SIZE(size)]

#define FONT_SYSTEM(size)  [UIFont systemFontOfSize:size]
#define FONT_BOLD(size)  [UIFont boldSystemFontOfSize:size]

// 自适应边距
#define AUTO_MARGIN(margin)            margin*(SCREEN_W/375.0)
#define AUTO_MARGINY(margin)            margin*(SCREEN_H/812.0)

#define checkSafeContent(content) [NSString safeStringWithConetent:content]

// 刘海屏适配判断
#define iPhone_X ((UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (UIApplication.sharedApplication.statusBarFrame.size.height > 20.0))

// iPhone4S
#define iPhone_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define STATUS_H          UIApplication.sharedApplication.statusBarFrame.size.height
#define STATUS_BAR_HEIGHT (iPhone_X ? 44.f : 20.f)

// 导航栏高度
#define NAV_BAR_HEIGHT        (STATUS_H + 44)
#define NAVIGATION_BAR_HEIGHT (iPhone_X ? 88.f : 64.f)

#define TAB_SAFE_BOTTOM (iPhone_X ? 34.0 : 0.0)
// tabBar高度
#define TAB_BAR_HEIGHT  (iPhone_X ? 83.f : 49.f)

#define kweakself(type) __weak typeof(type) weakself = type;

#define kIMAGE(imageStr)              [UIImage imageNamed:imageStr]

#define MAGIN_W ([UIScreen mainScreen].bounds.size.width / 3)

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) (void)0
#endif


#define kCFF_SCREEN_WIDTH                         ([UIScreen mainScreen].bounds.size.width)
#define kCFF_SCREEN_HEIGHT                        ([UIScreen mainScreen].bounds.size.height)
#define kCFF_SCREEN_SCALE                         ([UIScreen mainScreen].scale)
//状态栏高度
#define kCFF_STATUS_BAR_HEIGHT                    STATUS_BAR_HEIGHT
//导航栏高度
#define kCFF_NAVIGATION_BAR_HEIGHT                44

//导航栏加状态栏高度
#define kCFF_TOP_CONTENT_HEIGHT  (kCFF_STATUS_BAR_HEIGHT + kCFF_NAVIGATION_BAR_HEIGHT)

//底部安全区域高度
#define kCFF_BOTTOM_SAFE_AREA_INSET               KCFFAppWindow.safeAreaInsets.bottom

#define kCFF_COLOR_CONTENT_TITLE  RGBA_COLOR(0, 0, 0, 0.85)

#define kCFF_COLOR_SUB_TITLE  RGBA_COLOR(0, 0, 0, 0.25)

#define kCFF_BG_COLOR_GREEN_COMMON  RGB_COLOR(48, 203, 165)

#define kCFF_TEXT_COLOR_GREEN_COMMON  RGB_COLOR(48, 203, 165)

#define kCFF_COLOR_GRAY_COMMON  RGB_COLOR(244, 244, 244)

#define CFFSafeBlockRun(block, ...)         block ? block(__VA_ARGS__) : nil

#define kCFF_FILL_USER_INFO_TOP_HEIGHT  (iPhone_X ? 176 :140 )
#define kCFF_FILL_USER_INFO_BOTTOM_HEIGHT  85
//单像素线条宽度
#define kCFF_SINGLE_LINE_WIDTH                    (1/[UIScreen mainScreen].scale)

#endif /* ZCConstantMacro_h */
