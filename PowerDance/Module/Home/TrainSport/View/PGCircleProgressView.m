

#import "PGCircleProgressView.h"

#define kDuration 1.0
#define kDefaultLineWidth 10

@interface PGCircleProgressView()

@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
//@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,assign) CGFloat sumSteps;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation PGCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self createSubViews];
        //init default variable
        self.backgroundLineWidth = kDefaultLineWidth;
        self.progressLineWidth = kDefaultLineWidth;
        self.percentage = 0;
        self.offset = 0;
        self.sumSteps = 0;
        self.step = 0.1;
    }
    return self;
}

- (void)createSubViews
{
    self.progressLabel.text = @"0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:25 weight:0.4];
//    [self addSubview:self.progressLabel];

    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.frame = self.bounds;
    _backgroundLayer.fillColor = nil;
    _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;

    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = nil;
//    _progressLayer.strokeColor = [UIColor redColor].CGColor;

    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_progressLayer];
}

- (void)setProgressLayer:(CAShapeLayer *)progressLayer {
    _progressLayer = progressLayer;
    [self.layer addSublayer:self.progressLayer];
}

#pragma mark - draw circleLine
- (void)setBackgroundCircleLine
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)
                                          radius:(self.frame.size.width - _backgroundLineWidth)/2 - _offset
                                      startAngle:0
                                        endAngle:M_PI*2
                                       clockwise:YES];

    _backgroundLayer.path = path.CGPath;
}

- (void)setProgressCircleLine
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)
                                          radius:(self.frame.size.width - _progressLineWidth)/2 - _offset
                                      startAngle:-M_PI_2
                                        endAngle:-M_PI_2 + M_PI *2
                                       clockwise:YES];

    _progressLayer.path = path.CGPath;
}

#pragma mark -setter and get method
- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width -100)/2, (self.bounds.size.height - 100)/2, 100, 100)];
    }
    return _progressLabel;
}

- (void)setDigitTintColor:(UIColor *)digitTintColor
{
    _digitTintColor = digitTintColor;
    _progressLabel.textColor = _digitTintColor;
}

- (void)setBackgroundLineWidth:(CGFloat)backgroundLineWidth
{
    _backgroundLineWidth = backgroundLineWidth;
    _backgroundLayer.lineWidth = _backgroundLineWidth;
    [self setBackgroundCircleLine];
}

- (void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
    _progressLayer.lineWidth = _progressLineWidth;
    [self setProgressCircleLine];
}

- (void)setPercentage:(CGFloat)percentage
{
    _percentage = percentage;
}

- (void)setBackgroundStrokeColor:(UIColor *)backgroundStrokeColor
{
    _backgroundStrokeColor = backgroundStrokeColor;
    _backgroundLayer.strokeColor = _backgroundStrokeColor.CGColor;
}

- (void)setProgressStrokeColor:(UIColor *)progressStrokeColor
{
    _progressStrokeColor = progressStrokeColor;
    _progressLayer.strokeColor = _progressStrokeColor.CGColor;
}

#pragma mark - progress animated YES or NO
- (void)setProgress:(CGFloat)percentage animated:(BOOL)animated
{
    self.percentage = percentage;
    _progressLayer.strokeEnd = _percentage;
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:_percentage];
        animation.duration = kDuration;
        [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction commit];
    }
}

- (void)setProgress:(CGFloat)percentage normal:(CGFloat)oldPercent animated:(BOOL)animated {
    self.percentage = percentage;
    _progressLayer.strokeEnd = _percentage;
    if (oldPercent > 0.0) {
        _progressLayer.strokeStart = oldPercent;
    }
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:oldPercent];
        animation.toValue = [NSNumber numberWithFloat:_percentage];
        animation.duration = kDuration;
        [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction commit];
    }
}

@end
