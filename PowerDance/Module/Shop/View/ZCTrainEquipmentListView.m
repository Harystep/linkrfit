//
//  ZCTrainEquipmentListView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import "ZCTrainEquipmentListView.h"
#import "ZCEquipmentCategoryListView.h"
#import "ZCEquipmentCategoryView.h"

@interface ZCTrainEquipmentListView ()

@property (nonatomic,strong) ZCEquipmentCategoryListView *listView;
@property (nonatomic,strong) ZCEquipmentCategoryView *categoryView;
@property (nonatomic,assign) NSInteger current;
@property (nonatomic, copy) NSString *selectId;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCTrainEquipmentListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.current = 1;
    self.backgroundColor = [ZCConfigColor whiteColor];
    
    UIView *verView = [[UIView alloc] init];
    verView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:verView];
    [verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(100));
        make.width.mas_equalTo(AUTO_MARGIN(5));
    }];
    
    self.categoryView = [[ZCEquipmentCategoryView alloc] init];
    [self addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verView.mas_top);
        make.leading.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(verView.mas_leading);
    }];
    self.categoryView.backgroundColor = [ZCConfigColor bgColor];
    
    self.listView = [[ZCEquipmentCategoryListView alloc] init];
    [self addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verView.mas_top);
        make.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(5));
        make.leading.mas_equalTo(verView.mas_trailing);
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
            NSMutableArray *temArr = [NSMutableArray array];
            NSDictionary *temDic = @{@"id":@"", @"name":NSLocalizedString(@"全部", nil)};
            [temArr addObject:temDic];
            [temArr addObjectsFromArray:dataArr];
            self.categoryView.contentArr = temArr;
            NSDictionary *dic = temArr[0];
            self.selectId = checkSafeContent(dic[@"id"]);
            [self getEquipmentListInfo:checkSafeContent(dic[@"id"])];
        }
    }];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
