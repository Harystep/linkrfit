//
//  ZCTrainActionFilterView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/16.
//

#import "ZCTrainActionFilterView.h"
#import "ZCSizingCollectCell.h"

@interface ZCTrainActionFilterView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCTrainActionFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(32));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(15));
    }];
    self.dataArr = @[NSLocalizedString(@"全部", nil)];
    
    UIButton *operateBtn = [[UIButton alloc] init];
    [self addSubview:operateBtn];
    [operateBtn setImage:kIMAGE(@"base_arrow_down") forState:UIControlStateNormal];
    [operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.collectionView.mas_centerY);
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
    [operateBtn addTarget:self action:@selector(operateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count == 0) {
        _dataArr = @[NSLocalizedString(@"全部", nil)];
    }
    [self.collectionView reloadData];
}

- (void)operateBtnClick {
    [self routerWithEventName:@"" userInfo:@{}];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCSizingCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSizingCollectCell" forIndexPath:indexPath];
    [cell.textLabel setTitle:self.dataArr[indexPath.row] forState:UIControlStateNormal];
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置具体属性
//        // 1.设置 最小行间距
//        layout.minimumLineSpacing = 0;
//        // 2.设置 最小列间距
//        layout. minimumInteritemSpacing  = 20;
        // 3.设置item块的大小 (可以用于自适应)
        layout.estimatedItemSize = CGSizeMake(20, 32);
        // 设置滑动的方向 (默认是竖着滑动的)
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        // 设置item的内边距
        layout.sectionInset = UIEdgeInsetsMake(0,20,0,20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZCSizingCollectCell class] forCellWithReuseIdentifier:@"ZCSizingCollectCell"];
    }
    return _collectionView;
}

@end
