//
//  ZCPowerStationSetUnitView.h
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPowerStationSetUnitView : UIView

@property (nonatomic, copy) void (^setDeviceUnitBlock)(NSString *type);

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
