//
//  ZCSelectEquipmentItem.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import "ZCSelectEquipmentItem.h"
#import "ZCEquipmentModel.h"

@interface ZCSelectEquipmentItem ()

@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation ZCSelectEquipmentItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.iconIv = [[UIImageView alloc] init];
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(self);
        make.width.height.mas_equalTo(AUTO_MARGIN(40));
        make.top.trailing.mas_equalTo(self).inset(AUTO_MARGIN(10));
    }];
    
    UIButton *delBtn = [[UIButton alloc] init];
    [self addSubview:delBtn];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.mas_equalTo(self);
        make.height.width.mas_equalTo(AUTO_MARGIN(20));
    }];
    [delBtn setImage:kIMAGE(@"shop_exit") forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(deleteOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setModel:(ZCEquipmentModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
}

- (void)deleteOperate {
    if (self.deleteItemOperate) {
        self.deleteItemOperate(self.model);
    }
}

@end
