//
//  ZCHistoryTrainCollectionView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCHistoryTrainView.h"
#import "ZCHomeHistoryTrainCell.h"
#import "ZCHomeHistoryTrainHeaderView.h"


@interface ZCHistoryTrainView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ZCHomeHistoryTrainHeaderView *headView;

@property (nonatomic,assign) NSInteger current;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *newArr;

@end

@implementation ZCHistoryTrainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.current = 1;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.leading.mas_equalTo(self);
    }];
//    self.headView = [[ZCHomeHistoryTrainHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(168))];
//    self.tableView.tableHeaderView = self.headView;
    kweakself(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.current = 1;
        [weakself queryHistoryListInfo];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.current ++;
        [weakself queryHistoryListInfo];
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    [RACObserve(kProfileStore, recordTrainRefresh) subscribeNext:^(id  _Nullable x) {
        [weakself queryHistoryListInfo];
    }];
    
    [self queryHistoryListInfo];
}

- (void)queryHistoryListInfo {
    [ZCTrainManage queryHistoryTrainDetailInfo:@{@"current":@(self.current)} completeHandler:^(id  _Nonnull responseObj) {
        NSDictionary *dataDic = responseObj[@"data"];
        NSArray *dataArr = dataDic[@"records"];
        NSMutableArray *temArr = [NSMutableArray arrayWithArray:dataArr];
        if (self.current == 1) {
            [self.dataArr removeAllObjects];
            [self.newArr removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            if (dataArr.count > 0) {
                NSDictionary *firstDic = dataArr[0];
                self.headView.dataDic = firstDic;
                [self.newArr addObject:firstDic];
                [temArr removeObject:firstDic];
            }
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:temArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(48))];
    if (self.newArr.count > 0) {
        if (section == 0) {
            UIImageView *timeIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_history")];
            [view addSubview:timeIv];
            [timeIv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(20));
                make.top.mas_equalTo(view.mas_top).offset(AUTO_MARGIN(10));
                make.height.width.mas_equalTo(18);
            }];
            UILabel *titleL = [view createSimpleLabelWithTitle:NSLocalizedString(@"最近一次", nil) font:16 bold:NO color:[ZCConfigColor txtColor]];
            [view addSubview:titleL];
            [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(timeIv.mas_trailing).offset(AUTO_MARGIN(10));
                make.centerY.mas_equalTo(timeIv.mas_centerY);
            }];
        } else {
            UILabel *titleL = [view createSimpleLabelWithTitle:NSLocalizedString(@"更早之前", nil) font:16 bold:NO color:[ZCConfigColor txtColor]];
            [view addSubview:titleL];
            [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(20));
                make.top.mas_equalTo(view.mas_top).offset(AUTO_MARGIN(20));
            }];
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTO_MARGIN(48);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.newArr.count > 0) {
        if (section == 0) {
            return 1;
        } else {
            return self.dataArr.count;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCHomeHistoryTrainCell *cell = [ZCHomeHistoryTrainCell homeHistoryTrainCellWithTableView:tableView idnexPath:indexPath];
    if (indexPath.section == 0) {
        cell.dataDic = self.newArr[indexPath.row];
    } else {
        cell.dataDic = self.dataArr[indexPath.row];
    }
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 100.f;
        [_tableView registerClass:[ZCHomeHistoryTrainCell class] forCellReuseIdentifier:@"ZCHomeHistoryTrainCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)newArr {
    if (!_newArr) {
        _newArr = [NSMutableArray array];
    }
    return _newArr;
}

@end
