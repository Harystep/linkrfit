//
//  ZCSelectEquipmentView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import "ZCSelectEquipmentView.h"
#import "ZCSelectEquipmentItem.h"

@interface ZCSelectEquipmentView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCSelectEquipmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(15));
    }];
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCSelectEquipmentItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSelectEquipmentItem" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    kweakself(self);
    cell.deleteItemOperate = ^(id value) {
        if (weakself.deleteSelectItem) {
            weakself.deleteSelectItem(value);
        }
    };
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AUTO_MARGIN(50), AUTO_MARGIN(50));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, AUTO_MARGIN(30));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCSelectEquipmentItem class] forCellWithReuseIdentifier:@"ZCSelectEquipmentItem"];
    }
    return _collectionView;
}

@end
