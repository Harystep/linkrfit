//
//  ZCSelectEquipmentController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCSelectEquipmentController.h"
#import "ZCSelectSportEquipmentCell.h"
#import "ZCEquipmentModel.h"
#import "ZCSelectEquipmentItem.h"
#import "ZCSelectEquipmentView.h"

@interface ZCSelectEquipmentController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger current;

@property (nonatomic,strong) NSMutableArray *selectArr;

@property (nonatomic,strong) ZCSelectEquipmentView *scView;

@property (nonatomic,strong) NSMutableArray *modelIDList;

@end

@implementation ZCSelectEquipmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectArr = [NSMutableArray arrayWithArray:self.params[@"data"]];
    
    [self configureBaseInfo];
    
    self.current = 1;
    [self.view addSubview:self.scView];
    CGFloat height = 0.01;
    if (self.selectArr.count > 0) {
        height = AUTO_MARGIN(80);
        self.scView.hidden = NO;
        self.scView.dataArr = self.selectArr;
    } else {
        self.scView.hidden = YES;
    }
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    kweakself(self);
    self.scView.deleteSelectItem = ^(id  _Nonnull value) {
        ZCEquipmentModel *model = value;
        [weakself.selectArr removeObject:model];
        [weakself.modelIDList removeObject:checkSafeContent(model.ID)];
        weakself.scView.dataArr = weakself.selectArr;        
        [weakself.collectionView reloadData];
    };
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakself.current = 1;
//        [weakself getShowEquipmentListInfo];
//    }];
//
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.current ++;
        [weakself getShowEquipmentListInfo];
    }];
    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
    [self getShowEquipmentListInfo];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"选择器材", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    for (ZCEquipmentModel *model in self.selectArr) {
        [self.modelIDList addObject:model.ID];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCSelectSportEquipmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSelectSportEquipmentCell" forIndexPath:indexPath];
    cell.dataArr = self.selectArr;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCEquipmentModel *model = self.dataArr[indexPath.row];
    if ([self.modelIDList containsObject:model.ID]) return;
    [self.dataArr removeObjectAtIndex:indexPath.row];
    model.status = YES;
    [self.dataArr insertObject:model atIndex:indexPath.row];
    [self.selectArr addObject:model];
    
    [self createSelectViewSubViews:model];
}

- (void)createSelectViewSubViews:(ZCEquipmentModel *)item {
    self.scView.hidden = NO;
    [self.scView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(80));
    }];
    self.scView.dataArr = self.selectArr;
    
    [self.collectionView reloadData];
}

- (void)backOperate {
    self.callBackBlock(self.selectArr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(60))/2.0, AUTO_MARGIN(144));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(20, AUTO_MARGIN(20), 20, AUTO_MARGIN(20));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = rgba(246, 246, 246, 1);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCSelectSportEquipmentCell class] forCellWithReuseIdentifier:@"ZCSelectSportEquipmentCell"];
    }
    return _collectionView;
}

- (void)getShowEquipmentListInfo {
    [ZCTrainManage queryEquipmentListInfo:@{@"current":@(self.current)} completeHandler:^(id  _Nonnull responseObj) {
        if (self.current == 1) {
            [self.dataArr removeAllObjects];
            [self.collectionView.mj_header endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        NSMutableArray *temArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObj[@"data"][@"records"]) {
            ZCEquipmentModel *model = [ZCEquipmentModel mj_objectWithKeyValues:dic];
            if ([self.modelIDList containsObject:model.ID]) {
                model.status = YES;
            }
            [temArr addObject:model];
        }
        [self.dataArr addObjectsFromArray:temArr];
        [self.collectionView reloadData];
    }];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (ZCSelectEquipmentView *)scView {
    if (!_scView) {
        _scView = [[ZCSelectEquipmentView alloc] init];
    }
    return _scView;
}

- (NSMutableArray *)modelIDList {
    if (!_modelIDList) {
        _modelIDList = [NSMutableArray array];
    }
    return _modelIDList;
}

@end
