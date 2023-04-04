//
//  ZCActionDetailController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCActionDetailController.h"
#import "ZCActionDetailTopView.h"
#import "ZCActionStepCell.h"
#import "ZCActionAttentionCell.h"
#import "ZCActionBodyCell.h"

@interface ZCActionDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) ZCActionDetailTopView *topView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *actionStepList;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic, copy) NSString *pointsAttention;

@end

@implementation ZCActionDetailController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    self.topView = [[ZCActionDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(497+280))];
    self.tableView.tableHeaderView = self.topView;
    
    [self getActionDetailInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatPlay) name:kPlayVideoFinishKey object:nil];
}

- (void)repeatPlay {
    [self.topView continuePlay];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.actionStepList.count;
    } else if(section == 1) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZCActionStepCell *cell = [ZCActionStepCell actionStepWithTableView:tableView idnexPath:indexPath];
        cell.index = indexPath.row;
        cell.dataDic = self.actionStepList[indexPath.row];
        return cell;
    } else if(indexPath.section == 1)  {
        ZCActionAttentionCell *cell = [ZCActionAttentionCell actionAttentionCellWithTableView:tableView idnexPath:indexPath];
        cell.pointsAttention = self.pointsAttention;
        return cell;
    } else {
        ZCActionBodyCell *cell = [ZCActionBodyCell actionBodyCellWithTableView:tableView idnexPath:indexPath];
        cell.dataDic = self.dataDic;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)getActionDetailInfo {
    [ZCClassSportManage actionDetailInfo:@{@"id":checkSafeContent(self.params[@"actionId"])} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        self.dataDic = dataDic;
        self.topView.dataDic = dataDic;
        self.actionStepList = [ZCDataTool convertEffectiveData:dataDic[@"actionStepList"]];
        self.pointsAttention = dataDic[@"action"][@"pointsAttention"];
        [self.tableView reloadData];
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"动作详情", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZCActionStepCell class] forCellReuseIdentifier:@"ZCActionStepCell"];
        [_tableView registerClass:[ZCActionAttentionCell class] forCellReuseIdentifier:@"ZCActionAttentionCell"];
        [_tableView registerClass:[ZCActionBodyCell class] forCellReuseIdentifier:@"ZCActionBodyCell"];
        
    }
    return _tableView;
}

@end
