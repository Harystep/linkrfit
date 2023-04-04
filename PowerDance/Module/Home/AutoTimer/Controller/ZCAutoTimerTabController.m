//
//  ZCAutoTimerTabController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoTimerTabController.h"
#import "ZCAutoTimerDownController.h"
#import "ZCAutoTimerSWController.h"
#import "ZCBaseNavController.h"
#import "ZCAutoTimerUpCountController.h"

@interface ZCAutoTimerTabController ()

@end

@implementation ZCAutoTimerTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    }
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_W, TAB_BAR_HEIGHT);
    view.backgroundColor = UIColor.whiteColor;
    [[UITabBar appearance] insertSubview:view atIndex:0];
    self.tabBar.clipsToBounds = YES;
    [self setupChildControllers];
}


// 添加 tabBar 子控制器
- (void)setupChildControllers {
    
    ZCAutoTimerUpCountController   *upVc  = [[ZCAutoTimerUpCountController alloc] init];
//    ZCBaseNavController *upNav = [[ZCBaseNavController alloc] initWithRootViewController:upVc];
    [self setupChildViewController:upVc title:NSLocalizedString(@"正计时", nil) imageName:@"timer_up_count" seleceImageName:@"timer_up_count"];
    
    ZCAutoTimerDownController   *downVc  = [[ZCAutoTimerDownController alloc] init];
//    ZCBaseNavController *downNav = [[ZCBaseNavController alloc] initWithRootViewController:downVc];
    [self setupChildViewController:downVc title:NSLocalizedString(@"倒计时", nil) imageName:@"timer_down_count" seleceImageName:@"timer_down_count"];
    
    ZCAutoTimerSWController   *swVc  = [[ZCAutoTimerSWController alloc] init];
//    ZCBaseNavController *swNav = [[ZCBaseNavController alloc] initWithRootViewController:swVc];
    [self setupChildViewController:swVc title:NSLocalizedString(@"秒表", nil) imageName:@"timer_stopwatch_count" seleceImageName:@"timer_stopwatch_count"];
        
    self.viewControllers = @[upVc, downVc, swVc]; 
    
}

- (UIImage *)convertImageAlpha:(UIImage *)image {
    return image;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName {
    
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageByApplyingAlpha:0.3 image:[UIImage imageNamed:imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
//    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    if (@available(iOS 13.0, *)) {
        self.tabBar.unselectedItemTintColor = RGBA_COLOR(0, 0, 0, 0.5);//未选中时文字颜色
        self.tabBar.tintColor = RGBA_COLOR(0, 0, 0, 1);//选中时文字颜色
    } else {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBA_COLOR(0, 0, 0, 1)} forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBA_COLOR(0, 0, 0, 0.5)} forState:UIControlStateNormal];
    }
}

@end
