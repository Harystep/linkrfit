//
//  ZCGoodsCenterView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCGoodsCenterView.h"
#import "ZCGoodsNumView.h"
#import "ZCShopAddressModel.h"
#import "ZCShopGoodsModel.h"

@interface ZCGoodsCenterView ()

@property (nonatomic,strong) UILabel *goodsNameL;

@property (nonatomic,strong) UILabel *goodsSubNameL;

@property (nonatomic,strong) UILabel *priceL;

@property (nonatomic,strong) UILabel *scoreL;

@property (nonatomic,strong) UILabel *scoreNumL;

@property (nonatomic,strong) ZCGoodsNumView *numView;

@property (nonatomic,strong) UILabel *selectContentL;

@property (nonatomic,strong) UILabel *selectPlaceL;

@property (nonatomic,strong) UILabel *arriveTimeL;

@property (nonatomic,strong) UIView *scoreView;

@end

@implementation ZCGoodsCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.num = 1;
    
    self.goodsNameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:18 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.goodsNameL];
    [self.goodsNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(30));
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
    }];
        
    self.goodsSubNameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
    [self.goodsSubNameL setContentLineFeedStyle];
    [self addSubview:self.goodsSubNameL];
    [self.goodsSubNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodsNameL.mas_leading);
        make.trailing.mas_equalTo(self.goodsNameL.mas_trailing);
        make.top.mas_equalTo(self.goodsNameL.mas_bottom).offset(AUTO_MARGIN(8));
    }];
    
    self.numView = [[ZCGoodsNumView alloc] init];
    self.numView.hidden = YES;
    [self addSubview:self.numView];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(116));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(134);
        make.height.mas_equalTo(34);
    }];
    kweakself(self);
    self.numView.selectGoodsNumBlock = ^(NSString * _Nonnull value) {
        weakself.selectContentL.text = [NSString stringWithFormat:@"%@ x%@", weakself.goodsNameL.text, value];
        weakself.num = [value integerValue];
    };
    
    self.priceL = [self createSimpleLabelWithTitle:@"" font:30 bold:YES color:rgba(248, 107, 34, 1)];
    [self addSubview:self.priceL];
    [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodsNameL.mas_leading);
        make.top.mas_equalTo(self.goodsSubNameL.mas_bottom).offset(AUTO_MARGIN(35));
    }];
    
    UIView *scoreView = [[UIView alloc] init];
    scoreView.hidden = YES;
    self.scoreView = scoreView;
    [self addSubview:scoreView];
    [scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceL.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    [scoreView setViewColorAlpha:0.03 color:UIColor.blackColor];
    [scoreView setViewCornerRadiu:10];
    [self setupScoreViewSubViews:scoreView];
    
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = rgba(43, 42, 51, 0.03);
    [self addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.priceL.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(5.0);
    }];
    
    UIView *selectView = [[UIView alloc] init];
    [self addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(sepView.mas_bottom);
    }];
    
    UILabel *selectTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"已选", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [selectView addSubview:selectTL];
    [selectTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(selectView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(selectView.mas_top).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(selectView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    
    self.selectContentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [selectView addSubview:self.selectContentL];
    [self.selectContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(selectTL.mas_centerY);
        make.leading.mas_equalTo(selectTL.mas_trailing).offset(AUTO_MARGIN(20));
    }];
    
    UIImageView *typeIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [selectView addSubview:typeIv];
    [typeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(selectView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(selectTL.mas_centerY);
    }];
    
    UITapGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeShopOperate:)];
    [selectView addGestureRecognizer:typeTap];
    
    UIView *lineSep = [[UIView alloc] init];
    lineSep.backgroundColor = rgba(43, 42, 51, 0.03);
    [selectView addSubview:lineSep];
    [lineSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.selectContentL.mas_leading);
        make.trailing.mas_equalTo(selectView.mas_trailing);
        make.height.mas_equalTo(AUTO_MARGIN(1));
        make.bottom.mas_equalTo(selectView.mas_bottom);
    }];
    
    UIView *placeView = [[UIView alloc] init];
    [self addSubview:placeView];
    [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(selectView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    UILabel *arriveTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"送至", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [placeView addSubview:arriveTL];
    [arriveTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(selectTL.mas_leading);
        make.top.mas_equalTo(placeView.mas_top).offset(AUTO_MARGIN(15));
    }];
    
    self.selectPlaceL = [self createSimpleLabelWithTitle:NSLocalizedString(@"未添加地址，立即添加", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [placeView addSubview:self.selectPlaceL];
    [self.selectPlaceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(arriveTL.mas_centerY);
        make.leading.mas_equalTo(arriveTL.mas_trailing).offset(AUTO_MARGIN(20));
    }];
    NSString *arriveTime = [NSString getTimeWithData:[NSDate dateWithDaysFromNow:3] farmot:@"yyyy-MM-dd"];
    NSLog(@"arriveTime -->%@", arriveTime);
    self.arriveTimeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"填写地址后查看送达时间", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [placeView addSubview:self.arriveTimeL];
    [self.arriveTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.selectPlaceL.mas_leading);
        make.top.mas_equalTo(self.selectPlaceL.mas_bottom).offset(AUTO_MARGIN(8));
    }];
    
    UIView *bottomSep = [[UIView alloc] init];
    bottomSep.backgroundColor = rgba(43, 42, 51, 0.03);
    [placeView addSubview:bottomSep];
    [bottomSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.arriveTimeL.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(5.0);
        make.bottom.mas_equalTo(placeView.mas_bottom);
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [placeView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(placeView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(arriveTL.mas_centerY);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeOperate:)];
    [placeView addGestureRecognizer:tap];
    
}

- (void)typeShopOperate:(UITapGestureRecognizer *)tap {
    [tap.view routerWithEventName:@"2"];
}

- (void)setModel:(ZCShopAddressModel *)model {
    _model = model;
    NSString *arriveTime = [NSString getTimeWithData:[NSDate dateWithDaysFromNow:3] farmot:@"MM月dd日"];
    self.arriveTimeL.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"现在下单，预计", nil), arriveTime, NSLocalizedString(@"送达", nil)];
    self.selectPlaceL.text = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.region, model.address];
}

- (void)setGoodsModel:(ZCShopGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    self.goodsNameL.text = checkSafeContent(goodsModel.name);
    self.goodsSubNameL.text = checkSafeContent(goodsModel.briefDesc);
    self.scoreNumL.text= [NSString stringWithFormat:@"%@%@", goodsModel.scopeCount, NSLocalizedString(@"人评分", nil)];
    NSString *scopeStr = checkSafeContent(goodsModel.scope);
    self.scoreL.text = [NSString stringWithFormat:@"%.1f%@", [scopeStr doubleValue], NSLocalizedString(@"分", nil)];
    if ([goodsModel.scopeCount integerValue] > 0) {
        self.scoreView.hidden = NO;
        [self.scoreView layoutIfNeeded];
        [self configureLeftToRightViewColorGradient:self.scoreView width:self.scoreView.width height:self.scoreView.height one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:3];
    }
    NSString *content = [NSString stringWithFormat:@"¥%@", goodsModel.priceDou];
    self.priceL.attributedText = [content dn_changeFont:FONT_SYSTEM(14) andRange:NSMakeRange(0, 1)];
    
    self.selectContentL.text = [NSString stringWithFormat:@"%@ x1", checkSafeContent(goodsModel.name)];
}

- (void)setNum:(NSInteger)num {
    _num = num;
    self.selectContentL.text = [NSString stringWithFormat:@"%@ x%tu", self.goodsNameL.text, num];
}

- (void)placeOperate:(UITapGestureRecognizer *)tap {
    [tap.view routerWithEventName:@"1"];
}

- (void)setupScoreViewSubViews:(UIView *)scoreView {
    self.scoreNumL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:14 bold:NO color:[ZCConfigColor whiteColor]];
    [scoreView addSubview:self.scoreNumL];
    [self.scoreNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(scoreView.mas_trailing).inset(AUTO_MARGIN(8));
        make.centerY.mas_equalTo(scoreView.mas_centerY);
    }];
    
    self.scoreL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor whiteColor]];
    [scoreView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.scoreNumL.mas_leading).inset(AUTO_MARGIN(5));
        make.leading.mas_equalTo(scoreView.mas_leading).offset(AUTO_MARGIN(8));
        make.centerY.mas_equalTo(scoreView.mas_centerY);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scoreClick)];
    [scoreView addGestureRecognizer:tap];
}

- (void)scoreClick {
    [HCRouter router:@"ShopComment" params:@{@"productId":checkSafeContent(self.goodsModel.ID), @"scope":self.goodsModel.scope} viewController:self.superViewController animated:YES];
}

@end
