//
//  ZCShopCategorySimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/5.
//

#import "ZCShopCategorySimpleCell.h"

@interface ZCShopCategorySimpleCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *descL;

@property (nonatomic,strong) UILabel *priceL;

@property (nonatomic,strong) UILabel *scoreL;

@end

@implementation ZCShopCategorySimpleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.contentView.backgroundColor = [ZCConfigColor whiteColor];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"shop_simple")];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(162));
        make.top.leading.trailing.mas_equalTo(self.contentView);
    }];
    [self.contentView setViewCornerRadiu:AUTO_MARGIN(5)];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(12));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
    self.descL = [self createSimpleLabelWithTitle:NSLocalizedString(@" ", nil) font:12 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self.contentView addSubview:self.descL];
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(12));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(5);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    UILabel *unitL = [self createSimpleLabelWithTitle:@"¥" font:AUTO_MARGIN(12) bold:NO color:rgba(248, 107, 34, 1)];
    [self.contentView addSubview:unitL];
    [unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameL.mas_leading);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(15));
    }];
    
    self.priceL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(16) bold:YES color:rgba(248, 107, 34, 1)];
    [self.contentView addSubview:self.priceL];
    [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(unitL.mas_centerY);
        make.leading.mas_equalTo(unitL.mas_trailing).offset(1);
    }];
    
    UIView *scoreView = [[UIView alloc] init];
    [self.contentView addSubview:scoreView];
    [scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(unitL.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(12));
        make.width.mas_equalTo(AUTO_MARGIN(40));
        make.height.mas_equalTo(AUTO_MARGIN(14));
    }];
    
    [self configureLeftToRightViewColorGradient:scoreView width:AUTO_MARGIN(40) height:AUTO_MARGIN(14) one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:3];
    
    self.scoreL = [self createSimpleLabelWithTitle:@" 4.8 " font:AUTO_MARGIN(9) bold:YES color:[ZCConfigColor whiteColor]];
    [scoreView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(scoreView.mas_centerX);
        make.centerY.mas_equalTo(scoreView.mas_centerY);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:nil];
    self.nameL.text = checkSafeContent(dataDic[@"name"]);
    self.descL.text = checkSafeContent(dataDic[@"briefDesc"]);
    self.priceL.text = [ZCDataTool reviseString:checkSafeContent(dataDic[@"priceDou"])];
    NSString *score = [ZCDataTool reviseString:checkSafeContent(dataDic[@"scope"])];
    if ([score doubleValue] > 0.0) {
        self.scoreL.text = [NSString stringWithFormat:@"%@%@", score, NSLocalizedString(@"分", nil)];
        self.scoreL.hidden = NO;
    } else {
        self.scoreL.hidden = YES;
    }
}


@end
