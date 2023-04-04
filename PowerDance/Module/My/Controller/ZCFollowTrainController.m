//
//  ZCFollowTrainController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/3.
//

#import "ZCFollowTrainController.h"
#import "ZCEquipmentDetailTopView.h"
#import "ZCEquipmentDescCell.h"
#import "ZCEquipmentActionCell.h"
#import "ZCEquipmentClassCell.h"

@interface ZCFollowTrainController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ZCEquipmentDetailTopView *topView;

@property (nonatomic,strong) NSMutableDictionary *dataDic;

@end

@implementation ZCFollowTrainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataDic = [NSMutableDictionary dictionary];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_BAR_HEIGHT);
        make.bottom.leading.trailing.mas_equalTo(self.view);
    }];
        
    [self configureBaseInfo];
    
    [self getEquipmentDetailInfo];
    
    [self queryCourseListInfo];
    [self queryActionTrainInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {//动作
        ZCEquipmentClassCell *cell = [ZCEquipmentClassCell equipmentClassCellWithTableView:tableView idnexPath:indexPath];
        cell.dataDic = self.dataDic;
        return cell;
    } else {//课程
        ZCEquipmentActionCell *cell = [ZCEquipmentActionCell equipmentActionCellWithTableView:tableView idnexPath:indexPath];
        cell.dataDic = self.dataDic;
        return cell;
    }
}

- (void)queryActionTrainInfo {
    [ZCClassSportManage actionListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        [self.dataDic setValue:responseObj[@"data"][@"records"] forKey:@"actionList"];
        [self queryCourseListInfo];
    }];
}

- (void)queryCourseListInfo {
    [ZCClassSportManage classListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"class:%@", responseObj);
        [self.dataDic setValue:responseObj[@"data"][@"records"] forKey:@"courseList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)getEquipmentDetailInfo {
    [ZCClassSportManage instrumentDetailInfo:@{@"id":checkSafeContent(self.params[@"id"])} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        self.dataDic = responseObj[@"data"];
        self.topView.dataDic = self.dataDic;
        [self.tableView reloadData];
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"跟随练", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
            
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZCEquipmentDescCell class] forCellReuseIdentifier:@"ZCEquipmentDescCell"];
        [_tableView registerClass:[ZCEquipmentActionCell class] forCellReuseIdentifier:@"ZCEquipmentActionCell"];
        [_tableView registerClass:[ZCEquipmentClassCell class] forCellReuseIdentifier:@"ZCEquipmentClassCell"];
        
    }
    return _tableView;
}

@end
