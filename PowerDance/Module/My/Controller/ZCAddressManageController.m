//
//  ZCAddressManageController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/5.
//

#import "ZCAddressManageController.h"
#import "ZCAddressManageItemCell.h"
#import "ZCShopAddressModel.h"

@interface ZCAddressManageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSArray *addressArr;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ZCAddressManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"地址管理", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(93));
    }];
    
    [self setupBottomView];
    
    [self getShopAddressListInfo];
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [ZCConfigColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(83));
    }];
    
    UIButton *addBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"添加地址", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [bottomView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(bottomView.mas_bottom).inset(AUTO_MARGIN(30));
        make.height.mas_equalTo(42);
    }];
    addBtn.backgroundColor = [ZCConfigColor txtColor];
    [addBtn setViewCornerRadiu:21];
    [addBtn addTarget:self action:@selector(addAddressOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAddressOperate {
    kweakself(self);
    [HCRouter router:@"CreateAddress" params:@{} viewController:self animated:YES block:^(id  _Nonnull value) {
        [weakself getShopAddressListInfo];
    }];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"edit"]) {
        kweakself(self);
        [HCRouter router:@"CreateAddress" params:userInfo viewController:self animated:YES block:^(id  _Nonnull value) {
            [weakself getShopAddressListInfo];
        }];
    }
}

#pragma -- mark 获取地址列表
- (void)getShopAddressListInfo {
    [ZCShopManage queryShopArriveAddressListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *addressList = responseObj[@"data"];
        [self configureNoneiewWithData:addressList title:@{@"title":@"还未添加收货地址", @"image":@"address_data_none"}];
        self.addressArr = [ZCShopAddressModel mj_objectArrayWithKeyValuesArray:addressList];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCAddressManageItemCell *cell = [ZCAddressManageItemCell addressManageItemCellWithTableView:tableView idnexPath:indexPath];
    cell.model = self.addressArr[indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [ZCConfigColor bgColor];
        [_tableView registerClass:[ZCAddressManageItemCell class] forCellReuseIdentifier:@"ZCAddressManageItemCell"];
        
    }
    return _tableView;
}

@end
