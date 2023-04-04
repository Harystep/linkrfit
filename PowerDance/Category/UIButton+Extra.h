//
//  UIButton+Extra.h
//  DNProject
//
//  Created by zjs on 2019/1/16.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TouchHandler)(void);

typedef NS_ENUM(NSInteger, DNEdgeInsetStyle) {
    
    // 图片在上，文字在下
    DNEdgeInsetStyleTop = 0,
    // 图片在左，文字在右
    DNEdgeInsetStyleLeft,
    // 图片在下，文字在上
    DNEdgeInsetStyleBottom,
    // 图片在右，文字在左
    DNEdgeInsetStyleRight
};

@interface UIButton (Extra)

/**
 @brief 按钮的点击事件

 @param handler 点击事件的回调
 */
- (void)dn_selectorEvenHandler:(TouchHandler)handler;

- (void)dn_selectorEvent:(UIControlEvents)events handler:(TouchHandler)handler;


- (void)dn_layoutButtonEdgeInset:(DNEdgeInsetStyle)style space:(CGFloat)space;

/**
 @brief 按钮倒计时

 @param timeDown 倒计时时长
 */
- (void)dn_timeDown:(NSInteger)timeDown;

- (void)dn_timeDown:(NSInteger)timeDown downStr:(NSString *)downStr finishStr:(NSString *)finishStr;

- (void)configureButtonImage:(NSString *)imageStr selImage:(NSString *)selImageStr;

@end

NS_ASSUME_NONNULL_END
