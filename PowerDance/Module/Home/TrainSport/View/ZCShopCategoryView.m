//
//  ZCShopCategoryView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/5.
//

#import "ZCShopCategoryView.h"
#import "ZCShopCategorySimpleCell.h"

@interface ZCShopCategoryView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCShopCategoryView

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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCShopCategorySimpleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCShopCategorySimpleCell" forIndexPath:indexPath];
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(60))/2.0, AUTO_MARGIN(200));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(20);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(20), AUTO_MARGIN(20), AUTO_MARGIN(20), AUTO_MARGIN(20));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCShopCategorySimpleCell class] forCellWithReuseIdentifier:@"ZCShopCategorySimpleCell"];
    }
    return _collectionView;
}

@end
