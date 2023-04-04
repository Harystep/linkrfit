//
//  ZCShowEquipmentController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/8.
//

#import "ZCShowEquipmentController.h"
#import "ZCSelectSportEquipmentCell.h"
#import "ZCEquipmentModel.h"

@interface ZCShowEquipmentController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCShowEquipmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    self.dataArr = [NSMutableArray array];
    
    for (NSDictionary *dic in self.params[@"data"]) {
        ZCEquipmentModel *model = [ZCEquipmentModel mj_objectWithKeyValues:dic];
        [self.dataArr addObject:model];
    }
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGINY(25));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCSelectSportEquipmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSelectSportEquipmentCell" forIndexPath:indexPath];    
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCEquipmentModel *model = self.dataArr[indexPath.row];
    if ([model.productId integerValue] > 0) {
        [HCRouter router:@"GoodsDetail" params:@{@"data":checkSafeContent(model.productId)} viewController:self animated:YES];
    }
}

- (void)configureBaseInfo {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    self.titleStr = NSLocalizedString(@"相关器材", nil);
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

@end
