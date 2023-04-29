//
//  ZCPowerStationAlertView.h
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPowerStationAlertView : UIView

@property (nonatomic, copy) NSString *nowVersion;//当前

@property (nonatomic, copy) NSString *lastVersion;//最新

@property (nonatomic, assign) NSInteger failFlag;

@property (nonatomic, assign) NSInteger successFlag;

@property (nonatomic, copy) void (^updateBlock)(void);

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
