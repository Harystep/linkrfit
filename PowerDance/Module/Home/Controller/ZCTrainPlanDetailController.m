//
//  ZCTrainPlanDetailController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCTrainPlanDetailController.h"
#import "ZCHomePlanClassCell.h"
#import "ZCTrainPlanDetailHeaderView.h"

@interface ZCTrainPlanDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) NSArray *sectionArr;

@end

@implementation ZCTrainPlanDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    
    NSDictionary *dataDic = self.params[@"data"];
    self.sectionArr = [self sortByDate:dataDic.allKeys];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = checkSafeContent(self.sectionArr[section]);
    NSDictionary *dataDic = self.params[@"data"];
    NSArray *dataArr = dataDic[key];
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCHomePlanClassCell *cell = [ZCHomePlanClassCell homePlanClassCell:tableView idnexPath:indexPath];
    NSString *key = checkSafeContent(self.sectionArr[indexPath.section]);
    NSDictionary *dataDic = self.params[@"data"];
    NSArray *dataArr = dataDic[key];
    cell.dataDic = dataArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    ZCTrainPlanDetailHeaderView *headView = [[ZCTrainPlanDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    headView.dayStr = self.sectionArr[section];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *key = checkSafeContent(self.sectionArr[indexPath.section]);
    NSDictionary *dataDic = self.params[@"data"];
    NSArray *dataArr = dataDic[key];
    NSDictionary *dic = dataArr[indexPath.row];
    NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [temDic setValue:checkSafeContent(temDic[@"planId"]) forKey:@"planId"];
    [HCRouter router:@"ClassDetail" params:temDic viewController:self animated:YES];
}

- (NSArray*)sortByDate:(NSArray*)objects
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *sortedArray = [objects sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSDate *d1 = [df dateFromString: obj1];
        NSDate *d2 = [df dateFromString: obj2];
        return [d1 compare: d2];
    }];

    return sortedArray;
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"计划详情", nil);
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
        [_tableView registerClass:[ZCHomePlanClassCell class] forCellReuseIdentifier:@"ZCHomePlanClassCell"];
        
    }
    return _tableView;
}

@end
