//
//  ZCSuitEquipmentTestBaseView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import "ZCSuitEquipmentTestBaseView.h"

@interface ZCSuitEquipmentTestBaseView ()

@property (nonatomic,strong) UILabel *titleL;//标题
@property (nonatomic,strong) UILabel *numL;//数量
@property (nonatomic,strong) UILabel *heartL;//
@property (nonatomic,strong) NSArray *imageArr;

@end

@implementation ZCSuitEquipmentTestBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    CGFloat width = (SCREEN_W - AUTO_MARGIN(50))/2.0;
    CGFloat height = AUTO_MARGIN(110);
    UIView *numView = [[UIView alloc] init];
    [self addSubview:numView];
    numView.backgroundColor = [ZCConfigColor bgColor];
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.bottom.top.mas_equalTo(self);
    }];
    [numView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UIView *kcalView = [[UIView alloc] init];
    [self addSubview:kcalView];
    kcalView.backgroundColor = [ZCConfigColor bgColor];
    [kcalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(numView.mas_trailing).offset(AUTO_MARGIN(10));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(self.mas_top);
    }];
    [kcalView setViewCornerRadiu:AUTO_MARGIN(10)];
    self.imageArr = @[kIMAGE(@"suit_num_icon"), kIMAGE(@"suit_body_heart")];
    [self createSubviewsOnTargetView:numView type:0];
    [self createSubviewsOnTargetView:kcalView type:1];
    
}

- (void)createSubviewsOnTargetView:(UIView *)targetView type:(NSInteger)type {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:self.imageArr[type]];
    [targetView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(targetView).offset(AUTO_MARGIN(20));
        make.width.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    
    NSString *title;
    NSString *unit;
    UILabel *contentL = [self createSimpleLabelWithTitle:@"100" font:AUTO_MARGIN(30) bold:YES color:[ZCConfigColor txtColor]];
    if (type == 1) {
        unit = @"Bmp";
        title = NSLocalizedString(@"心率", nil);
        self.heartL = contentL;
    } else {
        unit = NSLocalizedString(@"个", nil);
        title = NSLocalizedString(@"次数", nil);
        self.numL = contentL;
    }
    UILabel *titleL = [self createSimpleLabelWithTitle:title font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [targetView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconIv.mas_centerY);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(10));
    }];
        
    [targetView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    UILabel *unitL = [self createSimpleLabelWithTitle:unit font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor subTxtColor]];
    [targetView addSubview:unitL];
    [unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentL.mas_trailing).offset(AUTO_MARGIN(5));
        make.bottom.mas_equalTo(contentL.mas_bottom).inset(AUTO_MARGIN(5));
    }];
}
@end
