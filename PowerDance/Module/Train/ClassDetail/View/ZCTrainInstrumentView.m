//
//  ZCTrainInstrumentView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/6.
//

#import "ZCTrainInstrumentView.h"
#import "ZCTrainInstrumentUsedCell.h"

@interface ZCTrainInstrumentView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCTrainInstrumentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.leading.trailing.mas_equalTo(self);
        make.bottom.top.mas_equalTo(self);
    }];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainInstrumentUsedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCTrainInstrumentUsedCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [HCRouter router:@"EquipmentDetail" params:dic viewController:self.superViewController animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AUTO_MARGIN(50), AUTO_MARGIN(50));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(0), AUTO_MARGIN(15), AUTO_MARGIN(0), AUTO_MARGIN(15));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCTrainInstrumentUsedCell class] forCellWithReuseIdentifier:@"ZCTrainInstrumentUsedCell"];
    }
    return _collectionView;
}

@end
