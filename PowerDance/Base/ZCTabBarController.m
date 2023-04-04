//
//  ZCTabBarController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "ZCTabBarController.h"
#import "ZCCourseController.h"
#import "ZCShopController.h"
#import "ZCBaseNavController.h"
#import "ZCHomeController.h"
#import "ZCPersonalCenterController.h"

@interface ZCTabBarController ()<UITabBarControllerDelegate>

@end

@implementation ZCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    }
    self.delegate = self;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_W, TAB_BAR_HEIGHT);
    view.backgroundColor = UIColor.whiteColor;
    [[UITabBar appearance] insertSubview:view atIndex:0];
    self.tabBar.clipsToBounds = YES;
    [self setupChildControllers];
        
}


// 添加 tabBar 子控制器
- (void)setupChildControllers {
    ZCHomeController   *trainVc  = [[ZCHomeController alloc] init];
    ZCBaseNavController *trainNav = [[ZCBaseNavController alloc] initWithRootViewController:trainVc];
    [self setupChildViewController:trainVc title:NSLocalizedString(@"练氪", nil) imageName:@"tabbar_home_nor" seleceImageName:@"tabbar_home_sel"];
    
    ZCCourseController   *classVc  = [[ZCCourseController alloc] init];
    ZCBaseNavController *classNav = [[ZCBaseNavController alloc] initWithRootViewController:classVc];
    [self setupChildViewController:classNav title:NSLocalizedString(@"课程", nil) imageName:@"tabbar_class_nor" seleceImageName:@"tabbar_class_sel"];
    
    ZCShopController   *shopVc  = [[ZCShopController alloc] init];
    ZCBaseNavController *shopNav = [[ZCBaseNavController alloc] initWithRootViewController:shopVc];
    [self setupChildViewController:shopVc title:NSLocalizedString(@"商城", nil) imageName:@"tabbar_shop_nor" seleceImageName:@"tabbar_shop_sel"];
    
    ZCPersonalCenterController   *myVc  = [[ZCPersonalCenterController alloc] init];
    ZCBaseNavController *myNav = [[ZCBaseNavController alloc] initWithRootViewController:myVc];
    [self setupChildViewController:myVc title:NSLocalizedString(@"我的", nil) imageName:@"tabbar_my_nor" seleceImageName:@"tabbar_my_sel"];
        
    self.viewControllers = @[trainNav, classNav, shopNav, myNav];
    self.selectedIndex = 0;
}

- (UIImage *)convertImageAlpha:(UIImage *)image {
    return image;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName {
    
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageByApplyingAlpha:1.0 image:[UIImage imageNamed:imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
//    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    if (@available(iOS 13.0, *)) {
        [ZCConfigColor txtColor];
        self.tabBar.unselectedItemTintColor = rgba(32, 33, 33, 0.4);//未选中时文字颜色
        self.tabBar.tintColor = [ZCConfigColor txtColor];//选中时文字颜色
    } else {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [ZCConfigColor txtColor]} forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : rgba(32, 33, 33, 0.4)} forState:UIControlStateNormal];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 3) {
        if ([ZCUserInfo shareInstance].token == nil) {
            [ZCDataTool loginOut];
        }
    }
}

@end
