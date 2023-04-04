//
//  ZCCustomRestMouseView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCustomRestMouseView : UIView

@property (nonatomic, copy) void(^sureRepeatOperate)(NSString *content);

@property (nonatomic,strong) UILabel *titleL;

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
