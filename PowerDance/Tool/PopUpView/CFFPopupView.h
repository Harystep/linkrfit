//
//  DRCPopupView.h
//  Pods
//
//  Created by zwz on 16/6/22.
//
//

#import <UIKit/UIKit.h>


typedef void (^DRCPopupViewFinishedBlock) ();

typedef NS_ENUM(NSUInteger, DRCPopupViewAnimationStyle) {
    DRCPopupViewAnimationStyleNone,/**< 无动画 */
    DRCPopupViewAnimationStyleFadeIn,/**< 淡入淡出 */
    DRCPopupViewAnimationStyleShowFromBottom,/**< 从底部出来 */
    DRCPopupViewAnimationStyleAlert/**< 类似AlertView的弹出效果 */
};

/**
 *  通用弹出视图，遮盖在所有view之上，可用于各种弹窗、时间选择框、查看图片页
 *  使用方法:
 *  1、继承DRCPopupView
 *  2、在init方法里设置animationStyle
 *  3、所有view绘制在contentView上
 *  4、重写“- (CGSize)contentSize”方法设置contentView尺寸。animationStyle是DRCPopupViewAnimationStyleShowFromBottom时，contentView位于底部居中，其它类型动画时位于正中心
 */
@interface CFFPopupView : UIView

@property (nonatomic,assign) DRCPopupViewAnimationStyle animationStyle;/**< 动画效果 */

@property (nonatomic,assign) BOOL   clickBackViewToHide;/**< 点击背景隐藏 默认为NO*/

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,assign) CGFloat contentViewAlpha;


/**
 *  判断当前 view 上是否有已经显示的 popupView
 */
+ (BOOL)isPopupViewShowInView:(UIView *)view;

/**
 *  获取当前 view 上的 popupView
 */
+ (CFFPopupView *)currentPopupViewInView:(UIView *)view;

- (void)showInView:(UIView *)view;/**< superView 传nil则默认显示在当前 window */

- (void)dismissImmediately ;

- (void)dismissViewFinished:(DRCPopupViewFinishedBlock)block;

@end
