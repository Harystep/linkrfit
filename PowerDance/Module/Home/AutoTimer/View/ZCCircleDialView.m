

#import "ZCCircleDialView.h"
#import "ZCAutoBaseCircleView.h"
#import "HFTimeWeakTarget.h"
#import "UIView+HFFrame.h"

@interface ZCCircleDialView ()<CAAnimationDelegate>

@property (nonatomic,strong) ZCAutoBaseCircleView *bigView;
    
@property (nonatomic,strong) UIButton *alertBtn;

//@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger mouseIndex;
@property (nonatomic,assign) NSInteger temMouse;

@property (nonatomic, assign) BOOL isContinuous;
@property (nonatomic, assign) BOOL isWanderSecond;//是否是游走扫秒
@property (nonatomic, assign) CGFloat secondAngel;

/// 分针
@property (nonatomic, strong) UIImageView *minuteHandImageV;

@end

@implementation ZCCircleDialView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clockFlag = YES;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIImageView *iconIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 307, 307)];
    iconIv.image = kIMAGE(@"timer_auto_dial");
    [self addSubview:iconIv];
    
    self.minuteHandImageV = [[UIImageView alloc] initWithImage:kIMAGE(@"timer_auto_secord")];
    [iconIv addSubview:self.minuteHandImageV];
    [self.minuteHandImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconIv.mas_centerX);
        make.top.mas_equalTo(iconIv.mas_top).offset(112);
    }];
    self.minuteHandImageV.layer.anchorPoint = CGPointMake(0.5f,  0.9f);
    
    self.bigView = [[ZCAutoBaseCircleView alloc] initWithFrame:CGRectMake(42.0/2.0, 42.0/2.0, 265, 265) trackWidth:16];
    [iconIv addSubview:self.bigView];
    self.bigView.progressBgColor = UIColor.clearColor;
    self.bigView.progressColor = rgba(255, 138, 59, 1);
    
    UIImageView *alertIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_alert_circle")];
    [iconIv addSubview:alertIv];
    [alertIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconIv.mas_centerX);
        make.bottom.mas_equalTo(iconIv.mas_bottom).inset(90);
    }];
    self.circleL = [self createSimpleLabelWithTitle:@"0" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [alertIv addSubview:self.circleL];
    self.circleL.textAlignment = NSTextAlignmentCenter;
    [self.circleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(alertIv);
    }];
}

- (void)startAnimal {
    
    [self tick];
    [self startAnimalOperate];
}

- (void)setClockFlag:(BOOL)clockFlag {
    _clockFlag = clockFlag;
    if (self.clockFlag == NO) {
        self.bigView.progressBgColor = rgba(255, 138, 59, 1.0);
        self.bigView.progressColor = rgba(243, 243, 243, 1);
    } else {
        self.bigView.progressBgColor = rgba(243, 243, 243, 1);
        self.bigView.progressColor = rgba(255, 138, 59, 1);
    }
}

#pragma mark -- 定时任务
- (void)tick {    
    //秒钟旋转角度
    CGFloat secsAngle = (self.mouseIndex / 36000.0) * M_PI * 2.0;
    
    CGFloat prevSecAngle = ((self.mouseIndex - 10) / 36000.0) * M_PI * 2.0;
     
    self.secondAngel = secsAngle;
    
    //提前存储秒针layer的初始位置
    [self.minuteHandImageV.layer removeAnimationForKey:@"transform"];
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani.duration = 1.0f;
    ani .removedOnCompletion= NO;
    ani.delegate = self;
    ani.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(prevSecAngle , 0, 0, 1)];
    
    ani.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(secsAngle , 0, 0, 1)];
    [self.minuteHandImageV.layer addAnimation:ani forKey:@"transform"];
    
}

#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    //防止layer动画闪动
    self.minuteHandImageV.layer.transform = CATransform3DMakeRotation (self.secondAngel, 0, 0, 1);
    //NSLog(@"animationDidStart%@",self.secondHandImageV.layer.animationKeys);

}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //防止layer动画闪动
    self.minuteHandImageV.layer.transform = CATransform3DMakeRotation (self.secondAngel, 0, 0, 1);
    //NSLog(@"animationDidStop%@",self.secondHandImageV.layer.animationKeys);
}

- (void)setTargetMouse:(NSInteger)targetMouse {
    _targetMouse = targetMouse;
    NSLog(@"targetMouse-->%tu", self.targetMouse);
}

- (void)setBackMouseIndex:(double)backMouseIndex {
    self.mouseIndex += backMouseIndex;
}

- (void)setGoBackCount:(double)goBackCount {
    _goBackCount = goBackCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (goBackCount < self.targetMouse - self.temMouse) {
            if (self.clockFlag) {
                NSLog(@"progress-->%f", 1.0/self.targetMouse);
                [self.bigView setProgress:goBackCount/self.targetMouse animated:YES startAngle:-M_PI_2 + (M_PI*0.0167) + M_PI*2*(1.0/self.targetMouse*(self.temMouse)) clockwise:self.clockFlag];
            } else {
                [self.bigView setProgress:goBackCount/self.targetMouse animated:YES startAngle:M_PI*1.5 - (M_PI*0.0167)  - (M_PI*2*(1.0/self.targetMouse*(self.temMouse))) clockwise:self.clockFlag];
            }
            self.mouseIndex = self.mouseIndex + goBackCount;
            self.temMouse = self.temMouse + goBackCount;
        } else {
            self.temMouse = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self routerWithEventName:@"" userInfo:@{}];
                [self.bigView resetLayoutSubviews];
            });
        }
    });
}

- (void)startAnimalOperate {
    self.mouseIndex ++;
    self.temMouse ++;    
    if (self.clockFlag) {        
        [self.bigView setProgress:1.0/self.targetMouse animated:YES startAngle:-M_PI_2 + (M_PI*0.0167) + M_PI*2*(1.0/self.targetMouse*(self.temMouse-1)) clockwise:self.clockFlag];
    } else {
        [self.bigView setProgress:1.0/self.targetMouse animated:YES startAngle:M_PI*1.5 - (M_PI*0.0167)  - (M_PI*2*(1.0/self.targetMouse*(self.temMouse-1))) clockwise:self.clockFlag];
    }
    if (self.temMouse == self.targetMouse) {
        self.temMouse = 0;
        self.mouseIndex = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self routerWithEventName:@"" userInfo:@{}];
            [self.bigView resetLayoutSubviews];
        });
        
    }
}

- (void)resetCircleView {
    self.temMouse = 0;
    [self.bigView resetLayoutSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.minuteHandImageV.layer.transform = CATransform3DMakeRotation (0, 0, 0, 1);
        self.mouseIndex = 0;
    });
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.bigView.progressColor = bgColor;
}

@end
