//
//  ZCAlertPickerView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAlertPickerView : UIView

@property (nonatomic, copy) void(^sureRepeatOperate)(NSString *content);

@property (nonatomic,strong) UILabel *titleL;

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
