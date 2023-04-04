//
//  ZCComfireOrderDetailView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCComfireOrderDetailView.h"
#import "ZCBuyGoodsInfoView.h"
#import "ZCShopGoodsModel.h"
#import "ZCGoodsTypeModel.h"

@interface ZCComfireOrderDetailView ()

@property (nonatomic,strong) ZCBuyGoodsInfoView *goodsInfoView;
@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) UILabel *pastePriceL;

@end

@implementation ZCComfireOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    ZCBuyGoodsInfoView *topView = [[ZCBuyGoodsInfoView alloc] init];
    self.goodsInfoView = topView;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
    }];
    
    UILabel *priceTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"价格", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    UILabel *pasteTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"邮费", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:priceTL];
    [self addSubview:pasteTL];
    [priceTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(topView.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    [pasteTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(priceTL.mas_leading);
        make.top.mas_equalTo(priceTL.mas_bottom).offset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    
    self.priceL = [self createSimpleLabelWithTitle:NSLocalizedString(@"¥199", nil) font:15 bold:YES color:[ZCConfigColor txtColor]];
    
    self.pastePriceL = [self createSimpleLabelWithTitle:NSLocalizedString(@"0", nil) font:15 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.priceL];
    [self addSubview:self.pastePriceL];
    [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceTL.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    
    [self.pastePriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pasteTL.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
    }];        
    
}

- (void)setModel:(ZCShopGoodsModel *)model {
    _model = model;
//    [self.goodsInfoView.iconIv sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    self.goodsInfoView.nameL.text = model.name;
//    self.goodsInfoView.subNameL.text = model.briefDesc;
    
}

- (void)setTypeModel:(ZCGoodsTypeModel *)typeModel {
    _typeModel = typeModel;
    [self.goodsInfoView.iconIv sd_setImageWithURL:[NSURL URLWithString:typeModel.imgUrl] placeholderImage:nil];
    self.goodsInfoView.subNameL.text = typeModel.specTitle;
}

- (void)setNum:(NSInteger)num {
    _num = num;
    self.priceL.text = [NSString stringWithFormat:@"¥%@", [ZCDataTool reviseString:[NSString stringWithFormat:@"%.2f", [self.typeModel.sellPriceDou doubleValue]*num]]];
    self.goodsInfoView.numL.text = [NSString stringWithFormat:@"x%tu", num];
}

@end
