//
//  ZCBaseTimerController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/26.
//

#import "ZCBaseTimerController.h"

@interface ZCBaseTimerController ()

@end

@implementation ZCBaseTimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addBackgroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:kAppEnterBackgroundKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:kAppDidBecomeActiveKey object:nil];
}

- (void)removeBackgroundNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAppEnterBackgroundKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAppDidBecomeActiveKey object:nil];
}

- (void)appEnterBackground {}

- (void)appBecomeActive {}

@end
