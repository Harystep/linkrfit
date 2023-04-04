//
//  ZCDeviceConnectAlertView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCDeviceConnectAlertView : UIView

@property (nonatomic, copy) void(^BlueConnectAttempt)(void);

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *alertL;

@property (nonatomic, copy) NSString *titleStr;

- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
