//
//  CFFBluetoothStatusView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BluetoothConnectStatusClosed = 0,
    BluetoothConnectStatusIng,
    BluetoothConnectStatusOk,
} BluetoothConnectStatus;

typedef enum : NSUInteger {
    SmartDeviceTypeScale = 0,
    SmartDeviceTypeRuler,
    SmartDeviceTypeCloud,
} SmartDeviceType;

@interface CFFBluetoothStatusView : UIView

@property (nonatomic,assign) SmartDeviceType deviceType;
@property (nonatomic,assign) BluetoothConnectStatus type;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) void(^BluetoothConnectOperate)(void);
-(void)loopBasecAnimation;
-(void)showStatusView;
-(void)hideStatusView;

@end

NS_ASSUME_NONNULL_END
