//
//  ZCEquipmentCategoryListItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentCategoryListItemCell.h"

@interface ZCEquipmentCategoryListItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel     *nameL;

@property (nonatomic,strong) UILabel     *descL;

@end

@implementation ZCEquipmentCategoryListItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.contentView.backgroundColor = [ZCConfigColor bgColor];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_instrument")];    
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(65));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(30));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"智能跳绳", nil) font:AUTO_MARGIN(13) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.nameL];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.mas_equalTo(self.contentView.mas_leading).inset(AUTO_MARGIN(15));
    }];
    
    self.descL = [self createSimpleLabelWithTitle:NSLocalizedString(@"智能跳绳", nil) font:12 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self.contentView addSubview:self.descL];
    self.descL.textAlignment = NSTextAlignmentCenter;
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(7));
        make.leading.mas_equalTo(self.contentView.mas_leading).inset(AUTO_MARGIN(15));
    }];
    
    [self.contentView setViewCornerRadiu:AUTO_MARGIN(10)];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];
    self.nameL.text = checkSafeContent(dataDic[@"name"]);
    self.descL.text = checkSafeContent(dataDic[@"briefDesc"]);
}

@end
