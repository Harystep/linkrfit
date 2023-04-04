//
//  ZCSelectShopTypeItem.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import "ZCSelectShopTypeItem.h"

@interface ZCSelectShopTypeItem ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@end

@implementation ZCSelectShopTypeItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    bgView.backgroundColor = UIColor.whiteColor;
    [bgView setViewCornerRadiu:10];
    
    self.iconIv = [[UIImageView alloc] init];
    [bgView addSubview:self.iconIv];
    self.iconIv.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(bgView);
        make.height.mas_equalTo(AUTO_MARGIN(80));
    }];    
    
    self.nameL = [self createSimpleLabelWithTitle:@"白色" font:13 bold:NO color:[ZCConfigColor whiteColor]];
    self.nameL.backgroundColor = [ZCConfigColor txtColor];
    [bgView addSubview:self.nameL];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(bgView);
        make.top.mas_equalTo(self.iconIv.mas_bottom);
    }];
}

- (void)createCornerWithButton:(UIView *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds   byRoundingCorners:UIRectCornerTopLeft |    UIRectCornerTopRight    cornerRadii:CGSizeMake(19, 19)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

@end
