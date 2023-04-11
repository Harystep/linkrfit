//
//  ZCPersonalCenterController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCPersonalCenterController.h"
#import "ZCPersonalBaseDataTopView.h"
#import "ZCPensonalBottomView.h"
#import "ZCPersonalSportDataCell.h"
#import "ZCPersonalCenterDeviceCell.h"

@interface ZCPersonalCenterController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ZCPersonalBaseDataTopView *topView;

@property (nonatomic,strong) NSDictionary *sportDic;

@property (nonatomic,assign) NSInteger deviceFlag;

@property (nonatomic,strong) NSArray *deviceArr;//设备列表

@end

@implementation ZCPersonalCenterController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryUserBaseInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(TAB_BAR_HEIGHT);
    }];
    
    self.topView = [[ZCPersonalBaseDataTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(240)+AUTO_MARGIN(68))];
    self.tableView.tableHeaderView = self.topView;
    
    self.tableView.tableFooterView = [[ZCPensonalBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 172)];
            
    [self queryTrainTotalDataInfo];
    
    [self queryBindDeviceListInfo];
    
    kweakself(self);
    [RACObserve(kUserStore, refreshBindDevice) subscribeNext:^(id  _Nullable x) {
        [weakself queryBindDeviceListInfo];
    }];
    
}

#pragma -- mark 查询个人信息
- (void)queryUserBaseInfo {
    [ZCProfileManage getUserBaseInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"userinfo:%@", responseObj);
        self.topView.dataDic = responseObj[@"data"];
    }];
}
#pragma -- mark 查询训练信息
- (void)queryTrainTotalDataInfo {
    [ZCProfileManage queryTrainTotalDataInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"train:%@", responseObj);
        self.sportDic = responseObj[@"data"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+self.deviceFlag;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {        
        ZCPersonalSportDataCell *cell = [ZCPersonalSportDataCell personalSportDataCellWithTableView:tableView idnexPath:indexPath];
        if (self.sportDic != nil) {
            cell.dataDic = self.sportDic;
        }
        return cell;
    } else {
        ZCPersonalCenterDeviceCell *cell = [ZCPersonalCenterDeviceCell personalCenterDeviceCellWithTableView:tableView idnexPath:indexPath];
        cell.dataArr = self.deviceArr;
        return cell;
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"weight"]) {
        [self saveUserInfoWithData:userInfo];
    }
}

- (void)saveUserInfoWithData:(NSDictionary *)parm {
        
    [ZCProfileManage updateUserInfoOperate:parm completeHandler:^(id  _Nonnull responseObj) {
        [self queryUserBaseInfo];
    }];
}

#pragma -- mark 查询绑定设备列表信息
- (void)queryBindDeviceListInfo {
    [ZCClassSportManage queryUserBindDeviceListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        //188 284
        NSArray *dataArr = responseObj[@"data"];
        if (dataArr.count > 0) {
            self.deviceFlag = 1;
            self.deviceArr = dataArr;
            [self.tableView reloadData];
        } else {
            self.deviceFlag = 0;
            [self.tableView reloadData];
        }
    }];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [ZCConfigColor bgColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
            _tableView.sectionFooterHeight = 0;
        }        

        [_tableView registerClass:[ZCPersonalSportDataCell class] forCellReuseIdentifier:@"ZCPersonalSportDataCell"];
        [_tableView registerClass:[ZCPersonalCenterDeviceCell class] forCellReuseIdentifier:@"ZCPersonalCenterDeviceCell"];
        
    }
    return _tableView;
}


@end
