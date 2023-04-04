//
//  ZCTrainPlanController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/1.
//

#import "ZCTrainPlanController.h"
#import "ZCSportGroupView.h"
#import "ZCSportActionCell.h"
#import "ZCSportActionFootView.h"
#import "ZCSportActionHeadView.h"
#import "ZCSportAddGroupCell.h"

@interface ZCTrainPlanController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UIButton *addBtn;

@property (nonatomic,strong) NSArray *simpleArr;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ZCTrainPlanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];        
    UIButton *nextBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"下一步", nil) font:15 color:UIColor.whiteColor];
    nextBtn.backgroundColor = [ZCConfigColor txtColor];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(98));
    }];
    [nextBtn addTarget:self action:@selector(nextOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(nextBtn.mas_top).inset(AUTO_MARGIN(10));
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.dataArr.count) {
        return 1;
    } else {
        NSDictionary *dic = self.dataArr[section];
        NSArray *dataArr = dic[@"actionList"];
        return dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataArr.count) {
        ZCSportAddGroupCell *cell = [ZCSportAddGroupCell sportAddGroupCellWithTableView:tableView idnexPath:indexPath];
        kweakself(self);
        cell.addNewGroupOperate = ^(NSInteger index) {
            [weakself addGroupOperate];
        };
        return cell;
    } else {
        
        ZCSportActionCell *cell = [ZCSportActionCell sportActionCellWithTableView:tableView idnexPath:indexPath];
        NSDictionary *dic  = self.dataArr[indexPath.section];
        NSArray *actionList = dic[@"actionList"];
        cell.dataDic = actionList[indexPath.row];
        return cell;
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"delete"]) {
        NSIndexPath *indexPath = userInfo[@"index"];
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
        NSMutableArray *temArr = [NSMutableArray arrayWithArray:temDic[@"actionList"]];
        [temArr removeObjectAtIndex:indexPath.row];
        [temDic setValue:temArr forKey:@"actionList"];
        [self.dataArr replaceObjectAtIndex:indexPath.section withObject:temDic];
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArr.count == section) {
        return [UIView new];
    } else {
        ZCSportActionHeadView *view = [[ZCSportActionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-AUTO_MARGIN(40), AUTO_MARGIN(50))];
        kweakself(self);
        view.dataDic = self.dataArr[section];
        view.changeGroupLoopOperate = ^(NSString * _Nonnull content) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakself.dataArr[section]];
            [weakself.dataArr removeObjectAtIndex:section];
            [dic setValue:checkSafeContent(content) forKey:@"loop"];
            [weakself.dataArr insertObject:dic atIndex:section];
        };
        view.changeGroupNameOperate = ^(NSString * _Nonnull content) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakself.dataArr[section]];
            [weakself.dataArr removeObjectAtIndex:section];
            [dic setValue:checkSafeContent(content) forKey:@"title"];
            [weakself.dataArr insertObject:dic atIndex:section];
        };
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataArr.count == section) {
        return [UIView new];
    }  else {
        ZCSportActionFootView *view = [[ZCSportActionFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-AUTO_MARGIN(40), AUTO_MARGIN(76))];
        kweakself(self);
        view.addSportActionOperate = ^{
            [HCRouter router:@"TrainSportGroup" params:@{} viewController:weakself animated:YES block:^(id  _Nonnull value) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakself.dataArr[section]];
                
                [weakself.dataArr removeObjectAtIndex:section];
                
                NSMutableArray *actionArr = [NSMutableArray arrayWithArray:dic[@"actionList"]];
                NSMutableDictionary *valueDic = [NSMutableDictionary dictionaryWithDictionary:value];
                [valueDic setValue:[NSString stringWithFormat:@"%tu", actionArr.count+1] forKey:@"sort"];
                [actionArr addObject:valueDic];
                [dic setValue:actionArr forKey:@"actionList"];
                [weakself.dataArr insertObject:dic atIndex:section];
                
                [weakself.tableView reloadData];
            }];
        };
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArr.count == section) {
        return 0.01;
    } else {
        return AUTO_MARGIN(76);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArr.count == section) {
        return 0.01;
    } else {
        return AUTO_MARGIN(50);
    }
}

- (void)addGroupOperate {
    [self.dataArr addObjectsFromArray:self.simpleArr];
    [self.tableView reloadData];
}

- (void)nextOperate {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.params[@"data"]];
    NSMutableArray *temList = [NSMutableArray array];
    
    for (NSDictionary *dic in self.dataArr) {
        NSArray *actionList = dic[@"actionList"];
        if (actionList.count > 0) {
            NSMutableDictionary *actionDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSMutableArray *itemArr = [NSMutableArray array];
            for (NSDictionary *itemDic in actionList) {
                NSMutableDictionary *tem = [NSMutableDictionary dictionaryWithDictionary:itemDic];
                [tem removeObjectForKey:@"name"];
                NSString *timeStr = itemDic[@"duration"];
                [tem setValue:[ZCDataTool convertStringTimeToMouse:timeStr] forKey:@"duration"];
                [itemArr addObject:tem];
            }
            [actionDic setValue:itemArr forKey:@"actionList"];
            
            [temList addObject:actionDic];
        }
    }
    
    [dic setValue:temList forKey:@"groupList"];
    if (temList.count > 0) {
        [HCRouter router:@"TrainConfigure" params:@{@"data":dic} viewController:self animated:YES];
    } else {
        [self.view makeToast:NSLocalizedString(@"请添加动作", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"定制自己的训练", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@{@"title":NSLocalizedString(@"动作组", nil),
                              @"loop":@"1",
                              @"sort":@"1",
                              @"energy":@"",
                              @"actionList":@[]
        }];
    }
    return _dataArr;
}
- (NSArray *)simpleArr {
    if (!_simpleArr) {
        _simpleArr = @[@{@"title":NSLocalizedString(@"动作组", nil),
                         @"loop":@"1",
                         @"energy":@"",
                         @"sort":@(self.dataArr.count + 1),
                         @"actionList":@[]
                    }];
    }
    return _simpleArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZCSportActionCell class] forCellReuseIdentifier:@"ZCSportActionCell"];
        [_tableView registerClass:[ZCSportAddGroupCell class] forCellReuseIdentifier:@"ZCSportAddGroupCell"];
    }
    return _tableView;
}

@end
