//
//  ZCHomeBindDeviceItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCHomeBindDeviceItemCell.h"

@interface ZCHomeBindDeviceItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *contentL;

@end

@implementation ZCHomeBindDeviceItemCell

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
        make.edges.mas_equalTo(self.contentView);
    }];
    iconView.backgroundColor = [ZCConfigColor bgColor];
    [iconView setViewCornerRadiu:AUTO_MARGIN(5)];
    [iconView layoutIfNeeded];
    
    self.contentL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(12) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.contentL];
    self.contentL.textAlignment = NSTextAlignmentCenter;
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconView.mas_centerX);
        make.bottom.mas_equalTo(iconView.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(30));
        make.leading.mas_equalTo(self.contentView.mas_leading).inset(2);
    }];
    
    self.iconIv = [[UIImageView alloc] init];
    [iconView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(60));
        make.centerX.mas_equalTo(iconView.mas_centerX);
        make.top.mas_equalTo(iconView.mas_top).offset(AUTO_MARGIN(10));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];
    self.contentL.text = checkSafeContent(dataDic[@"name"]);
}

@end
