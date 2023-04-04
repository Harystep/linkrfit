//
//  ZCAutoPracticeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/28.
//

#import "ZCAutoPracticeView.h"
#import "ZCAutoPracticeActionCell.h"
#import "ZCAutoPracticeTopView.h"

@interface ZCAutoPracticeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;



@end

@implementation ZCAutoPracticeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.tableView.tableHeaderView = [[ZCAutoPracticeTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(340))];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(90))];
    self.tableView.tableFooterView = footerView;
    UIButton *autoBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"自由动作组合训练", nil) font:AUTO_MARGIN(13) color:[ZCConfigColor whiteColor]];
    autoBtn.backgroundColor = [ZCConfigColor txtColor];
    [footerView addSubview:autoBtn];
    [autoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(footerView);
        make.leading.trailing.mas_equalTo(footerView).inset(AUTO_MARGIN(20));
    }];
    [autoBtn setImage:kIMAGE(@"train_add_nor") forState:UIControlStateNormal];
    [autoBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:2];
    [autoBtn setViewCornerRadiu:AUTO_MARGIN(10)];
    [autoBtn addTarget:self action:@selector(autoOperateAction) forControlEvents:UIControlEventTouchUpInside];
    kweakself(self);
    [RACObserve(kProfileStore, customActionRefresh) subscribeNext:^(id  _Nullable x) {
        [weakself getAutoActionTrainListInfo];
    }];
    
    [self getAutoActionTrainListInfo];
}

- (void)getAutoActionTrainListInfo {
    [ZCTrainManage getAutoActionTrainDataInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSArray *dataArr = [ZCDataTool convertEffectiveData:responseObj[@"data"][@"records"]];
        self.dataArr = dataArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)autoOperateAction {
    [HCRouter router:@"CustomActionTrain" params:@{} viewController:self.superViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCAutoPracticeActionCell *cell = [ZCAutoPracticeActionCell autoPracticeActionCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [HCRouter router:@"CustomActionDetail" params:dic viewController:self.superViewController animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZCAutoPracticeActionCell class] forCellReuseIdentifier:@"ZCAutoPracticeActionCell"];
        
    }
    return _tableView;
}

@end
