

#import <UIKit/UIKit.h>

@interface HBRouter : NSObject

/**
 读取plist的注册表

 @param plistName 如“HBRouter.plist”
 */
+ (void)loadConfigPlist:(NSString *)plistName;


/**
 注册单个URL

 @param route URL
 @param controllerClass [UIViewController]
 */
+ (void)regist:(NSString *)route toControllerClass:(Class)controllerClass;

+ (UIViewController *)openURL:(NSString *)URL;

+ (UIViewController *)openURL:(NSString *)URL withParams:(NSDictionary *)params;

+ (UIViewController *)openURL:(NSString *)URL withParams:(NSDictionary *)params block:(void (^)(id result))block;

+ (BOOL)canOpenURL:(NSString *)URL;


@end

/**
 用于传值的category
 */
@interface UIViewController (HBRouter)

typedef void(^HBCallBackBlock)(id callObject);

@property (nonatomic, copy) HBCallBackBlock callBackBlock;

@property (nonatomic, strong) NSDictionary *params;


@end
