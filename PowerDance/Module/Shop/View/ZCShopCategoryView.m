//
//  ZCShopCategoryView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/5.
//

#import "ZCShopCategoryView.h"
#import "ZCShopCategorySimpleCell.h"
#import "ZCShopTopView.h"

@interface ZCShopCategoryView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *noneView;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) NSInteger current;

@end

@implementation ZCShopCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.backgroundColor = [ZCConfigColor bgColor];
    self.current = 1;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    kweakself(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.current = 1;
        [weakself getShopGoodsListInfo];
    }];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.current ++;
        [weakself getShopGoodsListInfo];
    }];
    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
    
    [self.collectionView addSubview:self.noneView];
    [self.noneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.collectionView.mas_centerX);
        make.centerY.mas_equalTo(self.collectionView.mas_centerY);
    }];
        
    [self queryRecommendEquipmentGoodsInfo];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSArray *temArr = [ZCDataTool getShopGoodsCategoryTargetInfoWithSourceId:index];
    if (temArr.count > 0) {
        self.dataArr = temArr;
        [self refreshSubviewData];
    }
    [self getShopGoodsListInfo];
}

#pragma -- mark 推荐商品信息
- (void)queryRecommendEquipmentGoodsInfo {
    [ZCClassSportManage queryEquipmentFavListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"recommend:%@", responseObj);
        self.dataDic = responseObj[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

#pragma -- mark 查询商品列表
- (void)getShopGoodsListInfo {
    
    [ZCShopManage queryShopCategoryListInfo:@{@"categoryId":@"0", @"current":@(self.current)} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"shopList:%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 200) {            
            self.dataArr = responseObj[@"data"][@"records"];
            [ZCDataTool saveShopGoodsCategoryTargetInfo:self.dataArr source:self.index];
        }
        if (self.dataArr.count > 0) {
            self.noneView.hidden = YES;
        } else {
            self.noneView.hidden = NO;
        }
        [self refreshSubviewData];
    }];
}

- (void)refreshSubviewData {
    if (self.current == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
        });
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCShopCategorySimpleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCShopCategorySimpleCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [HCRouter router:@"GoodsDetail" params:@{@"data":checkSafeContent(dic[@"id"])} viewController:self.superViewController animated:YES];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZCShopTopView *reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShopTopView" forIndexPath:indexPath];
        reusableHeaderView.dataDic = self.dataDic;
        return reusableHeaderView;
    }
    else {
        return view;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_W, AUTO_MARGIN(75)+AUTO_MARGIN(8));//宽默认

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(10)*5)/2.0, AUTO_MARGIN(162)+AUTO_MARGIN(90));
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(10), AUTO_MARGIN(10), AUTO_MARGIN(10), AUTO_MARGIN(10));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [ZCConfigColor bgColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCShopCategorySimpleCell class] forCellWithReuseIdentifier:@"ZCShopCategorySimpleCell"];
        //ZCShopTopView
        [_collectionView registerClass:[ZCShopTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShopTopView"];
        
    }
    return _collectionView;
}

- (UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc] init];
        UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"base_none_data")];
        [_noneView addSubview:iconIv];
        _noneView.userInteractionEnabled = NO;
        _noneView.hidden = YES;
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_noneView.mas_centerY);
            make.centerX.mas_equalTo(_noneView.mas_centerX);
        }];
        UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"暂无数据", nil) font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
        [lb setContentLineFeedStyle];
        lb.textAlignment = NSTextAlignmentCenter;
        [_noneView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(_noneView).inset(AUTO_MARGIN(15));
            make.top.mas_equalTo(iconIv.mas_bottom);
        }];
    }
    return _noneView;
}

@end
