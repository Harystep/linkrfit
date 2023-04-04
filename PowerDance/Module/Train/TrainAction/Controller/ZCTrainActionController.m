//
//  ZCTrainActionController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCTrainActionController.h"
#import "ZCTrainActionFilterView.h"
#import "ZCTrainActionItemCell.h"
#import "ZCTrainFilterActionCategoryView.h"
#import "ZCCustomRestMouseView.h"

@interface ZCTrainActionController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) ZCTrainActionFilterView *filterView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSArray *categoryArr;

@property (nonatomic,strong) NSArray *tagsIds;

@property (nonatomic,strong) ZCTrainFilterActionCategoryView *categoryView;

@property (nonatomic,assign) NSInteger current;

@property (nonatomic, copy) NSString *apparatusId;

@end

@implementation ZCTrainActionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    self.current = 1;
    self.filterView = [[ZCTrainActionFilterView alloc] init];
    [self.view addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
        make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(self.view.mas_leading);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.filterView.mas_bottom);
    }];
    self.signNoneView = YES;
    kweakself(self);
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.current ++;
        [weakself getTrainActionListInfo];
    }];
    if ([checkSafeContent(self.params[@"type"]) isEqualToString:@"equipment"]) {//器械
        if (checkSafeContent(self.params[@"name"]).length == 0) {
            self.filterView.dataArr = @[];
        } else {
            self.filterView.dataArr = @[self.params[@"name"]];
        }
        self.apparatusId = self.params[@"id"];
        self.current = 1;
        [self getTrainActionListInfo];
    } else {
        if ([self.params[@"select"] integerValue] == 1) {//选择
            NSArray *temArr = self.params[@"data"];
            if (temArr.count > 0) {
                [self.dataArr addObjectsFromArray:self.params[@"data"]];
                NSInteger current = self.dataArr.count / 12;
                self.current = self.dataArr.count%12==0?current:(current+1);
                self.filterView.dataArr = self.params[@"type"];
                self.tagsIds = self.params[@"tags"];
                [self.collectionView reloadData];
            } else {
                [self getTrainActionListInfo];
            }
        } else {
            [self getTrainActionListInfo];
        }
    }
    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [self.view addSubview:self.categoryView];
    self.categoryView.dataArr = self.categoryArr;
    self.categoryView.hidden = !self.categoryView.hidden;
    if (self.categoryView.hidden) {
        kweakself(self);
        self.categoryView.saveFilterData = ^(NSDictionary * _Nonnull dataDic) {
            NSMutableArray *temArr = [NSMutableArray array];
            if ([checkSafeContent(weakself.params[@"type"]) isEqualToString:@"equipment"] && weakself.apparatusId.length > 0) {//器械
                [temArr addObjectsFromArray:@[weakself.params[@"name"]]];
            }
            [temArr addObjectsFromArray:dataDic[@"name"]];
            weakself.filterView.dataArr = temArr;
            weakself.tagsIds = dataDic[@"id"];
            weakself.current = 1;
            [weakself getTrainActionListInfo];
        };
        self.categoryView.cleanFilterData = ^{
            weakself.apparatusId = @"";
        };
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainActionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCTrainActionItemCell" forIndexPath:indexPath];
    cell.actionDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.params[@"select"] integerValue] == 1) {//选择
        NSDictionary *dic = self.dataArr[indexPath.row];
        ZCCustomRestMouseView *mouse = [[ZCCustomRestMouseView alloc] init];
        [self.view addSubview:mouse];
        mouse.titleL.text = NSLocalizedString(@"设置运动时间(秒)", nil);
        kweakself(self);
        mouse.sureRepeatOperate = ^(NSString * _Nonnull content) {
            NSString *duration = content;
            NSMutableDictionary *tem = [NSMutableDictionary dictionaryWithDictionary:dic];
            [tem setValue:duration forKey:@"duration"];
            weakself.callBackBlock(@{@"target":tem, @"normal":self.dataArr, @"type":self.filterView.dataArr, @"tags":weakself.tagsIds});
            [weakself.navigationController popViewControllerAnimated:YES];
        };
        [mouse showAlertView];
    } else {
        NSDictionary *dic = self.dataArr[indexPath.row];
        [HCRouter router:@"ActionDetail" params:dic viewController:self animated:YES];
    }
}

- (void)getTrainActionListInfo {
    NSDictionary *dic = @{@"tagsIds":self.tagsIds,
                          @"current":@(self.current),
                          @"apparatusId":checkSafeContent(self.apparatusId)
    };
    NSLog(@"%@", self.params);
    [ZCClassSportManage actionListInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr  = [ZCDataTool convertEffectiveData:responseObj[@"data"][@"records"]];
        if (self.current == 1) {
            [self.dataArr removeAllObjects];
            if (dataArr.count > 0) {
                self.noneView.hidden = YES;
            } else {
                self.noneView.hidden = NO;
            }
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:dataArr];
        [self.collectionView reloadData];
        
        [self getTrainActionCategoryInfo];
    }];
}

- (void)getTrainActionCategoryInfo {
    [ZCClassSportManage actionCategoryInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        NSArray *tagArr = [ZCDataTool convertEffectiveData:dataDic[@"tagsList"]];
        self.categoryArr = tagArr;
       
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"训练动作", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AUTO_MARGIN(100), AUTO_MARGIN(146));
        layout.minimumInteritemSpacing = AUTO_MARGIN(15);
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(15), AUTO_MARGIN(20), AUTO_MARGIN(15), AUTO_MARGIN(20));
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [ZCConfigColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCTrainActionItemCell class] forCellWithReuseIdentifier:@"ZCTrainActionItemCell"];
    }
    return _collectionView;
}

- (ZCTrainFilterActionCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[ZCTrainFilterActionCategoryView alloc] init];
        _categoryView.frame = CGRectMake(0, NAV_BAR_HEIGHT+AUTO_MARGIN(10), SCREEN_W, SCREEN_H-(NAV_BAR_HEIGHT+AUTO_MARGIN(10)));
        _categoryView.hidden = YES;
    }
    return _categoryView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSArray *)tagsIds {
    if (!_tagsIds) {
        _tagsIds = @[];
    }
    return _tagsIds;
}

@end
