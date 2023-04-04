//
//  ZCCourseCategoryView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/10/31.
//

#import "ZCCourseCategoryView.h"
#import "ZCNoticeSimpleCell.h"
#import "ZCCourseCategoryTopView.h"

@interface ZCCourseCategoryView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) ZCCourseCategoryTopView *topView;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,copy) NSString *apparatusId;//器械id

@property (nonatomic,copy) NSString *tagId;//筛选条件id

@property (nonatomic,assign) NSInteger signRefreshFlag;//标记加载数据

@property (nonatomic,strong) NSMutableDictionary *tagsIdDic;//保存筛选条件

@end

@implementation ZCCourseCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.topView = [[ZCCourseCategoryTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(0.01))];
    self.tableView.tableHeaderView = self.topView;
    kweakself(self);
    self.topView.cleanFilterDataOp = ^{
        [weakself cleanFilterData];
    };
    
    self.currentPage = 1;
    self.tagsIdDic = [NSMutableDictionary dictionary];
}

- (void)cleanFilterData {
    self.tagsIdDic = [NSMutableDictionary dictionary];
    [self queryClassListInfo];
}

#pragma -- mark 初始设置
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.signRefreshFlag = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:[NSString stringWithFormat:@"kProductCategoryIndex%tu", index] object:nil];
}

- (void)refreshData:(NSNotification *)noti {
    if (self.signRefreshFlag) {
    } else {
        self.signRefreshFlag = YES;
        NSDictionary *dic = noti.object;
        NSInteger tagId = [dic[@"id"] integerValue];
        if (tagId > 0) {
            self.apparatusId = [NSString stringWithFormat:@"%tu", tagId];
        } else {
            self.apparatusId = @"";
        }
        [self getEquipmentCaregoryInfo];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCNoticeSimpleCell *cell = [ZCNoticeSimpleCell noticeSimpleCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [HCRouter router:@"ClassDetail" params:dic viewController:self.superViewController animated:YES];
}
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"tag"]) {
        self.currentPage = 1;
        NSInteger index = [userInfo[@"index"] integerValue];
        self.tagId = checkSafeContent(userInfo[@"id"]);
        NSString *key = [NSString stringWithFormat:@"tag%tu", index];
        [self.tagsIdDic setValue:checkSafeContent(userInfo[key]) forKey:key];
        [self queryClassListInfo];
    }
}

- (void)queryClassListInfo {
    NSArray *valueArr = self.tagsIdDic.allValues;
    NSDictionary *dic = @{@"current":@(self.currentPage),
                          @"apparatusId":checkSafeContent(self.apparatusId),
                          @"tagsIds":valueArr
    };
    NSLog(@"%@", dic);
    [ZCTrainManage queryCourseListInfoURL:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr = responseObj[@"data"][@"records"];
        if (self.currentPage == 1) {
            [self.dataArr removeAllObjects];
            [self configureNoneViewWithData:dataArr];
        }
        [self.dataArr addObjectsFromArray:dataArr];
        [self.tableView reloadData];
    }];
}

#pragma -- mark 查询器械分类
- (void)getEquipmentCaregoryInfo {
    [ZCTrainManage queryCourseTagListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr = responseObj[@"data"][@"tagsList"];
        if (dataArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect newFrame = self.topView.frame;
                newFrame.size.height = (AUTO_MARGIN(42)*dataArr.count + AUTO_MARGIN(45) + AUTO_MARGIN(15));
                self.topView.frame = newFrame;
                [self.tableView beginUpdates];
                [self.tableView setTableHeaderView:self.topView];
                [self.tableView endUpdates];
                self.topView.categoryArr = dataArr;
            });
        }
        [self queryClassListInfo];
        
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 100.f;
        [_tableView registerClass:[ZCNoticeSimpleCell class] forCellReuseIdentifier:@"ZCNoticeSimpleCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
