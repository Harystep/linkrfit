//
//  ZCSelectBaseCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCSelectBaseCell.h"

@interface ZCSelectBaseCell ()

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UIImageView *bgIv;

@end

@implementation ZCSelectBaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"我的训练", nil) font:16 bold:YES color:UIColor.whiteColor];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(15));
    }];
        
    self.bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_item_bg")];
    self.bgIv.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.bgIv];
    [self.bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self.contentView);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.contentView.backgroundColor = dataDic[@"color"];
    self.titleL.text = dataDic[@"title"];
    if (dataDic[@"image"] != nil) {
        self.iconIv.image = kIMAGE(dataDic[@"image"]);
    }
}

- (void)setModel:(ZCColorModel *)model {
    _model = model;
    if (model.colourCode != nil) {
        self.contentView.backgroundColor = kColorHex(model.colourCode);
    }
    if (model.patternUrl != nil) {
        [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.patternUrl] placeholderImage:nil];
        self.contentView.backgroundColor = [ZCConfigColor txtColor];
    }
}

@end
