//
//  DRCPopupView.m
//  Pods
//
//  Created by zwz on 16/6/22.
//
//

#import "CFFPopupView.h"
#import "UIView+Positon.h"

#define ZCSafeBlockRun(block, ...)         block ? block(__VA_ARGS__) : nil

#define kDRC_POPUPVIEW_BACK_ALPHA                    0.2/**< 背景透明度 */
#define kDRC_POPUPVIEW_ANIMATION_DURATION            0.3/**< 动画持续时间 */
#define kDRC_POPUPVIEW_ANIMATION_DURATION_ALERT_SHOW 0.3/**< ALERT弹窗效果弹出动画持续时间 */
#define kDRC_POPUPVIEW_ANIMATION_DURATION_ALERT_HIDE 0.2/**< ALERT弹窗效果隐藏动画持续时间 */



@interface CFFPopupView ()

@property (nonatomic,strong) UIView  *backView;

@property (nonatomic,assign) CGRect  frameBeforeAnimation;
@property (nonatomic,assign) CGRect  frameOriginal;

@property (nonatomic,assign) CGFloat animationDuration;
@property (nonatomic,assign) CGFloat backViewAlpha;

@property (nonatomic,assign) CGSize  contentSize;




@end

@implementation CFFPopupView

#pragma mark - init

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clickBackViewToHide = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [[[tap rac_gestureSignal]takeUntil:[self rac_willDeallocSignal]]
         subscribeNext:^(id x) {
             @strongify(self);
             if (self.clickBackViewToHide) {
                 [self dismissViewFinished:nil];
             }
         }];
        [self.backView addGestureRecognizer:tap];
        
        [self addSubview:self.contentView];
        self.contentViewAlpha = 1;
        self.contentView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    }
    return self;
}

#pragma mark - view

/**
 *  获取可用的 superView
 */
+ (UIView *)availableSuperView:(UIView *)view{
    UIView *superView;
    if (view) {
        superView = view;
    } else {
        superView = [[UIApplication sharedApplication].delegate window];;
    }
    return superView;
}

/**
 *  判断当前 view 上是否有已经显示的 popupView
 */
+ (BOOL)isPopupViewShowInView:(UIView *)view{
    UIView *superView = [[self class] availableSuperView:view];
    for (UIView *subView in superView.subviews) {
        if ([subView isKindOfClass:[CFFPopupView class]]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  获取当前 view 上的 popupView
 */
+ (CFFPopupView *)currentPopupViewInView:(UIView *)view{
    if ([[self class] isPopupViewShowInView:view]) {
        UIView *superView = [[self class] availableSuperView:view];
        for (UIView *subView in superView.subviews) {
            if ([subView isKindOfClass:[CFFPopupView class]]) {
                return (CFFPopupView *)subView;
            }
        }
    }
    return nil;
}

#pragma mark show & dimiss

- (void)showInView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *superView = [[self class] availableSuperView:view];
        self.frame = superView.bounds;
        self.backView.frame = superView.bounds;
        [superView addSubview:self];
        
        switch (self.animationStyle) {
            case DRCPopupViewAnimationStyleNone:{
                self.backView.alpha = self.backViewAlpha;
                self.contentView.size = self.contentSize;
                self.contentView.center = CGPointMake(self.width / 2, self.height / 2);
            }break;
            case DRCPopupViewAnimationStyleFadeIn:{
                self.contentView.size = self.contentSize;
                self.contentView.center = CGPointMake(self.width / 2, self.height / 2);
                self.contentView.alpha = 0;
                [UIView animateWithDuration:self.animationDuration animations:^{
                    self.backView.alpha = self.backViewAlpha;
                    self.contentView.alpha = self.contentViewAlpha;
                }completion:nil];
            }break;
            case DRCPopupViewAnimationStyleShowFromBottom:{
                self.frameOriginal = CGRectMake((self.width - self.contentSize.width) / 2,
                                            self.y + self.height - self.contentSize.height,
                                            self.contentSize.width,
                                            self.contentSize.height);
                self.frameBeforeAnimation = self.frameOriginal;
                self->_frameBeforeAnimation.origin.y = self.y + self.height;
                
                self.contentView.frame = self.frameBeforeAnimation;
                [UIView animateWithDuration:self.animationDuration animations:^{
                    self.backView.alpha = self.backViewAlpha;
                    self.contentView.frame = self.frameOriginal;
                }completion:nil];
            }break;
            case DRCPopupViewAnimationStyleAlert:{
                self.contentView.size = self.contentSize;
                self.contentView.center = CGPointMake(self.width / 2, self.height / 2);
                [UIView animateWithDuration:kDRC_POPUPVIEW_ANIMATION_DURATION_ALERT_SHOW animations:^{
                    self.backView.alpha = self.backViewAlpha;
                }completion:nil];
                
                [self showAlertAnimation];
            }break;
                
            default:{
                
            }break;
        }
    });
}

- (void)dismissImmediately {
    [self removeFromSuperview];
}

- (void)dismissViewFinished:(DRCPopupViewFinishedBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (self.animationStyle) {
            case DRCPopupViewAnimationStyleNone:{
                ZCSafeBlockRun(block);
                [self removeFromSuperview];
            }break;
            case DRCPopupViewAnimationStyleFadeIn:{
                self.contentView.alpha = 1;
                [UIView animateWithDuration:self.animationDuration animations:^{
                    self.backView.alpha = 0;
                    self.contentView.alpha = 0;
                }completion:^(BOOL finished) {
                    ZCSafeBlockRun(block);
                    [self removeFromSuperview];
                }];
            }break;
            case DRCPopupViewAnimationStyleShowFromBottom:{
                [UIView animateWithDuration:self.animationDuration animations:^{
                    self.backView.alpha = 0;
                    self.contentView.frame = self.frameBeforeAnimation;
                } completion:^(BOOL finished) {
                    ZCSafeBlockRun(block);
                    [self removeFromSuperview];
                }];
                
            }break;
            case DRCPopupViewAnimationStyleAlert:{
                [self dismissAlertAnimation];
                [UIView animateWithDuration:kDRC_POPUPVIEW_ANIMATION_DURATION_ALERT_HIDE animations:^{
                    self.backView.alpha = 0;
                    self.contentView.alpha = 0;
                }completion:^(BOOL finished) {
                    ZCSafeBlockRun(block);
                    [self removeFromSuperview];
                }];
            }break;
                
            default:{
                
            }break;
        }
    });
}

#pragma mark - alert animation

- (void)showAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = kDRC_POPUPVIEW_ANIMATION_DURATION_ALERT_SHOW;
    
    [self.contentView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = kDRC_POPUPVIEW_ANIMATION_DURATION_ALERT_HIDE;
    
    [self.contentView.layer addAnimation:animation forKey:@"dismissAlert"];
}

#pragma mark - override

/**
 *  动画持续时间，可被子类重写
 */
- (CGFloat)animationDuration{
    return kDRC_POPUPVIEW_ANIMATION_DURATION;
}

/**
 *  背景透明度，可被子类重写
 */
- (CGFloat)backViewAlpha{
    return kDRC_POPUPVIEW_BACK_ALPHA;
}

/**
 *  content size 需被子类实现
 */
- (CGSize)contentSize{
    return CGSizeMake(100, 100);
}

#pragma mark - lazy load

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

@end
