//
//  ZCEquipmentDetailTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentDetailTopView.h"

@interface ZCEquipmentDetailTopView ()

@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation ZCEquipmentDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.iconIv = [[UIImageView alloc] init];
    [self.iconIv setViewContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.iconIv];
    self.iconIv.backgroundColor = [ZCConfigColor bgColor];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(24);
    }];
    [view layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:nil];
}

@end
