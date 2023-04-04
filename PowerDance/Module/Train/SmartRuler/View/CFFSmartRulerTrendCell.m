//
//  CFFSmartRulerTrendCell.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/20.
//

#import "CFFSmartRulerTrendCell.h"

@interface CFFSmartRulerTrendCell ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIView *pressView;

@property (nonatomic,strong) UIView *sepView;

@property (nonatomic,strong) UILabel *valueL;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation CFFSmartRulerTrendCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
    
    self.pressView = [[UIView alloc] init];
    self.pressView.backgroundColor = kCFF_BG_COLOR_GREEN_COMMON;
    [self.bgView addSubview:self.pressView];
    
    self.sepView = [[UIView alloc] init];
    self.sepView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
    [self.contentView addSubview:self.sepView];
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(1);
    }];
    
    self.valueL = [self createSimpleLabelWithTitle:@"60.8" font:16 bold:YES color:kCFF_COLOR_CONTENT_TITLE];
    [self.contentView addSubview:self.valueL];
    [self.valueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(AUTO_MARGIN(20));
    }];

}

- (void)setMaxValues:(double)maxValues {
    _maxValues = maxValues;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    double weight = [dataDic[@"weight"] doubleValue];
    self.valueL.text = [NSString stringWithFormat:@"%@", [CFFDataTool reviseString:dataDic[@"weight"]]];
    double height;
    if (weight > 0.0) {
        height = 100.0 / self.maxValues * weight;
    } else {
        height = 0.0;
    }    
    self.pressView.frame = CGRectMake(0, 100 - height, 10, height);
    [self createCornerWithButton:self.pressView];
    NSString *nowTime = [NSString getCurrentDateWithFarmot:@"yyyy-MM-dd"];
    NSString *time = dataDic[@"createTime"];
    if (time.length > 11) {
        if ([nowTime isEqualToString:[time substringWithRange:NSMakeRange(0, 10)]]) {
            self.pressView.backgroundColor = kCFF_BG_COLOR_GREEN_COMMON;
        } else {
            self.pressView.backgroundColor = RGBA_COLOR(199, 235, 227, 1);
        }
    }
}

- (void)setViewBgColor:(UIView *)targetView {
    //实现背景渐变
    
    //初始化我们需要改变背景色的UIView，并添加在视图上
    UIView *theView = targetView;
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = theView.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [theView.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)RGBA_COLOR(19, 189, 145, 1).CGColor,
                                  (__bridge id)RGBA_COLOR(49, 237, 217, 1).CGColor];
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
}

- (void)createCornerWithButton:(UIView *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds   byRoundingCorners:UIRectCornerAllCorners    cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}
@end
