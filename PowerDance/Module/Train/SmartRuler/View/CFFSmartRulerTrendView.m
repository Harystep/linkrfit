//
//  CFFSmartRulerTrendView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/20.
//

#import "CFFSmartRulerTrendView.h"
#import "CFFSmartRulerTrendCell.h"

@interface CFFSmartRulerTrendView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) double maxValue;

@end

@implementation CFFSmartRulerTrendView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(200));
    }];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.maxValue = [self convertMaxNumWithArray:dataArr];
    [self.collectionView reloadData];
}

- (double)convertMaxNumWithArray:(NSArray *)dataArr {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        [array addObject:[CFFDataTool reviseString:dic[@"weight"]]];
    }
    CGFloat maxValue = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
    return maxValue;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CFFSmartRulerTrendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFFSmartRulerTrendCell" forIndexPath:indexPath];
    cell.maxValues = self.maxValue;
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kCFF_SCREEN_WIDTH - AUTO_MARGIN(30))/7.0, 200);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[CFFSmartRulerTrendCell class] forCellWithReuseIdentifier:@"CFFSmartRulerTrendCell"];
    }
    return _collectionView;
}

@end
