//
//  ZCHomeTrainSelectEquipmentGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeTrainSelectEquipmentGuideView.h"
#import "ZCEquipmentGuideItemCell.h"


@interface ZCHomeTrainSelectEquipmentGuideView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *selectView;

@property (nonatomic,strong) NSMutableArray *equipmentIDArr;//选择器械数据

@end

@implementation ZCHomeTrainSelectEquipmentGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.backgroundColor = [ZCConfigColor whiteColor];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_guide_bg")];
    [self addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"2、是否使用器械(可多选)", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];
        
    UIView *targetView = [[UIView alloc] init];
    [self addSubview:targetView];
    self.selectView = targetView;
    targetView.backgroundColor = [ZCConfigColor whiteColor];
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(222);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(20));        
    }];
    [targetView setViewCornerRadiu:5];
    [self configureTargetView:targetView];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [self addSubview:leftBtn];
    [leftBtn setImage:kIMAGE(@"home_guide_arrow_left") forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
    }];
    [leftBtn addTarget:self action:@selector(backOperate) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.alpha = 0.6;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [self addSubview:rightBtn];
    [rightBtn setImage:kIMAGE(@"home_guide_arrow_right") forState:UIControlStateNormal];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    [rightBtn addTarget:self action:@selector(nextOperate) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.alpha = 0.6;
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(250);
        make.top.mas_equalTo(targetView.mas_bottom);
    }];
    
    [self getEquipmentListInfo];
    
}

- (void)backOperate {
    [self routerWithEventName:@"equipmentBack" userInfo:@{}];
}

- (void)nextOperate {
    [self routerWithEventName:@"equipmentNext" userInfo:@{@"apparatusId":[NSMutableArray arrayWithArray:self.equipmentIDArr]}];
}

- (void)configureTargetView:(UIView *)targetView {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [targetView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(targetView).inset(1);
    }];
    [bgView layoutIfNeeded];
    [bgView configureLeftToRightViewColorGradient:bgView width:SCREEN_W-AUTO_MARGIN(56)*2-AUTO_MARGIN(20)*2 height:43 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:5];
    bgView.hidden = YES;
    
    UIButton *itemBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"不使用器械", nil) font:13 color:[ZCConfigColor txtColor]];
    [targetView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(targetView);
    }];
    itemBtn.titleLabel.font = FONT_BOLD(13);
    itemBtn.userInteractionEnabled = NO;
    //home_train_muscle
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTargetType:)];
    [targetView addGestureRecognizer:tap];
    
}

- (void)selectTargetType:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    [self setupTargetViewStatus:view status:YES];
    if (self.equipmentIDArr.count > 0) {
        [self.equipmentIDArr removeAllObjects];
        [self.collectionView reloadData];
    }
}

- (void)setupTargetViewStatus:(UIView *)view status:(BOOL)status {
    if (status) {
        for (UIView *item in view.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)item;
                [btn setTitleColor:[ZCConfigColor whiteColor] forState:UIControlStateNormal];
            }
            
            if ([item isKindOfClass:[UIImageView class]]) {
                item.hidden = NO;
            }
        }
        [view setViewBorderWithColor:1 color:[ZCConfigColor whiteColor]];
    } else {
        for (UIView *item in view.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)item;
                [btn setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
            }
            if ([item isKindOfClass:[UIImageView class]]) {
                item.hidden = YES;
            }
        }
        [view setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    }
}

- (void)getEquipmentListInfo {
    [ZCClassSportManage instrumentListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *listArr = responseObj[@"data"][@"records"];
        self.dataArr = [ZCDataTool convertEffectiveData:listArr];
        [self.collectionView reloadData];
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
    ZCEquipmentGuideItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCEquipmentGuideItemCell" forIndexPath:indexPath];
    cell.selectArr = self.equipmentIDArr;
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    if ([self.equipmentIDArr containsObject:checkSafeContent(dic[@"id"])]) {
        [self.equipmentIDArr removeObject:checkSafeContent(dic[@"id"])];
    } else {
        [self.equipmentIDArr addObject:checkSafeContent(dic[@"id"])];
    }
    if (self.equipmentIDArr.count > 0) {
        [self setupTargetViewStatus:self.selectView status:NO];
    } else {
        [self setupTargetViewStatus:self.selectView status:YES];
    }
    [self.collectionView reloadData];
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(105, 45);
        layout.sectionInset = UIEdgeInsetsMake(7, 12, 7, 12);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCEquipmentGuideItemCell class] forCellWithReuseIdentifier:@"ZCEquipmentGuideItemCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)equipmentIDArr {
    if (!_equipmentIDArr) {
        _equipmentIDArr = [NSMutableArray array];
    }
    return _equipmentIDArr;
}

@end
