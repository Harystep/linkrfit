//
//  UIView+Exta.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/28.
//

#import "UIView+Exta.h"

@implementation UIView (Exta)

- (UILabel *)createSimpleLabelWithTitle:(NSString *)title font:(CGFloat)font bold:(BOOL)bold  color:(UIColor *)color {
    UILabel *lb = [[UILabel alloc] init];
    if (title != nil) {
        lb.text = title;
    }
    lb.textColor = color;
    if (bold) {
        lb.font = FONT_BOLD(font);
    } else {
        lb.font = FONT_SYSTEM(font);
    }
    return lb;
}

- (UIButton *)createSimpleButtonWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color {
    UIButton *bt = [[UIButton alloc] init];
    if (title != nil) {
        [bt setTitle:title forState:UIControlStateNormal];
    }
    [bt setTitleColor:color forState:UIControlStateNormal];
    bt.titleLabel.font = FONT_SYSTEM(font);
    return bt;
}

- (ZCSimpleButton *)createShadowButtonWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color {
    ZCSimpleButton *bt = [[ZCSimpleButton alloc] init];
    if (title != nil) {
        [bt setTitle:title forState:UIControlStateNormal];
    }
    [bt setTitleColor:color forState:UIControlStateNormal];
    bt.titleLabel.font = FONT_SYSTEM(font);
    return bt;
}

- (void)setViewCornerRadiu:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setViewCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setViewBorderWithColor:(CGFloat)bordWidth color:(UIColor *)color {
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = bordWidth;
}

- (void)setViewColorAlpha:(CGFloat)alpha color:(UIColor *)color {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.backgroundColor = color;
    bgView.alpha = alpha;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UIViewController *)superViewController {
    
    for (UIView * next = self.superview; next; next = next.superview) {
        
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setViewContentMode:(UIViewContentMode)mode {
    self.contentMode = mode;
    self.layer.masksToBounds = YES;
}

- (void)configureViewShadowColor:(UIView *)view {
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, targetView.width, targetView.height);

    view.layer.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 10;
    view.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.shadowOffset = CGSizeMake(-6,-5);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 10;
//    [targetView addSubview:view];

//    UIView *viewShadow1 = [[UIView alloc] init];
//    viewShadow1.frame = CGRectMake(0,0,targetView.width,targetView.height);
    
    view.layer.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 10;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    view.layer.shadowOffset = CGSizeMake(6,10);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 10;
//    [targetView addSubview:viewShadow1];
    
}

- (void)addTapGestureWithAction:(ViewTapAction)action {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 1;
    [[[tapGesture rac_gestureSignal] takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id x) {
        CFFSafeBlockRun(action);
     }];
    [self addGestureRecognizer:tapGesture];
}

- (void)setupViewRound:(UIView *)targetView corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds byRoundingCorners:corners
    cornerRadii:CGSizeMake(AUTO_MARGIN(16), AUTO_MARGIN(16))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = targetView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    targetView.layer.mask = maskLayer;
    
}

- (void)configureViewColorGradient:(UIView *)view width:(CGFloat)width height:(CGFloat)height one:(UIColor *)oneColor two:(UIColor *)twoColor cornerRadius:(CGFloat)cornerRadius {
    UIColor *colorOne = oneColor;
    UIColor *colorTwo = twoColor;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, width, height);
    gradient.cornerRadius = cornerRadius;
    [view.layer insertSublayer:gradient atIndex:0];
}

- (void)configureLeftToRightViewColorGradient:(UIView *)view width:(CGFloat)width height:(CGFloat)height one:(UIColor *)oneColor two:(UIColor *)twoColor cornerRadius:(CGFloat)cornerRadius {
    UIColor *colorOne = oneColor;
    UIColor *colorTwo = twoColor;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, width, height);
    gradient.cornerRadius = cornerRadius;
    [view.layer insertSublayer:gradient atIndex:0];
}


/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    [shapeLayer setBounds:lineView.bounds];

    if (isHorizonal) {

        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];

    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }

    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {

        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);

    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }

    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}



@end
