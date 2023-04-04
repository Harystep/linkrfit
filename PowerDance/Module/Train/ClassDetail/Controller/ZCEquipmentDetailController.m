//
//  ZCEquipmentDetailController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentDetailController.h"
#import "ZCEquipmentDetailTopView.h"
#import "ZCEquipmentDescCell.h"
#import "ZCEquipmentActionCell.h"
#import "ZCEquipmentClassCell.h"

@interface ZCEquipmentDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ZCEquipmentDetailTopView *topView;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

@implementation ZCEquipmentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(-AUTO_MARGIN(STATUS_BAR_HEIGHT));
        make.bottom.leading.trailing.mas_equalTo(self.view);
    }];
    
    self.topView = [[ZCEquipmentDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(260))];
    self.tableView.tableHeaderView = self.topView;
        
    [self configureBaseInfo];
    
    [self getEquipmentDetailInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZCEquipmentDescCell *cell = [ZCEquipmentDescCell equipmentDescCellWithTableView:tableView idnexPath:indexPath];
        cell.dataDic = self.dataDic;
        return cell;
    } else if (indexPath.row == 1) {//动作
        ZCEquipmentClassCell *cell = [ZCEquipmentClassCell equipmentClassCellWithTableView:tableView idnexPath:indexPath];
        cell.dataDic = self.dataDic;
        return cell;
    } else {//课程
        ZCEquipmentActionCell *cell = [ZCEquipmentActionCell equipmentActionCellWithTableView:tableView idnexPath:indexPath];
        cell.dataDic = self.dataDic;
        return cell;
    }
}

- (void)getEquipmentDetailInfo {
    [ZCClassSportManage instrumentDetailInfo:@{@"id":checkSafeContent(self.params[@"id"])} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        self.dataDic = responseObj[@"data"];
        self.topView.dataDic = self.dataDic;
        [self.tableView reloadData];
    }];
}

- (void)buyBtnOperate {
    
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = @"";
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    
    UIButton *buyBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"购买商品", nil) font:AUTO_MARGIN(12) color:[ZCConfigColor whiteColor]];
    buyBtn.hidden = YES;
    [self.naviView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.trailing.mas_equalTo(self.naviView.mas_trailing).inset(AUTO_MARGIN(15));
        make.width.mas_equalTo(AUTO_MARGIN(100));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    [buyBtn setImage:kIMAGE(@"train_e_shop") forState:UIControlStateNormal];
    [buyBtn setViewCornerRadiu:AUTO_MARGIN(17)];
    [buyBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:2];
    buyBtn.backgroundColor = rgba(43, 42, 51, 0.5);
    [buyBtn addTarget:self action:@selector(buyBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
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
