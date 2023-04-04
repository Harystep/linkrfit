//
//  ZCEquipmentCategoryListView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentCategoryListView.h"
#import "ZCEquipmentCategoryListItemCell.h"

@interface ZCEquipmentCategoryListView ()<UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation ZCEquipmentCategoryListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCEquipmentCategoryListItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCEquipmentCategoryListItemCell" forIndexPath:indexPath];
    cell.dataDic = self.listArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.listArr[indexPath.row];
    [HCRouter router:@"EquipmentDetail" params:dic viewController:self.superViewController animated:YES];
}

- (void)setListArr:(NSArray *)listArr {
    _listArr = listArr;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(100) - 45)/2.0, AUTO_MARGIN(180));
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [ZCConfigColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCEquipmentCategoryListItemCell class] forCellWithReuseIdentifier:@"ZCEquipmentCategoryListItemCell"];
    }
    return _collectionView;
}

@end
