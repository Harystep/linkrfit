//
//  ZCPowerStationSetView.h
//  PowerDance
//
//  Created by oneStep on 2023/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPowerStationSetView : UIView

@property (nonatomic, copy) void(^sureRepeatOperate)(NSString *content);

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) NSArray *configureArr;

@property (nonatomic,copy) NSString *defValue;;

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
