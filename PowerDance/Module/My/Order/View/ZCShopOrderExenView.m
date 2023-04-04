//
//  ZCShopOrderExenView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCShopOrderExenView.h"
#import "ZCShopOrderDetailCell.h"

@interface ZCShopOrderExenView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UIView *noneView;

@end

@implementation ZCShopOrderExenView

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
    
    [self.tableView addSubview:self.noneView];
    [self.noneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.centerY.mas_equalTo(self.tableView.mas_centerY);
    }];
    
    kweakself(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself quertOrderTypeInfo];
    }];
}

- (void)setType:(OrderType)type {
    _type = type;
    [self quertOrderTypeInfo];
}

- (void)quertOrderTypeInfo {
    NSString *type = @"";
    if (self.type == OrderTypeWaiting) {
        type = @"WAIT_COLLECT";
    } else {
        type = @"FINISH";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderFinishOperate) name:@"kOrderFinishKey" object:nil];
    }
    [ZCShopManage queryGoodsOrderListInfo:@{@"status":type} completeHandler:^(id  _Nonnull responseObj) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObj[@"code"] integerValue] == 200) {            
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:responseObj[@"data"]];
            if (self.dataArr.count > 0) {
                self.noneView.hidden = YES;
            } else {
                self.noneView.hidden = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];    
}

- (void)orderFinishOperate {
    [self quertOrderTypeInfo];
}

#pragma -- mark 确认收货
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    NSDictionary *dic = userInfo[@"data"];
    kweakself(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"确认已收货?", nil) message:NSLocalizedString(@"", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself finishOrderOperate:dic];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self.superViewController presentViewController:alert animated:YES completion:nil];
    
}

- (void)finishOrderOperate:(NSDictionary *)dic {
    [ZCShopManage sureOrdeReceiptOperate:@{@"outOrderNo":checkSafeContent(dic[@"outTradeNo"])} completeHandler:^(id  _Nonnull responseObj) {
        [self.dataArr removeObject:dic];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCShopOrderDetailCell *cell = [ZCShopOrderDetailCell shopOrderDetailCellWithTableView:tableView idnexPath:indexPath];
    cell.type = self.type;
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 100.f;
        _tableView.backgroundColor = rgba(246, 246, 246, 1);
        [_tableView registerClass:[ZCShopOrderDetailCell class] forCellReuseIdentifier:@"ZCShopOrderDetailCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc] init];
        UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"base_none_data")];
        [_noneView addSubview:iconIv];
        _noneView.userInteractionEnabled = NO;
        _noneView.hidden = YES;
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_noneView.mas_centerY);
            make.centerX.mas_equalTo(_noneView.mas_centerX);
        }];
        UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"暂无数据", nil) font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
        [lb setContentLineFeedStyle];
        lb.textAlignment = NSTextAlignmentCenter;
        [_noneView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(_noneView).inset(AUTO_MARGIN(15));
            make.top.mas_equalTo(iconIv.mas_bottom);
        }];
    }
    return _noneView;
}

@end
