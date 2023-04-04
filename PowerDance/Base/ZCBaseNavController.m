//
//  ZCBaseNavController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "ZCBaseNavController.h"

@interface ZCBaseNavController ()

@end

@implementation ZCBaseNavController

#pragma mark : life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark : override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        // push 时隐藏 tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (animated) {
        UIViewController *popController = self.viewControllers.lastObject;
        popController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

@end
