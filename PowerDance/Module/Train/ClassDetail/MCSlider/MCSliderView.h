//
//  MCSliderView.h
//  MCSlider
//
//  Created by M_Code on 2017/10/10.
//  Copyright © 2017年 M_Code. All rights reserved.
//
#import <UIKit/UIKit.h>
@class MCSlider;
@protocol MCSliderViewDelegate <NSObject>
- (void)sliderTouchBegan:(MCSlider * )slider;
- (void)sliderTouchDone:(MCSlider * )slider;
@end
@interface MCSliderView : UIView

@property (weak, nonatomic) id<MCSliderViewDelegate> delegate;
/**
 进度值
 */
@property (assign, nonatomic) CGFloat value;
/**
 缓冲值
 */
@property (assign, nonatomic) CGFloat middleValue;

/**
 最大值  默认 1
 */
@property (assign, nonatomic) CGFloat maxValue;

/**
 进度颜色
 */
@property (retain, nonatomic) UIColor * minimumTrackTintColor;

/**
 缓冲进度颜色
 */
@property (retain, nonatomic) UIColor * middleTrackTintColor;

/**
 显示的颜色
 */
@property (retain, nonatomic) UIColor * maximumTrackTintColor;

/**
 设置 thumb 图片

 @param image -
 @param state -
 */
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

/**
 进度条的设置

 @param image -
 @param state -
 */
- (void)setMinimumTrackImage:(nullable UIImage *)image forState:(UIControlState)state;
- (void)setMaximumTrackImage:(nullable UIImage *)image forState:(UIControlState)state;
@end
