//
//  ZCTrainClassAllInController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/16.
//

#import "ZCTrainClassAllInController.h"
#import "ZCTrainActionFilterView.h"
#import "ZCTrainFilterClassCategoryView.h"
#import "ZCTrainTargetClassCell.h"

@interface ZCTrainClassAllInController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) ZCTrainActionFilterView *filterView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSArray *categoryArr;

@property (nonatomic,strong) ZCTrainFilterClassCategoryView *categoryView;

@property (nonatomic,strong) NSArray *tagsIds;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger current;

@property (nonatomic, copy) NSString *apparatusId;

@end

@implementation ZCTrainClassAllInController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    self.filterView = [[ZCTrainActionFilterView alloc] init];
    [self.view addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
        make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(self.view.mas_leading);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.filterView.mas_bottom);
    }];
    
    self.signNoneView = YES;
    if ([checkSafeContent(self.params[@"type"]) isEqualToString:@"action"]) {
        if (checkSafeContent(self.params[@"name"]).length == 0) {
            self.filterView.dataArr = @[];
        } else {
            self.filterView.dataArr = @[self.params[@"name"]];
        }
        self.apparatusId = self.params[@"id"];
    }
    [self getClassListInfo];
    kweakself(self);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.current ++;
        [weakself getClassListInfo];
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [self.view addSubview:self.categoryView];
    self.categoryView.dataArr = self.categoryArr;
    self.categoryView.hidden = !self.categoryView.hidden;
    if (self.categoryView.hidden) {
        kweakself(self);
        self.categoryView.saveFilterData = ^(NSDictionary * _Nonnull dataDic) {
            weakself.filterView.dataArr = dataDic[@"name"];
            weakself.tagsIds = dataDic[@"id"];
            weakself.current = 1;
            [weakself getClassListInfo];
        };
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainTargetClassCell *cell = [ZCTrainTargetClassCell trainTargetClassCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    cell.backgroundColor = UIColor.whiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.row]];
    [HCRouter router:@"ClassDetail" params:dic viewController:self animated:YES];
}

- (void)getClassListInfo {
    NSDictionary *dic = @{@"tagsIds":self.tagsIds,
                          @"current":@(self.current),
                          @"apparatusId":checkSafeContent(self.apparatusId)
    };
    [ZCClassSportManage classListInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr = [ZCDataTool convertEffectiveData:responseObj[@"data"][@"records"]];
        if (self.current == 1) {            
            [self.dataArr removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            if (dataArr.count > 0) {
                self.noneView.hidden = YES;
            } else {
                self.noneView.hidden = NO;
            }
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:dataArr];
        [self.tableView reloadData];
        [self getTrainClassCategoryInfo];
    }];
}

- (void)getTrainClassCategoryInfo {
    [ZCClassSportManage classCategoryListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        NSArray *tagArr = [ZCDataTool convertEffectiveData:dataDic[@"tagsList"]];
        self.categoryArr = tagArr;
        
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.current = 1;
    self.titleStr = NSLocalizedString(@"全部课程", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        [_tableView registerClass:[ZCTrainTargetClassCell class] forCellReuseIdentifier:@"ZCTrainTargetClassCell"];
        
    }
    return _tableView;
}

- (ZCTrainFilterClassCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[ZCTrainFilterClassCategoryView alloc] init];
        _categoryView.frame = CGRectMake(0, NAV_BAR_HEIGHT+AUTO_MARGIN(10), SCREEN_W, SCREEN_H-(NAV_BAR_HEIGHT+AUTO_MARGIN(10)));
        _categoryView.hidden = YES;
    }
    return _categoryView;
}

- (NSArray *)tagsIds {
    if (!_tagsIds) {
        _tagsIds = @[];
    }
    return _tagsIds;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
