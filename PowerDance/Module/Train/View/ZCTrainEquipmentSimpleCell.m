//
//  ZCTrainEquipmentSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/20.
//

#import "ZCTrainEquipmentSimpleCell.h"

@interface ZCTrainEquipmentSimpleCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *contentL;

@end

@implementation ZCTrainEquipmentSimpleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *iconView = [[UIView alloc] init];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(100));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(3));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    iconView.backgroundColor = [ZCConfigColor whiteColor];
    [iconView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.iconIv = [[UIImageView alloc] init];
    [iconView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(50));
        make.centerX.mas_equalTo(iconView.mas_centerX);
        make.centerY.mas_equalTo(iconView.mas_centerY);
    }];
    
    self.contentL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconView.mas_centerX);
        make.top.mas_equalTo(iconView.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];
    self.contentL.text = checkSafeContent(dataDic[@"name"]);
}

@end
