//
//  ZCTrainEquipmentController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCTrainEquipmentController.h"
#import "ZCEquipmentCategoryListView.h"
#import "ZCEquipmentCategoryView.h"

@interface ZCTrainEquipmentController ()

@property (nonatomic,strong) ZCEquipmentCategoryListView *listView;
@property (nonatomic,strong) ZCEquipmentCategoryView *categoryView;
@property (nonatomic,assign) NSInteger current;
@property (nonatomic, copy) NSString *selectId;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCTrainEquipmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(246, 246, 246, 1);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(5));
    }];
    UIView *verView = [[UIView alloc] init];
    verView.backgroundColor = rgba(246, 246, 246, 1);
    [self.view addSubview:verView];
    [verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.leading.mas_equalTo(self.view.mas_leading).offset(AUTO_MARGIN(120));
        make.width.mas_equalTo(AUTO_MARGIN(5));
    }];
    
    self.categoryView = [[ZCEquipmentCategoryView alloc] init];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.leading.bottom.mas_equalTo(self.view);
        make.trailing.mas_equalTo(verView.mas_leading);
    }];
    
    self.listView = [[ZCEquipmentCategoryListView alloc] init];
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.trailing.bottom.mas_equalTo(self.view);
        make.leading.mas_equalTo(verView.mas_trailing);
    }];
    
    [self.listView addSubview:self.noneView];
    [self.noneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.listView.mas_centerX);
        make.centerY.mas_equalTo(self.listView.mas_centerY);
    }];
    
    [self getEquipmentCategoryInfo];
    kweakself(self)
    self.listView.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.current ++;
        [weakself getEquipmentListInfo:weakself.selectId];
    }];
    self.listView.collectionView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    self.current = 1;
    self.selectId = checkSafeContent(userInfo[@"id"]);
    [self getEquipmentListInfo:checkSafeContent(userInfo[@"id"])];
}

- (void)getEquipmentListInfo:(NSString *)tagsId {
    [ZCClassSportManage instrumentListInfo:@{@"tagsId":tagsId, @"current":@(self.current)} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *listArr = responseObj[@"data"][@"records"];
        if (self.current == 1) {
            [self.dataArr removeAllObjects];
            if (listArr.count > 0) {
                self.noneView.hidden = YES;
            } else {
                self.noneView.hidden = NO;
            }
        } else {
            [self.listView.collectionView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:listArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listView.listArr = self.dataArr;
        });
    }];
}

- (void)getEquipmentCategoryInfo {
    [ZCClassSportManage instrumentCategoryListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSArray *dataArr = [ZCDataTool convertEffectiveData:responseObj[@"data"]];
        if (dataArr.count > 0) {
            self.categoryView.contentArr = dataArr;
            NSDictionary *dic = dataArr[0];
            self.selectId = checkSafeContent(dic[@"id"]);
            [self getEquipmentListInfo:checkSafeContent(dic[@"id"])];
        }
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.current = 1;
    self.titleStr = NSLocalizedString(@"训练器械", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.view.backgroundColor = [ZCConfigColor whiteColor];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
