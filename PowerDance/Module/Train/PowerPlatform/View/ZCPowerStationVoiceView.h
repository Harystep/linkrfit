//
//  ZCPowerStationVoiceView.h
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPowerStationVoiceView : UIView

@property (nonatomic, copy) void (^setDeviceVoiceBlock)(NSString *type);

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
