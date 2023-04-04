//
//  MCSliderView.m
//  MCSlider
//
//  Created by M_Code on 2017/10/10.
//  Copyright © 2017年 M_Code. All rights reserved.
//

#import "MCSliderView.h"
#import "MCSlider.h"
#import "MCProgressView.h"
#import "Masonry.h"
@interface MCSliderView () <MCSliderDelegate>
@property (retain, nonatomic) MCSlider * slider;
@property (retain, nonatomic) MCProgressView * progressView;
@end
@implementation MCSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _slider = [[MCSlider alloc] initWithFrame:self.bounds];
        _slider.thumbTintColor = UIColor.clearColor;
        _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _slider.maximumTrackTintColor = [UIColor clearColor];
        [_slider addTarget:self action:@selector(sliderTouchBegan:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchDone:) forControlEvents:UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(sliderTouchDone:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_slider];
        _progressView = [[MCProgressView alloc]init];
        _progressView.userInteractionEnabled = NO;
        _progressView.proColor = [UIColor darkGrayColor];
        _progressView.surColor = [UIColor lightGrayColor];
//        _progressView.layer.cornerRadius = MCSliderLineHeight/2.0f;
//        _progressView.layer.masksToBounds = YES;
        [_slider addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(MCSliderLineHeight);
            make.top.mas_equalTo(_slider.lineTop);
            make.left.equalTo(_slider);
            make.right.equalTo(_slider);
        }];
        _slider.delegate = self;
    }
    return self;
}
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state {
    [self.slider setThumbImage:image forState:state];
}
- (void)setMinimumTrackImage:(nullable UIImage *)image forState:(UIControlState)state
{
    [self.slider setMinimumTrackImage:image forState:state];
}
- (void)setMaximumTrackImage:(nullable UIImage *)image forState:(UIControlState)state
{
    [self.slider setMaximumTrackImage:image forState:state];
}
- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    [self.slider setMinimumTrackTintColor:minimumTrackTintColor];
}
- (void)setMiddleTrackTintColor:(UIColor *)middleTrackTintColor {
    self.progressView.proColor = middleTrackTintColor;
}
- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    self.progressView.surColor = maximumTrackTintColor;
}
- (void)setValue:(CGFloat)value
{
    self.slider.value = value;
}
- (CGFloat)value
{
    return self.slider.value;
}
- (void)setMiddleValue:(CGFloat)middleValue
{
    self.progressView.progress = middleValue;
}
- (CGFloat)middleValue
{
    return self.progressView.progress;
}
- (void)setMaxValue:(CGFloat)maxValue
{
    if (isnan(maxValue)) {
        return;
    }
    self.slider.maximumValue = maxValue;
}
- (CGFloat)maxValue
{
    return self.slider.maximumValue;
}
#pragma mark - 事件处理
- (void)sliderTouchBegan:(MCSlider * )slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [_delegate sliderTouchBegan:slider];
    }
}
- (void)sliderTouchDone:(MCSlider * )slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(sliderTouchDone:)]) {
        [_delegate sliderTouchDone:slider];
    }
}
#pragma mark - MCSliderDelegate
- (void)updateSliderFrame:(CGRect)rect
{
   
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.slider.lineTop);
        make.left.equalTo(self.slider);
        make.right.equalTo(self.slider);
    }];
}
@end
