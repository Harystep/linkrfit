//
//  ZCTrainFilterClassCategoryView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/29.
//

#import "ZCTrainFilterClassCategoryView.h"
#import "ZCSizingCollectCell.h"
#import "ZCTrainFilterCategoryHeaderView.h"

@interface ZCTrainFilterClassCategoryView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *selectArr;//选中

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,assign) CGFloat sizeHeight;

@end

@implementation ZCTrainFilterClassCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [btn addTarget:self action:@selector(clickOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.hidden = YES;
    self.bottomView = bottomView;
    bottomView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(90));
        make.top.mas_equalTo(self.collectionView.mas_bottom);
    }];
    
    [self createBottomViewSubviews:bottomView];
        
}

- (void)createBottomViewSubviews:(UIView *)bottomView {
    UIView *lineView = [[UIView alloc] init];
    [bottomView addSubview:lineView];
    lineView.backgroundColor = rgba(43, 42, 51, 0.1);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(bottomView);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    UIButton *sureBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:14 color:[ZCConfigColor whiteColor]];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    [bottomView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.trailing.mas_equalTo(bottomView.mas_trailing).inset(AUTO_MARGIN(20));
        make.leading.mas_equalTo(bottomView.mas_leading).offset(AUTO_MARGIN(75));
    }];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [sureBtn addTarget:self action:@selector(sureBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cleanBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"清除", nil) font:12 color:[ZCConfigColor txtColor]];
    [bottomView addSubview:cleanBtn];
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sureBtn.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(50));
        make.leading.mas_equalTo(bottomView.mas_leading).offset(AUTO_MARGIN(12));
    }];
    [cleanBtn setImage:kIMAGE(@"train_category_clean") forState:UIControlStateNormal];
    [cleanBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleTop space:4];
    [cleanBtn addTarget:self action:@selector(cleanBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)cleanBtnOperate {
    if (self.selectArr.count > 0) {
        [self.selectArr removeAllObjects];
        [self.collectionView reloadData];
    }
}


- (void)clickOperate {
    [self routerWithEventName:@"" userInfo:@{}];
}

- (void)sureBtnOperate {
    NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
    if (self.selectArr.count > 0) {
        NSMutableArray *nameArr = [NSMutableArray array];
        NSMutableArray *idArr = [NSMutableArray array];
        for (NSDictionary *dic in self.selectArr) {
            [nameArr addObject:checkSafeContent(dic[@"name"])];
            [idArr addObject:checkSafeContent(dic[@"id"])];
        }
        [temDic setValue:idArr forKey:@"id"];
        [temDic setValue:nameArr forKey:@"name"];
        [self routerWithEventName:@"" userInfo:@{}];
        if (self.saveFilterData) {
            self.saveFilterData(temDic);
        }
    } else {
        [temDic setValue:@[] forKey:@"id"];
        [temDic setValue:@[] forKey:@"name"];
        [self routerWithEventName:@"" userInfo:@{}];
        if (self.saveFilterData) {
            self.saveFilterData(temDic);
        }
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.sizeHeight == 0) {
                    self.sizeHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
                }
                self.sizeHeight = [self calculateViewHeight];
                self.backgroundColor = rgba(0, 0, 0, 0.4);
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(self.sizeHeight+AUTO_MARGIN(60));
                }];
                self.bottomView.hidden = NO;
            });
        });
    } else {
        [self getTrainClassCategoryInfo];
    }
}

- (CGFloat)calculateViewHeight {
    CGFloat autoSafeHeight = self.height - AUTO_MARGIN(90) - AUTO_MARGIN(60);
    if (self.sizeHeight > autoSafeHeight) {
        self.sizeHeight = autoSafeHeight;
    }
    return self.sizeHeight;
}

- (void)getTrainClassCategoryInfo {
    [ZCClassSportManage classCategoryListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        NSArray *tagArr = [ZCDataTool convertEffectiveData:dataDic[@"tagsList"]];
        self.dataArr = tagArr;
        [self.collectionView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.sizeHeight == 0) {
                self.sizeHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            }
            self.backgroundColor = rgba(0, 0, 0, 0.4);
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.sizeHeight+AUTO_MARGIN(60));
            }];
            self.bottomView.hidden = NO;
        });
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *dataArr = self.dataArr[section][@"children"];
    return dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCSizingCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSizingCollectCell" forIndexPath:indexPath];
    NSArray *dataArr = self.dataArr[indexPath.section][@"children"];
    NSDictionary *dic = dataArr[indexPath.row];
    [cell.textLabel setTitle:checkSafeContent(dic[@"name"]) forState:UIControlStateNormal];
    if ([self.selectArr containsObject:dic]) {
        [self configureViewStatus:cell.textLabel status:YES];
    } else {
        [self configureViewStatus:cell.textLabel status:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataArr = self.dataArr[indexPath.section][@"children"];
    NSDictionary *dic = dataArr[indexPath.row];
    if ([self.selectArr containsObject:dic]) {
        [self.selectArr removeObject:dic];
    } else {
        [self.selectArr addObject:dic];
    }
    [self.collectionView reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view;
    NSDictionary *dic = self.dataArr[indexPath.section];;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        ZCTrainFilterCategoryHeaderView *reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"filterHeader" forIndexPath:indexPath];
        reusableHeaderView.titleL.text = dic[@"name"];
        if (indexPath.section == 0) {
            reusableHeaderView.operateBtn.hidden = NO;
        } else {
            reusableHeaderView.operateBtn.hidden = YES;
        }
        return reusableHeaderView;
    } else {
        return view;
    }
}

- (void)configureViewStatus:(UIButton *)sender status:(BOOL)status {
    if (status) {
        [sender setTitleColor:[ZCConfigColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = [ZCConfigColor txtColor];
    } else {
        [sender setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
        sender.backgroundColor = [ZCConfigColor bgColor];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_W, AUTO_MARGIN(50));//宽默认

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
        layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        // 设置item的内边距
        layout.sectionInset = UIEdgeInsetsMake(0,20,0,20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZCSizingCollectCell class] forCellWithReuseIdentifier:@"ZCSizingCollectCell"];
        [_collectionView registerClass:[ZCTrainFilterCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"filterHeader"];
    }
    return _collectionView;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

@end
