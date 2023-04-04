//
//  ZCGoodsTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCGoodsTopView.h"
#import "ZCShopGoodsModel.h"
#import "XLPhotoBrowser.h"

@interface ZCGoodsTopView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView  *bannerView;

@end

@implementation ZCGoodsTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.bannerView = [[SDCycleScrollView alloc] init];
    self.bannerView.delegate = self;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.clipsToBounds = YES;
    self.bannerView.autoScrollTimeInterval = 7.0;
    [self addSubview:self.bannerView];
    [self.bannerView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_offset(AUTO_MARGIN(375));
    }];
    self.bannerView.imageURLStringsGroup = @[
//        @"https://t7.baidu.com/it/u=3186989282,2149874847&fm=193&f=GIF", @"https://t7.baidu.com/it/u=3908567777,3430767661&fm=193&f=GIF"
    ];
    
    self.centerView = [[ZCGoodsCenterView alloc] init];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}

- (void)setModel:(ZCShopGoodsModel *)model {
    _model = model;
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSDictionary *dic in model.productImgs) {
        [temArr addObject:dic[@"imageUrl"]];
    }
    self.bannerView.imageURLStringsGroup = temArr;
    self.centerView.goodsModel = model;
}

#pragma mark -- SYBHomeBannerViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.model.productImgs.count > 0) {
        NSMutableArray *temArr = [NSMutableArray array];
        for (NSDictionary *dic in self.model.productImgs) {
            [temArr addObject:dic[@"imageUrl"]];
        }
        [XLPhotoBrowser showPhotoBrowserWithImages:temArr currentImageIndex:index];
    }
    
}

@end
