//
//  SYBUpdateVersionView.h
//  CashierChoke
//
//  Created by warmStep on 2021/7/19.
//  Copyright © 2021 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFUpdateVersionView : UIView

@property (nonatomic,   copy) void(^confirmBlock)(void);
@property (nonatomic,   copy) void(^cancelBlock)(void);

/* 标题 */
@property (nonatomic,   copy) NSString *title;
/* 描述 */
@property (nonatomic,   copy) NSString *message;
/* 取消按钮title */
@property (nonatomic,   copy) NSString *cancleTitle;
/* 确定按钮title */
@property (nonatomic,   copy) NSString *confirmTitle;
/* 标题字体颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/* 描述字体颜色 */
@property (nonatomic, strong) UIColor *messageColor;
/* 取消按钮title字体颜色 */
@property (nonatomic, strong) UIColor *cancelTitleColor;
/* 确定按钮title字体颜色 */
@property (nonatomic, strong) UIColor *confirmTitleColor;
/* 确定按钮背景颜色 */
@property (nonatomic, strong) UIColor *confirmBackgroundColor;

/// 提示信息文本
@property (nonatomic, strong) UILabel  *alertMessage;
@property (nonatomic, strong) UILabel  *alertTitle;

/* 隐藏取消按钮 */
@property (nonatomic, assign) BOOL hideCancelBtn;

/* 显示alertView */
- (void)showAlertView;
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
