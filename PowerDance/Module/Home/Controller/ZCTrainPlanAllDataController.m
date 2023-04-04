//
//  ZCTrainPlanAllDataController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/30.
//

#import "ZCTrainPlanAllDataController.h"
#import "ZCTrainPlanDetailDataCell.h"
#import "ZCTrainPlanDetailItemCell.h"


@interface ZCTrainPlanAllDataController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ZCTrainPlanDetailDataCell *topView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSArray *chartArr;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic, copy) NSString *type;//按类型

@property (nonatomic,assign) NSInteger selectRow;

@property (nonatomic,assign) NSInteger selectedSegmentIndex;

@end

@implementation ZCTrainPlanAllDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    self.view.backgroundColor = [ZCConfigColor whiteColor];
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"日", nil), NSLocalizedString(@"周", nil), NSLocalizedString(@"月", nil)]];
    [control addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    control.selectedSegmentIndex = 2;
    [self.view addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(28));
    }];
    control.backgroundColor = [ZCConfigColor bgColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(control.mas_bottom);
    }];
    self.selectedSegmentIndex = 2;
    [self getTrainPlanTotalDataInfo:@"month"];
}

- (void)valueChanged:(UISegmentedControl *)segment {
    self.selectRow = 0;
    self.topView = nil;
    if ([segment selectedSegmentIndex] == 0) {//日
        [self getTrainPlanTotalDataInfo:@"day"];
    } else if ([segment selectedSegmentIndex] == 1) {//周
        [self getTrainPlanTotalDataInfo:@"week"];
    } else {//月
        [self getTrainPlanTotalDataInfo:@"month"];
    }
    self.selectedSegmentIndex = segment.selectedSegmentIndex;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"selectTimeItem"]) {
        self.selectRow = [userInfo[@"row"] integerValue];
        NSDictionary *dataDic = userInfo[@"data"];
        [self queryTrainClassInfo:dataDic];
    }
}

#pragma -- mark 查询数据统计
- (void)getTrainPlanTotalDataInfo:(NSString *)content {
    self.type = content;
    [ZCTrainManage queryTrainPlanAllDataInfoURL:@{@"code":content} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"all:%@", responseObj);
        NSArray *dataArr = responseObj[@"data"];
        self.chartArr = dataArr;
        if (dataArr.count > 0) {
            NSDictionary *dic = dataArr[0];
            [self queryTrainClassInfo:dic];
            self.dataDic = dic;
        }
    }];
}
#pragma -- mark 根据时间查询训练课程
- (void)queryTrainClassInfo:(NSDictionary *)dic {
    NSDictionary *parms = @{@"startTime":[checkSafeContent(dic[@"startTime"]) stringByReplacingOccurrencesOfString:@"/" withString:@"-"],
                            @"endTime":[checkSafeContent(dic[@"endTime"]) stringByReplacingOccurrencesOfString:@"/" withString:@"-"]
    };
    [ZCTrainManage queryTrainClassFromTimeURL:parms completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"class:%@", responseObj);
        self.dataArr = responseObj[@"data"][@"records"];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCTrainPlanDetailItemCell *cell = [ZCTrainPlanDetailItemCell trainPlanDetailItemCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.topView.type = self.selectedSegmentIndex;
    self.topView.dataDic = self.dataDic;
    self.topView.dataArr = self.chartArr;
    self.topView.selectRow = self.selectRow;
    return self.topView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 383;
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"全部运动", nil);
    self.navBgIcon.hidden = NO;
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [ZCConfigColor whiteColor];
        [_tableView registerClass:[ZCTrainPlanDetailItemCell class] forCellReuseIdentifier:@"ZCTrainPlanDetailItemCell"];
        
    }
    return _tableView;
}

- (ZCTrainPlanDetailDataCell *)topView {
    if (!_topView) {
        _topView = [[ZCTrainPlanDetailDataCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 383)];
    }
    return _topView;
}

@end
