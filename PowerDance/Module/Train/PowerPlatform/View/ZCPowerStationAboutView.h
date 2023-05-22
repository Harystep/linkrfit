//
//  ZCPowerStationAboutView.h
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPowerStationAboutView : UIView

@property (nonatomic,strong) UILabel *systemL;//系统版本
@property (nonatomic,strong) UILabel *driveL;//序列号

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
