

#import <Foundation/Foundation.h>
#import "HBRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCRouter : NSObject

/**
 传递路由消息 -- 无参

 @param url 传递消息的接口
 @param viewController 当前控制器
 */
+ (void)router:(NSString *)url viewController:(UIViewController *)viewController;

/**
 传递路由消息 -- 带参数

 @param url 传递消息的接口
 @param params 传递消息的参数
 @param viewController 当前控制器
 */
+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController;


/**
 传递路由消息 -- 带参数和回调

 @param url 传递消息的接口
 @param params 传递消息的参数
 @param viewController 当前控制器
 @param block 传递消息的回调
 */
+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController block:(void(^)(id value))block;

+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (void)router:(NSString *)url viewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController animated:(BOOL)animated block:(void(^)(id value))block;

@end

NS_ASSUME_NONNULL_END
