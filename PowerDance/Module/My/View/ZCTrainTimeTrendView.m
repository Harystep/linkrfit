//
//  CFFSmartRulerTrendView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/20.
//

#import "ZCTrainTimeTrendView.h"
#import "ZCTrainTimeTrendCell.h"

@interface ZCTrainTimeTrendView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) double maxValue;

@property (nonatomic,strong) UIView *trainAlertView;

@end

@implementation ZCTrainTimeTrendView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"训练时长(H)", nil) font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(15));
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(150));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (self.dataArr.count == 0) {
        self.trainAlertView.hidden = NO;
        [self addSubview:self.trainAlertView];
        [self.trainAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(54));
        }];
    } else {
        self.trainAlertView.hidden = YES;
    }
    self.maxValue = [self convertMaxNumWithArray:dataArr];
    [self.collectionView reloadData];
}

- (double)convertMaxNumWithArray:(NSArray *)dataArr {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        [array addObject:[ZCDataTool reviseString:dic[@"content"]]];
    }
    CGFloat maxValue = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
    return maxValue;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainTimeTrendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFFSmartRulerTrendCell" forIndexPath:indexPath];
    cell.maxValues = self.maxValue;
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)btnOperate {
    [HCRouter router:@"TrainClassAllIn" params:@{} viewController:self.superViewController animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(30))/7.0, AUTO_MARGIN(150));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCTrainTimeTrendCell class] forCellWithReuseIdentifier:@"CFFSmartRulerTrendCell"];
    }
    return _collectionView;
}

- (UIView *)trainAlertView {
    if (!_trainAlertView) {
        _trainAlertView = [[UIView alloc] init];
        UIImageView *icon = [[UIImageView alloc] initWithImage:kIMAGE(@"my_train_alert_icon")];
        [_trainAlertView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_trainAlertView.mas_leading).offset(AUTO_MARGIN(20));
            make.top.mas_equalTo(_trainAlertView.mas_top);
        }];
        
        UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"立即开始训练以查看时长", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
        [_trainAlertView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(icon.mas_top).offset(AUTO_MARGIN(22));
            make.leading.mas_equalTo(icon.mas_trailing);
        }];
        
        ZCSimpleButton *btn = [self createShadowButtonWithTitle:NSLocalizedString(@"去训练", nil) font:14 color:[ZCConfigColor whiteColor]];
        [_trainAlertView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(icon.mas_trailing).offset(AUTO_MARGIN(34));
            make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(17));
            make.width.mas_equalTo(AUTO_MARGIN(110));
            make.height.mas_equalTo(AUTO_MARGIN(42));
        }];
        btn.backgroundColor = [ZCConfigColor txtColor];
        [btn setViewCornerRadiu:AUTO_MARGIN(21)];
        [btn addTarget:self action:@selector(btnOperate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trainAlertView;
}

@end
