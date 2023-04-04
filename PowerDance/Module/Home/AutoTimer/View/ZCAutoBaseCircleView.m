//
//  ZCAutoBaseCircleView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoBaseCircleView.h"

@interface ZCAutoBaseCircleView ()
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;      //背景图层
@property (nonatomic, strong) CAShapeLayer *preFrontFillLayer;       //用来填充的图层

@property (nonatomic, assign) CGFloat      trackWidth;    //导轨宽度
@property (nonatomic, assign) CGFloat      width;        //圆环宽度

@property (nonatomic,strong) NSMutableArray *layerArr;

@end

@implementation ZCAutoBaseCircleView

#pragma mark -- initialization 初始化
- (instancetype)initWithFrame:(CGRect)frame trackWidth:(CGFloat)trackWidth
{
    if (self = [super initWithFrame:frame])
    {
        _trackWidth = trackWidth;
        _width = frame.size.width;
        
        [self setupSubviews];
    }
    return self;

}

#pragma mark -- setupSubviews 创建子视图
- (void)setupSubviews
{
    //创建背景图层
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = nil;

    //创建填充图层
    _frontFillLayer = [CAShapeLayer layer];
    _frontFillLayer.fillColor = nil;
    _frontFillLayer.lineCap = kCALineCapSquare;
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_frontFillLayer];
    
    //设置颜色
    _frontFillLayer.strokeColor  = [UIColor colorWithRed:218/255.0 green:165/255.0 blue:32/255.0 alpha:1.0].CGColor;
    _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
  
}

- (void)resetLayoutSubviews {
    
    for (CAShapeLayer *layer in self.layerArr) {
        [layer removeFromSuperlayer];
    }
    [self.layerArr removeAllObjects];
}

-(void)layoutSubviews {

    [super layoutSubviews];
    CGFloat width = self.width;
    UIBezierPath *backgroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)- self.trackWidth)/2.f startAngle:0 endAngle:M_PI*2
                                                       clockwise:YES];
    _backgroundLayer.path = backgroundBezierPath.CGPath;
    
    //设置线宽
    _frontFillLayer.lineWidth = self.trackWidth;
    _backgroundLayer.lineWidth = self.trackWidth;
}

#pragma mark -- setter方法
- (void)setProgressColor:(UIColor *)progressColor{
    
    _progressColor              = progressColor;
    _frontFillLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressBgColor:(UIColor *)progressBgColor{
    
    _progressBgColor             = progressBgColor;
    _backgroundLayer.strokeColor = progressBgColor.CGColor;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO startAngle:-M_PI_2 clockwise:NO];

}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    [self setProgress:progress animated:animated startAngle:-M_PI_2 clockwise:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated startAngle:(CGFloat )startAngle clockwise:(BOOL)clockwise {
    progress = MAX(MIN(progress, 1.0), 0.0);
     _progress = progress;
    CGFloat width = self.width;
    CAShapeLayer *frontFillLayer = [CAShapeLayer layer];
    self.preFrontFillLayer = frontFillLayer;
    frontFillLayer.fillColor = nil;
    frontFillLayer.lineCap = kCALineCapSquare;
    frontFillLayer.strokeColor = self.progressColor.CGColor;
    frontFillLayer.lineWidth = self.trackWidth;
    [self.layerArr addObject:frontFillLayer];
    CGFloat endAngle = startAngle + (clockwise?(2*M_PI)*progress:(-2*M_PI)*progress);
    UIBezierPath *frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-self.trackWidth)/2.f startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    frontFillLayer.path = frontFillBezierPath.CGPath;
    if (animated) {
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basicAnimation.duration = 0.1;//动画时间
        basicAnimation.fromValue=[NSNumber numberWithInteger:0];
        basicAnimation.toValue=[NSNumber numberWithInteger:1];
        [frontFillLayer addAnimation:basicAnimation forKey:@"strokeKey"];
    }
    [self.layer addSublayer:frontFillLayer];
}

- (NSMutableArray *)layerArr {
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    return _layerArr;
}

@end
