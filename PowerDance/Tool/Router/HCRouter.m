
#import "HCRouter.h"

@implementation HCRouter

+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController {
    [viewController.navigationController pushViewController:[HBRouter openURL:url withParams:params] animated:YES];
}

+ (void)router:(NSString *)url viewController:(UIViewController *)viewController {
    [viewController.navigationController pushViewController:[HBRouter openURL:url] animated:YES];
}

+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController block:(void(^)(id value))block {
    [viewController.navigationController pushViewController:[HBRouter openURL:url withParams:params block:^(id result) {
        block(result);
    }] animated:YES];
}

+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        [viewController.navigationController pushViewController:[HBRouter openURL:url withParams:params] animated:YES];
    } else {
        [viewController.navigationController presentViewController:[HBRouter openURL:url withParams:params] animated:YES completion:nil];
    }
}

+ (void)router:(NSString *)url viewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        [viewController.navigationController pushViewController:[HBRouter openURL:url] animated:YES];
    } else {
        [viewController.navigationController presentViewController:[HBRouter openURL:url] animated:YES completion:nil];
    }
}

+ (void)router:(NSString *)url params:(NSDictionary *)params viewController:(UIViewController *)viewController animated:(BOOL)animated block:(void(^)(id value))block {
    if (animated) {
        [viewController.navigationController pushViewController:[HBRouter openURL:url withParams:params block:^(id result) {
            block(result);
        }] animated:YES];
    } else {
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[HBRouter openURL:url withParams:params block:^(id result) {
            block(result);
        }]];
        
        [viewController presentViewController:nav animated:YES completion:nil];
    }
}


@end
