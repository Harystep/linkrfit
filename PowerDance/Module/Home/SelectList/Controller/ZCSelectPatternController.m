//
//  ZCSelectPatternController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCSelectPatternController.h"
#import "ZCSelectBaseCell.h"


@interface ZCSelectPatternController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCSelectPatternController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    [self getShowPatternInfo];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"选择图案", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCSelectBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSelectBaseCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCColorModel *model = self.dataArr[indexPath.row];
    self.callBackBlock(model.patternUrl);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(60))/2.0, AUTO_MARGIN(100));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(0, AUTO_MARGIN(20), 0, AUTO_MARGIN(20));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCSelectBaseCell class] forCellWithReuseIdentifier:@"ZCSelectBaseCell"];
    }
    return _collectionView;
}

- (void)getShowPatternInfo {
    [ZCTrainManage queryTrainEquipmentPatternListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        self.dataArr = [ZCColorModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        [self.collectionView reloadData];
    }];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
