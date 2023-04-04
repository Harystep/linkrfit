//
//  ZCTimerModeView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TimerConnectStatusNot = 0,
    TimerConnectStatusSuccess = 1,
} TimerConnectStatus;

NS_ASSUME_NONNULL_BEGIN

@interface ZCTimerModeView : UIView

@property (nonatomic,assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
