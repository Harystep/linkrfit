//
//  ZCEquipmentAssociateClassCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentAssociateClassCell.h"

@interface ZCEquipmentAssociateClassCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@end

@implementation ZCEquipmentAssociateClassCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
   
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_class")];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(75));
    }]; 
    [self.iconIv setViewContentMode:UIViewContentModeScaleAspectFill];
    [self.iconIv setViewCornerRadiu:10];
    
    self.titleL = [self createSimpleLabelWithTitle:@"课程" font:12 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];
    self.titleL.text = checkSafeContent(dataDic[@"title"]);
}

@end
