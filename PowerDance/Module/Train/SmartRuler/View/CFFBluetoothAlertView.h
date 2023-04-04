//
//  CFFBluetoothAlertView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFBluetoothAlertView : UIView

@property (nonatomic, copy) void(^BlueConnectAttempt)(void);

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,assign) NSInteger type;

- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
