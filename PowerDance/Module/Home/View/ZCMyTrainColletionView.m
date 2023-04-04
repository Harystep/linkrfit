//
//  ZCMyTrainColletionView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCMyTrainColletionView.h"
#import "ZCHomeTrainCardCell.h"
#import "ZCTrainAutoTimerTopView.h"

@interface ZCMyTrainColletionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSDictionary *temDic;

@property (nonatomic,strong) ZCTrainAutoTimerTopView *topView;

@property (nonatomic,strong) NSMutableArray *temArr;

@property (nonatomic,assign) NSInteger signEditFlag;

@end

@implementation ZCMyTrainColletionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.temDic = @{@"name":NSLocalizedString(@"自定义", nil), @"image":@"home_add_train", @"flag":@"100"};
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(5));
    }];
    
    [self getTrainListInfo];
    kweakself(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getTrainListInfo];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshEditData) name:@"kRefreshTrainStatusKey" object:nil];
    [self bind];
}

- (void)bind {
    kweakself(self);
    [RACObserve(kProfileStore, collectTrainRefresh) subscribeNext:^(id  _Nullable x) {
        [weakself getTrainListInfo];
    }];
    [RACObserve(kProfileStore, recordTrainRefresh) subscribeNext:^(id  _Nullable x) {
        [weakself getTrainListInfo];
    }];
}

- (void)refreshEditData {
    if (self.signEditFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:self.temArr];
            [self.collectionView reloadData];
        });
    }
}

- (void)getTrainListInfo {
    NSArray *cacheArr = [ZCDataTool getHomeTrainListInfo];
    if (cacheArr.count > 0) {
        [self refreshCacheData:cacheArr];
    }
    [ZCTrainManage queryHomeTrainListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshData:responseObj];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)refreshCacheData:(NSArray *)temArr {
    
    [self.dataArr addObjectsFromArray:temArr];
    [self.dataArr addObject:self.temDic];
    
    [self.temArr addObjectsFromArray:temArr];
    [self.temArr addObject:self.temDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)refreshData:(NSDictionary *)responseObj {
    [self.dataArr removeAllObjects];
    [self.temArr removeAllObjects];
    NSArray *publicList = responseObj[@"data"][@"publicList"];
    NSArray *privateList = responseObj[@"data"][@"privateList"];
    NSArray *systemList = responseObj[@"data"][@"systemList"];
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSDictionary *dic in publicList) {
        NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
        [temDic setValue:checkSafeContent(dic[@"name"]) forKey:@"name"];
        [temDic setValue:checkSafeContent(dic[@"colour"]) forKey:@"colour"];
        [temDic setValue:checkSafeContent(dic[@"cover"]) forKey:@"cover"];
        [temDic setValue:checkSafeContent(dic[@"id"]) forKey:@"id"];
        [temDic setValue:checkSafeContent(dic[@"pattern"]) forKey:@"pattern"];
        [temDic setValue:@"1" forKey:@"type"];
        [temArr addObject:temDic];
    }
    for (NSDictionary *dic in systemList) {
        NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
        [temDic setValue:checkSafeContent(dic[@"name"]) forKey:@"name"];
        [temDic setValue:checkSafeContent(dic[@"colour"]) forKey:@"colour"];
        [temDic setValue:checkSafeContent(dic[@"cover"]) forKey:@"cover"];
        [temDic setValue:checkSafeContent(dic[@"id"]) forKey:@"id"];
        [temDic setValue:checkSafeContent(dic[@"pattern"]) forKey:@"pattern"];
        [temDic setValue:@"3" forKey:@"type"];
        [temArr addObject:temDic];
    }
    for (NSDictionary *dic in privateList) {
        NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
        [temDic setValue:checkSafeContent(dic[@"name"]) forKey:@"name"];
        [temDic setValue:checkSafeContent(dic[@"colour"]) forKey:@"colour"];
        [temDic setValue:checkSafeContent(dic[@"cover"]) forKey:@"cover"];
        [temDic setValue:checkSafeContent(dic[@"id"]) forKey:@"id"];
        [temDic setValue:checkSafeContent(dic[@"pattern"]) forKey:@"pattern"];
        [temDic setValue:@"2" forKey:@"type"];
        [temArr addObject:temDic];
    }
    [ZCDataTool saveHomeTrainListInfo:temArr];
    
    [self refreshCacheData:temArr];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCHomeTrainCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCHomeTrainCardCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    if ([dic[@"flag"] integerValue] == 100) {
        [HCRouter router:@"TrainCustom" params:@{} viewController:self.superViewController animated:YES];
    } else {
        [HCRouter router:@"TrainDetail" params:@{@"id":dic[@"id"], @"type":checkSafeContent(dic[@"type"])} viewController:self.superViewController animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZCTrainAutoTimerTopView *reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZCTrainAutoTimerTopView" forIndexPath:indexPath];
        return reusableHeaderView;
    } else {
        return [UICollectionReusableView new];;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_W, AUTO_MARGIN(335));//宽默认

}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"delete"]) {
        [ZCTrainManage deleteTrainInfoOperate:@{@"trainId":checkSafeContent(userInfo[@"id"])} completeHandler:^(id  _Nonnull responseObj) {
            self.signEditFlag = NO;
            [self.dataArr removeObject:userInfo];
            [self.collectionView reloadData];
        }];
    } else if ([eventName isEqualToString:@"edit"]) {
        self.signEditFlag = YES;
        NSInteger index = [userInfo[@"index"] integerValue];
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:userInfo[@"data"]];
        [temDic setValue:@"1" forKey:@"delete"];
        [self.dataArr replaceObjectAtIndex:index withObject:temDic];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(55))/2.0, AUTO_MARGIN(100));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCHomeTrainCardCell class] forCellWithReuseIdentifier:@"ZCHomeTrainCardCell"];
        [_collectionView registerClass:[ZCTrainAutoTimerTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZCTrainAutoTimerTopView"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)temArr {
    if (!_temArr) {
        _temArr = [NSMutableArray array];
    }
    return _temArr;
}

@end
