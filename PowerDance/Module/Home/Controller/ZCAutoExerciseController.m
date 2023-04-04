//
//  ZCAutoExerciseController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCAutoExerciseController.h"
#import "ZCHomeTrainCardCell.h"
#import "ZCTrainProfessionTopView.h"
#import "ZCTrainProfessionItemCell.h"

@interface ZCAutoExerciseController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSDictionary *temDic;

@property (nonatomic,strong) ZCTrainProfessionTopView *topView;

@property (nonatomic,strong) NSMutableArray *temArr;

@property (nonatomic,assign) NSInteger signEditFlag;

@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) NSMutableArray *timerArr;

@property (nonatomic,strong) NSMutableArray *classArr;

@end

@implementation ZCAutoExerciseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];
}

- (void)createSubviews {
    
    UIImageView *secondIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_home_profession")];
    [self.view addSubview:secondIv];
    [secondIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
    }];
    
    self.showNavStatus = YES;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_BAR_HEIGHT);
        make.bottom.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(5));
    }];
    
    kweakself(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself queryTrainTimerHistoryListInfo];
    }];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
   
    [self bind];
    
    [self queryTrainTimerHistoryListInfo];
}

- (void)bind {
    kweakself(self);
    [RACObserve(kProfileStore, recordTrainRefresh) subscribeNext:^(id  _Nullable x) {
        [weakself queryTrainTimerHistoryListInfo];
    }];
    [RACObserve(kProfileStore, customActionRefresh) subscribeNext:^(id  _Nullable x) {
        [weakself queryTrainClassHistoryListInfo];
    }];
}
#pragma -- mark 训练计时器记录
- (void)queryTrainTimerHistoryListInfo{
    [ZCTrainManage queryTrainHistoryListInfoURL:@{@"id":@"1"} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        [self.timerArr removeAllObjects];
        [self.timerArr addObjectsFromArray:responseObj[@"data"]];
        [self queryTrainClassHistoryListInfo];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}
#pragma -- mark 训练课程记录
- (void)queryTrainClassHistoryListInfo {
    [ZCTrainManage queryTrainHistoryListInfoURL:@{@"id":@"2"} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        [self.classArr removeAllObjects];
        [self.classArr addObjectsFromArray:responseObj[@"data"]];
        [self.collectionView reloadData];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainProfessionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCTrainProfessionItemCell" forIndexPath:indexPath];
    cell.titleDic = self.titleArr[indexPath.row];
    cell.index = indexPath.row;
    if (indexPath.row == 0) {
        if (self.timerArr.count > 0) {
            cell.dataArr = self.timerArr;
        }
    } else {
        if (self.classArr.count > 0) {
            cell.dataArr = self.classArr;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [HCRouter router:@"TrainPlan" params:@{} viewController:self animated:YES];
    } else {
        [HCRouter router:@"CustomActionTrain" params:@{} viewController:self animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZCTrainProfessionTopView *reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZCTrainProfessionTopView" forIndexPath:indexPath];
        return reusableHeaderView;
    } else {
        return [UICollectionReusableView new];;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_W, AUTO_MARGIN(335));//宽默认
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(55))/2.0, AUTO_MARGIN(250));
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCTrainProfessionItemCell class] forCellWithReuseIdentifier:@"ZCTrainProfessionItemCell"];
        [_collectionView registerClass:[ZCTrainProfessionTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZCTrainProfessionTopView"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[
            @{@"image":@"auto_train_timer", @"title":NSLocalizedString(@"计时器自主训练", nil)},
            @{@"image":@"auto_train_class", @"title":NSLocalizedString(@"课程编排训练", nil)},
        ];
    }
    return _titleArr;
}

- (NSMutableArray *)timerArr {
    if (!_timerArr) {
        _timerArr = [NSMutableArray array];
    }
    return _timerArr;
}

- (NSMutableArray *)classArr {
    if (!_classArr) {
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}

@end
