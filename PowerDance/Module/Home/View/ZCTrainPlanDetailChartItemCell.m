//
//  ZCTrainPlanDetailChartItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/1.
//

#import "ZCTrainPlanDetailChartItemCell.h"

#define kHEIGHT 120

@interface ZCTrainPlanDetailChartItemCell ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIView *pressView;

@property (nonatomic,strong) UIView *sepView;

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) UIView *colorView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIView *alertView;//提示时间

@property (nonatomic,strong) UILabel *valueL;

@end

@implementation ZCTrainPlanDetailChartItemCell

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
        make.height.mas_equalTo(kHEIGHT);
        make.bottom.mas_equalTo(self.contentView).inset(40);
    }];
    
    self.pressView = [[UIView alloc] init];
    [self.bgView addSubview:self.pressView];
        
    self.timeL = [self createSimpleLabelWithTitle:@"08-09" font:9 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(AUTO_MARGIN(6));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    [self.bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.pressView.mas_centerX);
        make.bottom.mas_equalTo(self.bgView);
        make.height.mas_equalTo(AUTO_MARGIN(140));
        make.width.mas_equalTo(1.0);
    }];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    
    UIView *alertView = [[UIView alloc] init];
    self.alertView = alertView;
    [self.contentView addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.pressView.mas_top).inset(AUTO_MARGIN(10));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(AUTO_MARGIN(45));
        make.height.mas_equalTo(18);
    }];
    [self configureLeftToRightViewColorGradient:self.alertView width:AUTO_MARGIN(45) height:18 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:3];
    
    self.valueL = [self createSimpleLabelWithTitle:@" " font:8 bold:NO color:[ZCConfigColor whiteColor]];
    [self.contentView addSubview:self.valueL];
    [self.valueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alertView.mas_centerX);
        make.centerY.mas_equalTo(alertView.mas_centerY);
    }];
}

- (void)setMaxValues:(double)maxValues {
    _maxValues = maxValues / 60.0;
}

- (void)setSelectFlag:(NSInteger)selectFlag {
    _selectFlag = selectFlag;
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    double weight = [dataDic[@"duration"] doubleValue] / 60.0;
    double height;
    if (weight > 0.0) {
        height = kHEIGHT / self.maxValues * weight;
    } else {
        height = 0.0;
    }
    
    self.pressView.frame = CGRectMake(0, kHEIGHT - height, 18, height);
    [self createCornerWithButton:self.pressView];
    
    self.colorView = [[UIView alloc] init];
    [self.pressView addSubview:self.colorView];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.pressView);
    }];
    [self.colorView configureViewColorGradient:self.colorView width:18 height:height one:rgba(138, 205, 215, 1) two:rgba(246, 246, 246, 1) cornerRadius:0];
    
    NSString *time = dataDic[@"time"];
    if (self.type == 2) {
        if (time.length > 6) {
            time = [time substringWithRange:NSMakeRange(5, 2)];
        }
        self.timeL.text = [NSString stringWithFormat:@"%@", time];
    } else {
        if (time.length > 9) {
            self.timeL.text = [time substringWithRange:NSMakeRange(5, 5)];
        } else {
            self.timeL.text = time;
        }
    }
    if (self.selectFlag) {//选中
        self.lineView.hidden = NO;
        self.alertView.hidden = NO;
        self.valueL.text = [NSString stringWithFormat:@"%.1f%@", weight, NSLocalizedString(@"X_分钟", nil)];
    } else {
        self.lineView.hidden = YES;
        self.alertView.hidden = YES;
    }
}

- (void)createCornerWithButton:(UIView *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight    cornerRadii:CGSizeMake(9, 9)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

@end
