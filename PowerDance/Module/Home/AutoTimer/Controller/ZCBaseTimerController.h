//
//  ZCBaseTimerController.h
//  PowerDance
//
//  Created by PC-N121 on 2022/5/26.
//

#import "ZCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCBaseTimerController : ZCBaseViewController

@property (nonatomic,strong) NSDate *goBackgroundDate;

@property (nonatomic,assign) NSInteger signEndFlag;//标记切出页面

- (void)addBackgroundNotification;
- (void)removeBackgroundNotification;

- (void)appEnterBackground;

- (void)appBecomeActive;

@end

NS_ASSUME_NONNULL_END
