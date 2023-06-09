//
//  ZCPowerStationSetLanguageView.h
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPowerStationSetLanguageView : UIView

@property (nonatomic, copy) void (^setDeviceLanguageBlock)(NSString *type);

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
