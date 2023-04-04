//
//  ZCDevice.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import <UIKit/UIKit.h>


//错误代码示例
typedef NS_ENUM(NSUInteger, CFFScreenType) {
    CFFScreenType_Default                = 1 << 0 ,
    CFFScreenType_8_SE2                  = 1 << 1,    // 375.0 X 667.0 Sclae : 2.0
    CFFScreenType_8Plus                  = 1 << 2, // 414.0 X 736.0 Sclae : 3.0
    CFFScreenType_X_Xs_11Pro_12Mini      = 1 << 3,// 375.0 X 812.0 Sclae : 3.0
    CFFScreenType_XR_11                  = 1 << 4, // 414.0 X 896.0 Sclae : 2.0
    CFFScreenType_XsMax_11ProMax         = 1 << 5,// 414.0 X 896.0 Sclae : 3.0
    CFFScreenType_12_12Pro               = 1 << 6,// 390.0 X 844.0 Sclae : 3.0
    CFFScreenType_12ProMax               = 1 << 7,// 428.0 X 926.0 Sclae : 3.0
};


@interface ZCDevice : NSObject

@property (nonatomic,copy) NSString *deviceType;

@property (nonatomic,assign) CFFScreenType screenType;
@property (nonatomic,copy) NSString *screenTypeName;

@property (nonatomic,copy) NSString *systemVersion;

@property (nonatomic,assign) BOOL isFirstTimeLaunch;

@property (nonatomic,copy,readonly) NSString *language;
@property (nonatomic,assign,readonly) BOOL isUsingChinese;


+ (instancetype)currentDevice;

+ (BOOL) isIPhoneXAndLater;

+ (CGFloat) statusBarHeight;

@end

