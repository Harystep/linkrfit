//
//  ZCTrainTimerHistoryController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/29.
//

#import "ZCTrainTimerHistoryController.h"
#import "ZCTrainHistoryItemCell.h"

@interface ZCTrainTimerHistoryController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCTrainTimerHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    [self getTrainHistoryListInfo];
}

- (void)getTrainHistoryListInfo {
    [ZCTrainManage queryTrainHistoryListInfoURL:@{@"id":@"1"} completeHandler:^(id  _Nonnull responseObj) {
        self.dataArr = responseObj[@"data"];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainHistoryItemCell *cell = [ZCTrainHistoryItemCell trainHistoryItemCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    [HCRouter router:@"TrainDetail" params:@{@"id":checkSafeContent(dataDic[@"trainId"])} viewController:self animated:YES];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"更多训练记录", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [ZCConfigColor bgColor];
        [_tableView registerClass:[ZCTrainHistoryItemCell class] forCellReuseIdentifier:@"ZCTrainHistoryItemCell"];
        
    }
    return _tableView;
}

@end
