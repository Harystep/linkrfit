//
//  ZCTimerWRCModeController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import "ZCTimerWRCModeController.h"
#import "ZCTrainModeOperateView.h"
#import "ZCWRCModelSimpleCell.h"
#import "ZCAlertPickerView.h"
#import "BLETimerServer.h"

@interface ZCTimerWRCModeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UILabel *roundL;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *dataStr;

@property (nonatomic,assign) BOOL setFlag;

@property (nonatomic,strong) ZCTrainModeOperateView *operateView;

@end

@implementation ZCTimerWRCModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
        
    [self setupContentSubviews];
    
    [self setupBottomOperateView];
}

- (void)setupContentSubviews {
    
    UILabel *lb = [self.view createSimpleLabelWithTitle:self.params[@"data"] font:60 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    UIView *roundView = [[UIView alloc] init];
    [self.view addSubview:roundView];
    [roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    [roundView setViewCornerRadiu:10];
    roundView.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roundViewOperate)];
    [roundView addGestureRecognizer:tap];
    
    UILabel *roundTL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"圈数", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [roundView addSubview:roundTL];
    [roundTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(roundView.mas_centerY);
        make.leading.mas_equalTo(roundView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [roundView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(roundView.mas_centerY);
        make.trailing.mas_equalTo(roundView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    UILabel *roundL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"1", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    self.roundL = roundL;
    [roundView addSubview:roundL];
    [roundL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(roundView.mas_centerY);
        make.trailing.mas_equalTo(arrowIv.mas_leading).inset(AUTO_MARGIN(10));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(roundView.mas_bottom).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(100));
    }];
    [self.tableView setViewCornerRadiu:10];
    
}
#pragma -- mark 设置循环圈数
- (void)roundViewOperate {
    if (self.setFlag) {        
    } else {
        ZCAlertPickerView *pick = [[ZCAlertPickerView alloc] init];
        [self.view addSubview:pick];
        [pick showAlertView];
        pick.titleL.text = NSLocalizedString(@"设置循环圈数", nil);
        kweakself(self);
        pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
            weakself.roundL.text = content;
        };
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCWRCModelSimpleCell *cell = [ZCWRCModelSimpleCell wrcModelCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    kweakself(self);
    cell.saveConfigureTrainData = ^(NSString * _Nonnull content, NSInteger index) {
        [weakself updateTrainTimeOperate:content index:index type:0];
    };
    cell.saveRestConfigureTrainData = ^(NSString * _Nonnull content, NSInteger index) {
        [weakself updateTrainTimeOperate:content index:index type:1];
    };
    cell.signNoEditFlag = self.setFlag;
    cell.showDeleteFlag = YES;
    return cell;
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    NSInteger index = [userInfo[@"index"] integerValue];
    [self.dataArr removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W - AUTO_MARGIN(40), 70)];
    UIButton *add = [view createSimpleButtonWithTitle:NSLocalizedString(@"添加一组", nil) font:14 color:[ZCConfigColor txtColor]];
    [add setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [view addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.leading.trailing.mas_equalTo(view).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    [add setViewCornerRadiu:10];
    [add setImage:kIMAGE(@"sport_add") forState:UIControlStateNormal];
    [add dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:10];
    [add addTarget:self action:@selector(addGroupOperate) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)updateTrainTimeOperate:(NSString *)content index:(NSInteger)index type:(NSInteger)type {
    NSString *title = @"";
    if (type == 1) {
        title = @"rest";
    } else {
        title = @"time";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[index]];
    [dic setValue:content forKey:title];
    [self.dataArr removeObjectAtIndex:index];
    [self.dataArr insertObject:dic atIndex:index];

}

#pragma -- mark 添加训练组
- (void)addGroupOperate {
    if (self.setFlag) {
    } else {
        if (self.dataArr.count == 9) {
            [self.view makeToast:NSLocalizedString(@"最多只能添加九组", nil) duration:2.0 position:CSToastPositionCenter];
            return;
        }
        if (self.dataArr.count > 0) {
            NSDictionary *currentDic = self.dataArr[self.dataArr.count - 1];
            if ([[ZCDataTool convertStringTimeToMouse:currentDic[@"time"]] integerValue] > 0) {
                NSDictionary *dic = @{@"timeTitle":[NSString stringWithFormat:@"F%tu", self.dataArr.count+1], @"restTitle":[NSString stringWithFormat:@"C%tu", self.dataArr.count+1], @"time":@"00:00:00", @"rest":@"00:00:00"};
                [self.dataArr addObject:dic];
                [self.tableView reloadData];
            } else {
                [self.view makeToast:NSLocalizedString(@"请完成当前设置", nil) duration:2.0 position:CSToastPositionCenter];
            }
        } else {
            NSDictionary *dic = @{@"timeTitle":[NSString stringWithFormat:@"F%tu", self.dataArr.count+1], @"restTitle":[NSString stringWithFormat:@"C%tu", self.dataArr.count+1], @"time":@"00:00:00", @"rest":@"00:00:00"};
            [self.dataArr addObject:dic];
            [self.tableView reloadData];
        }
    }
}

- (void)saveOperate {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        NSString *content = [NSString stringWithFormat:@"LS:%@,", self.roundL.text];
        NSInteger count = self.dataArr.count;
        NSString *dataStr = @"";
        for (int i = 0; i < count; i ++) {
            NSDictionary *dic = self.dataArr[i];
            NSString *time = [ZCDataTool convertStringTimeToMouse:dic[@"time"]];
            if ([time integerValue] > 0) {
                dataStr = [dataStr stringByAppendingFormat:@"F%d:%@,C%d:%@,", i+1, [ZCDataTool convertStringTimeToMouse:dic[@"time"]], i+1, [ZCDataTool convertStringTimeToMouse:dic[@"rest"]]];
            }
        }
        if (dataStr.length > 0) {
            dataStr = [dataStr substringWithRange:NSMakeRange(0, dataStr.length-1)];
            content = [NSString stringWithFormat:@"%@%@", content, dataStr];
            NSLog(@"%@", content);
            self.dataStr = dataStr;
            [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendWRCData:content] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            
            [self.view makeToast:NSLocalizedString(@"已保存", nil) duration:1.5 position:CSToastPositionCenter];
        } else {
            [self.view makeToast:NSLocalizedString(@"请完成当前设置", nil) duration:2.0 position:CSToastPositionCenter];
        }
        
    }
}

#pragma -- mark 确定数据
- (void)startOperate {
    if (self.dataStr.length > 0) {
        self.setFlag = YES;
        self.operateView.hidden = NO;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).inset(AUTO_MARGIN(150));
        }];
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStart] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } else {
        [self.view makeToast:NSLocalizedString(@"请完成当前设置", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)routerWithEventName:(NSString *)eventName {
    if ([eventName integerValue] == 1) {//stop
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStop] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    } else if ([eventName integerValue] == 2) {//start
                
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStart] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        
    } else {//exit
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerReset] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupBottomOperateView {
    
    CGFloat width = (SCREEN_W - AUTO_MARGIN(60)) / 2.0;
    
    ZCSimpleButton *sureBtn = [self.view createShadowButtonWithTitle:NSLocalizedString(@"保存", nil) font:15 color:[ZCConfigColor txtColor]];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(width);
    }];
    [sureBtn addTarget:self action:@selector(saveOperate) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setViewBorderWithColor:1 color:[ZCConfigColor txtColor]];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    
    ZCSimpleButton *startBtn = [self.view createShadowButtonWithTitle:NSLocalizedString(@"开始", nil) font:15 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(width);
    }];
    [startBtn addTarget:self action:@selector(startOperate) forControlEvents:UIControlEventTouchUpInside];
    startBtn.backgroundColor = [ZCConfigColor txtColor];
    [startBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    
    ZCTrainModeOperateView *operateView = [[ZCTrainModeOperateView alloc] init];
    operateView.hidden = YES;
    self.operateView = operateView;
    [self.view addSubview:operateView];
    [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(110));
    }];
    [self createShowView:operateView];
}

- (UIView *)createShowView:(UIView *)view {
    
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 10;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,10);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 28;
    return view;
}
- (void)configureBaseInfo {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"智能计时器", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool getWRCMode] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.estimatedRowHeight = 100.0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        [_tableView registerClass:[ZCWRCModelSimpleCell class] forCellReuseIdentifier:@"ZCWRCModelSimpleCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@{@"timeTitle":@"F1", @"restTitle":@"C1", @"time":@"00:00:00", @"rest":@"00:00:00"}];
        
    }
    return _dataArr;
}

@end

