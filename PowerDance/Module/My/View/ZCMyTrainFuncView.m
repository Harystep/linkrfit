//
//  ZCMyTrainFuncView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/8.
//

#import "ZCMyTrainFuncView.h"
#import "ZCMyTrainFuncSimpleCell.h"


@interface ZCMyTrainFuncView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *imageArr;

@end

@implementation ZCMyTrainFuncView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(225));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCMyTrainFuncSimpleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCMyTrainFuncSimpleCell" forIndexPath:indexPath];
    cell.dataDic = self.imageArr[indexPath.row];
    cell.content = self.dataArr[indexPath.row];
    return cell;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;   
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(55))/2.0, AUTO_MARGIN(90));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCMyTrainFuncSimpleCell class] forCellWithReuseIdentifier:@"ZCMyTrainFuncSimpleCell"];
    }
    
    
    return _collectionView;
}

- (NSArray *)imageArr {
    if (!_imageArr) {
        _imageArr = @[@{@"title":NSLocalizedString(@"训练总时长", nil), @"image":@"train_total_time"}, @{@"image":@"energe_mouse", @"title":NSLocalizedString(@"能量总消耗", nil)}, @{@"image":@"train_finish_count", @"title":NSLocalizedString(@"完成训练数", nil)},  @{@"image":@"train_sleep", @"title":NSLocalizedString(@"休息占比", nil)}];
    }
    return _imageArr;
}

@end
