//
//  UIView+Exta.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "ZCSimpleButton.h"

typedef void (^ViewTapAction)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Exta)

- (UIViewController *)superViewController;

- (UILabel *)createSimpleLabelWithTitle:(NSString *)title font:(CGFloat)font bold:(BOOL)bold  color:(UIColor *)color;

- (UIButton *)createSimpleButtonWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color;

- (ZCSimpleButton *)createShadowButtonWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color;

- (void)setViewCornerRadiu:(CGFloat)radius;

- (void)setViewCornerRadius:(CGFloat)radius;

- (void)setViewBorderWithColor:(CGFloat)bordWidth color:(UIColor *)color;

- (void)setViewColorAlpha:(CGFloat)aphla color:(UIColor *)color;

- (void)setViewContentMode:(UIViewContentMode)mode;

- (void)configureViewShadowColor:(UIView *)view;

- (void)addTapGestureWithAction:(ViewTapAction)action;

- (void)setupViewRound:(UIView *)targetView corners:(UIRectCorner)corners;

- (void)configureViewColorGradient:(UIView *)view width:(CGFloat)width height:(CGFloat)height one:(UIColor *)oneColor two:(UIColor *)twoColor cornerRadius:(CGFloat)cornerRadius;

- (void)configureLeftToRightViewColorGradient:(UIView *)view width:(CGFloat)width height:(CGFloat)height one:(UIColor *)oneColor two:(UIColor *)twoColor cornerRadius:(CGFloat)cornerRadius;

- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

@end

NS_ASSUME_NONNULL_END
