//
//  ZCSuitFollowView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCSuitFollowView.h"
#import "ZCTrainActionSimpleCell.h"
#import "ZCTrainClassItemCell.h"
#import "ZCSuitFollowTestCell.h"

@interface ZCSuitFollowView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *classArr;

@property (nonatomic,strong) NSArray *equipmentArr;

@property (nonatomic,strong) NSArray *actionArr;

@end

@implementation ZCSuitFollowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor bgColor];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    kweakself(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself getClassListInfo];
            [weakself getTrainActionListInfo];
            [weakself.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self getClassListInfo];
    [self getTrainActionListInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.row == 0) {
       ZCTrainActionSimpleCell *cell = [ZCTrainActionSimpleCell trainActionCellWithTableView:tableView idnexPath:indexPath];
       cell.dataArr = self.actionArr;
       return cell;
   } else if (indexPath.row == 1) {
       ZCTrainClassItemCell *cell = [ZCTrainClassItemCell trainClassItemCellWithTableView:tableView idnexPath:indexPath];
       cell.dataArr = self.classArr;
       return cell;
   } else {
       ZCSuitFollowTestCell *cell = [ZCSuitFollowTestCell suitFollowTestCellWithTableView:tableView idnexPath:indexPath];
       return cell;
   }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        
    }
}

- (void)getClassListInfo {
    NSDictionary *dic = @{@"tagsIds":@[],
                          @"current":@"1"
    };
    [ZCClassSportManage classListInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr = [ZCDataTool convertEffectiveData:responseObj[@"data"][@"records"]];
        self.classArr = [ZCDataTool convertEffectiveData:dataArr];
        [ZCDataTool saveTrainGoodListInfo:self.classArr];
        [self.tableView reloadData];
    }];
}

- (void)getTrainActionListInfo {
    NSDictionary *dic = @{@"tagsIds":@[],
                          @"current":@"1"
    };
    [ZCClassSportManage actionListInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr = [ZCDataTool convertEffectiveData:responseObj[@"data"][@"records"]];
        self.actionArr = [ZCDataTool convertEffectiveData:dataArr];
        if (dataArr.count > 0) {
            [ZCDataTool saveTrainActionListInfo:dataArr];
            [self.tableView reloadData];
        }
        
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.estimatedRowHeight = AUTO_MARGIN(500.0);        
        [_tableView registerClass:[ZCTrainActionSimpleCell class] forCellReuseIdentifier:@"ZCTrainActionSimpleCell"];
        [_tableView registerClass:[ZCTrainClassItemCell class] forCellReuseIdentifier:@"ZCTrainClassItemCell"];
        //
        [_tableView registerClass:[ZCSuitFollowTestCell class] forCellReuseIdentifier:@"ZCSuitFollowTestCell"];
    }
    return _tableView;
}

@end
