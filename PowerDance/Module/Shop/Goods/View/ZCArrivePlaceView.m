//
//  ZCArrivePlaceView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCArrivePlaceView.h"
#import "ZCShopArriveAddressCell.h"
#import "ZCShopAddressModel.h"

@interface ZCArrivePlaceView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,strong) ZCShopAddressModel *selectModel;

@end

@implementation ZCArrivePlaceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.selectIndex = -1;
    self.backgroundColor = [ZCConfigColor whiteColor];
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"选择收货地址", nil) font:15 bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(30));
    }];
    
    UIView *lineSep = [[UIView alloc] init];
    lineSep.backgroundColor = rgba(43, 42, 51, 0.1);
    [self addSubview:lineSep];
    [lineSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(25));
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
    
    UIButton *sureBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"确定", nil) font:14 color:[ZCConfigColor whiteColor]];
    [self addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(70));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    [sureBtn addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(17)];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    
    UIButton *addView = [self createSimpleButtonWithTitle:NSLocalizedString(@"新建收货地址", nil) font:14 color:[ZCConfigColor txtColor]];
    [self addSubview:addView];
    addView.backgroundColor = rgba(173, 173, 173, 0.1);
//    [addView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lineSep.mas_bottom).offset(AUTO_MARGIN(14));
        make.height.mas_equalTo(AUTO_MARGIN(70));
    }];
    [addView setImage:kIMAGE(@"train_add_black") forState:UIControlStateNormal];
    [addView dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:4];
    [addView addTarget:self action:@selector(addViewOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.top.mas_equalTo(addView.mas_bottom);
    }];
    
}

- (void)sureOperate {
    if (self.selectModel != nil) {
        if (self.sureAddressOperate) {
            self.sureAddressOperate(self.selectModel);
        }
    } else {
        [self makeToast:NSLocalizedString(@"请选择收货地址", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)addViewOperate {
    kweakself(self);
    [HCRouter router:@"CreateAddress" params:@{} viewController:self.superViewController animated:YES block:^(id  _Nonnull value) {
        [weakself resetSelectData];
        [weakself getShopAddressListInfo];
    }];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    kweakself(self);
    [HCRouter router:@"CreateAddress" params:@{@"model":userInfo[@"model"]} viewController:self.superViewController animated:YES block:^(id  _Nonnull value) {
        [weakself resetSelectData];
        [weakself getShopAddressListInfo];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCShopArriveAddressCell *cell = [ZCShopArriveAddressCell shopArriveAddressCellWithTableView:tableView idnexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectModel != nil) {
        ZCShopAddressModel *model = self.dataArr[indexPath.row];
        if (![self.selectModel.ID isEqualToString:model.ID]) {
            
            [self.dataArr removeObject:self.selectModel];
            self.selectModel.status = @"0";
            [self.dataArr insertObject:self.selectModel atIndex:self.selectIndex];
            
            self.selectIndex = indexPath.row;
            ZCShopAddressModel *model = self.dataArr[indexPath.row];
            [self.dataArr removeObject:model];
            model.status = @"1";
            self.selectModel = model;
            [self.dataArr insertObject:self.selectModel atIndex:indexPath.row];
        } else {
            [self.dataArr removeObject:self.selectModel];
            self.selectModel.status = @"0";
            [self.dataArr insertObject:self.selectModel atIndex:self.selectIndex];
            [self resetSelectData];
        }
        [self.tableView reloadData];
    } else {
        self.selectIndex = indexPath.row;
        ZCShopAddressModel *model = self.dataArr[indexPath.row];
        [self.dataArr removeObject:model];
        model.status = @"1";
        self.selectModel = model;
        [self.dataArr insertObject:self.selectModel atIndex:indexPath.row];
        
        [self.tableView reloadData];
    }
}

- (void)resetSelectData {
    self.selectIndex = -1;
    self.selectModel = nil;
}

#pragma -- mark 获取地址列表
- (void)getShopAddressListInfo {
    [ZCShopManage queryShopArriveAddressListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *addressList = responseObj[@"data"];
        NSMutableArray *temArr = [NSMutableArray array];
        for (NSDictionary *dic in addressList) {
            NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [temDic setValue:@"0" forKey:@"status"];
            ZCShopAddressModel *model = [ZCShopAddressModel mj_objectWithKeyValues:temDic];
            [temArr addObject:model];
        }
        self.dataArr = temArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZCShopArriveAddressCell class] forCellReuseIdentifier:@"ZCShopArriveAddressCell"];
        
    }
    return _tableView;
}

@end
