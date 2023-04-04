//
//  ZCTrainPlanDetailChartDataView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/1.
//

#import "ZCTrainPlanDetailChartDataView.h"
#import "ZCTrainPlanDetailChartItemCell.h"

@interface ZCTrainPlanDetailChartDataView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger maxValue;

@property (nonatomic,strong) UIView *trainAlertView;

@property (nonatomic,strong) NSMutableArray *viewArr;

@property (nonatomic,assign) NSInteger selectRow;//选中行

@end

@implementation ZCTrainPlanDetailChartDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
//  383 - 181 = 202
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(self).inset(AUTO_MARGIN(26));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.mas_bottom).inset(40);
    }];
    
    UILabel *zeroL = [self createSimpleLabelWithTitle:@"0" font:9 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self addSubview:zeroL];
    [zeroL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(40));
        make.trailing.mas_equalTo(lineView.mas_leading);
    }];
    zeroL.textAlignment = NSTextAlignmentCenter;
    
    UILabel *unitL = [self createSimpleLabelWithTitle:NSLocalizedString(@"Y_分钟", nil) font:9 bold:NO color:[ZCConfigColor point6TxtColor]];
    [self addSubview:unitL];
    [unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(zeroL.mas_centerX);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    self.viewArr = [NSMutableArray array];
    
    CGFloat height = 383 - 90 - 90 - 10;
    for (int i = 5; i > 0; i --) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(26), height-160+120-24*i, SCREEN_W-AUTO_MARGIN(66), 1)];
        [self addSubview:line];
        [self drawLineOfDashByCAShapeLayer:line lineLength:4 lineSpacing:2 lineColor:[ZCConfigColor bgColor] lineDirection:YES];
        UILabel *lb = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%d", i*10] font:9 bold:NO color:[ZCConfigColor point6TxtColor]];
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(line.mas_centerY);
            make.width.mas_equalTo(AUTO_MARGIN(42));
            make.trailing.mas_equalTo(line.mas_leading);
        }];
        lb.textAlignment = NSTextAlignmentCenter;
        [self.viewArr addObject:lb];
    }
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(190);
    }];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count > 0) {        
        self.maxValue = [self convertMaxNumWithArray:dataArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        NSArray *numArr = @[];
        NSInteger maxNum = self.maxValue / 60;
        if (self.maxValue%300) {
            for (int i = 1; i < 6; i ++) {
                maxNum = maxNum + i;
                if (maxNum%5 == 0) {
                    break;
                }
            }
            numArr = @[@(maxNum), @(maxNum*0.8), @(maxNum*0.6), @(maxNum*0.4), @(maxNum*0.2)];
        } else {
            numArr = @[@(maxNum), @(maxNum*0.8), @(maxNum*0.6), @(maxNum*0.4), @(maxNum*0.2)];
        }
        for (int i = 0; i < numArr.count; i ++) {
            UILabel *lb = self.viewArr[i];
            lb.text = checkSafeContent(numArr[i]);
        }
    }
}

- (NSInteger)convertMaxNumWithArray:(NSArray *)dataArr {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        [array addObject:[ZCDataTool reviseString:dic[@"duration"]]];
    }
    NSInteger maxValue = [[array valueForKeyPath:@"@max.integerValue"] integerValue];
    return maxValue;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainPlanDetailChartItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCTrainPlanDetailChartItemCell" forIndexPath:indexPath];
    if (indexPath.row == self.selectRow) {
        cell.selectFlag = YES;
    } else {
        cell.selectFlag = NO;
    }
    cell.type = self.selectedSegmentIndex;
    cell.maxValues = self.maxValue/1.0;
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectRow = indexPath.row;
    [self routerWithEventName:@"selectTimeItem" userInfo:@{@"row":@(indexPath.row), @"data":self.dataArr[indexPath.row]}];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(30))/7.0, 190);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCTrainPlanDetailChartItemCell class] forCellWithReuseIdentifier:@"ZCTrainPlanDetailChartItemCell"];
    }
    return _collectionView;
}

- (UIView *)trainAlertView {
    if (!_trainAlertView) {
        _trainAlertView = [[UIView alloc] init];
        _trainAlertView.hidden = YES;
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
