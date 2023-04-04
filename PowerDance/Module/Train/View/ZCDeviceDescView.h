//
//  ZCDeviceDescView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCDeviceDescView : UIView

@property (nonatomic, copy) void (^bindDeviceOperate)(void);

@property (nonatomic, copy) void (^knowDeviceInfoOperate)(void);

@property (nonatomic,strong) NSDictionary *dataDic;

- (void)showContentView;

@end

NS_ASSUME_NONNULL_END
