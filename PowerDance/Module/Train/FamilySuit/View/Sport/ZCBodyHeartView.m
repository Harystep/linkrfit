//
//  ZCBodyHeartView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/29.
//

#import "ZCBodyHeartView.h"
#import "HeartLive.h"

#define kMarginX AUTO_MARGIN(5)

#define kWidthX AUTO_MARGIN(100)

@interface ZCBodyHeartView ()
{
    CGPoint targetPointToAdd;
    CGFloat postxCoordinateInMoniter;
    CGPoint postTargetPointToAdd;

}
@property (nonatomic,strong) UILabel *heartNumL;

//绘制心电图
@property (nonatomic , strong) HeartLive *translationMoniterView;

@property(nonatomic,strong)PointContainer *transContainer;

@property (nonatomic,assign) NSInteger xCoordinateInMoniter;

@end

@implementation ZCBodyHeartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self setViewCornerRadiu:AUTO_MARGIN(10)];
    self.backgroundColor = [ZCConfigColor bgColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W - AUTO_MARGIN(100)-AUTO_MARGIN(40), AUTO_MARGIN(30), SCREEN_W-AUTO_MARGIN(140), 50)];
    [self addSubview:bgView];
    [bgView configureLeftToRightViewColorGradient:bgView width:SCREEN_W-AUTO_MARGIN(140) height:50 one:rgba(255, 0, 0, 1) two:rgba(255, 0, 0, 0) cornerRadius:0];
    bgView.alpha = 0.06;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(255, 0, 0, 1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(1));
        make.height.mas_equalTo(50);
        make.top.leading.mas_equalTo(bgView);
    }];
    self.translationMoniterView = [[HeartLive alloc] initWithFrame:CGRectMake(CGRectGetMinX(bgView.frame), AUTO_MARGIN(30), SCREEN_W-AUTO_MARGIN(140), 50)];
    self.translationMoniterView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.translationMoniterView];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.top.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(100));
        make.height.mas_equalTo(AUTO_MARGIN(110));
    }];
    contentView.backgroundColor = [ZCConfigColor bgColor];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"suit_body_heart")];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.width.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    
    UILabel *lbL = [self createSimpleLabelWithTitle:NSLocalizedString(@"心率", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:lbL];
    [lbL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    self.heartNumL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(30) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:self.heartNumL];
    [self.heartNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lbL.mas_bottom).offset(AUTO_MARGIN(12));
    }];
    
   UILabel *unitL  = [self createSimpleLabelWithTitle:@"BMP" font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:unitL];
    [unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.heartNumL.mas_trailing).offset(AUTO_MARGIN(5));
        make.bottom.mas_equalTo(self.heartNumL.mas_bottom).inset(AUTO_MARGIN(4));
    }];

}

- (void)setCount:(NSString *)count {
    _count = count;
    [self timerTranslationFun:count];
    self.heartNumL.text = count;
}

#pragma mark 绘图
//平移方式绘制
- (void)timerTranslationFun:(NSString *)string
{
    NSLog(@"ratoi:%@", string);
    kweakself(self);
    [[PointContainer sharedContainer] addPointAsTranslationChangeform:[weakself bubbleTranslationPoint:string]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.translationMoniterView fireDrawingWithPoints:[[PointContainer sharedContainer] translationPointContainer] pointsCount:[[PointContainer sharedContainer] numberOfTranslationElements]];
    });
}

- (CGPoint)bubbleTranslationPoint:(NSString *)string
{
    NSInteger pixelPerPoint = 1;
    static NSInteger xCoordinateInMoniter = 0;
    CGFloat zeroPoint = [string integerValue];
    if ([string integerValue] > 115) {
        zeroPoint = 115 + (zeroPoint - 115)/10.0;
    } else if ([string integerValue] < 85) {
        zeroPoint = 85 - (85 - zeroPoint)/5.0;
    }
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter, (62-(zeroPoint-65))};
//    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter, [string integerValue]-65};
    xCoordinateInMoniter += pixelPerPoint;
//    xCoordinateInMoniter %= (int)(CGRectGetWidth(self.translationMoniterView.frame));

//    NSLog(@"吐出来的点:%@",NSStringFromCGPoint(targetPointToAdd));
    return targetPointToAdd;
}

@end
