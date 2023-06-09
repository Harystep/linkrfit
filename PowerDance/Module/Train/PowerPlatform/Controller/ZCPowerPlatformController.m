//
//  ZCPowerPlatformController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/11.
//

#import "ZCPowerPlatformController.h"
#import "ZCPowerPlatformTypeView.h"
#import "LNLineChartView.h"
#import "ZCPowerServer.h"
#import "ZCPowerStationSetView.h"
#import "ECGView.h"
#import "CFFBluetoothStatusView.h"

#define kChartTopMargin 30
#define kUnitToKG 2.204

@interface ZCPowerPlatformController ()<BLEPowerServerDelegate>

@property (nonatomic,strong) ZCPowerPlatformTypeView *topView;

@property (nonatomic,strong) ECGView *chartView;

@property (nonatomic,strong) ECGView *chartRightView;

@property (nonatomic, assign) int count;

@property (nonatomic,strong) ZCPowerServer *defaultBLEServer;

@property (nonatomic, assign) NSInteger index;//分包索引
@property (nonatomic, assign) NSInteger totalIndex;//分包数
@property (nonatomic, assign) NSInteger remainLength;//剩余长度

@property (nonatomic,assign) NSInteger mode;//当前模式 0 常规模式

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger signTimerFlag;//1 暂停 2 运行

@property (nonatomic,assign) int unitFlag;//标记当前单位

@property (nonatomic,strong) CFFBluetoothStatusView *bluView;

@end

@implementation ZCPowerPlatformController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //禁用右滑返回
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ZCConfigColor whiteColor];
    self.mode = -1;
    [self configureNavi];
    
    UIView *statusView = [[UIView alloc] init];
    [self.contentView addSubview:statusView];
    statusView.backgroundColor = [ZCConfigColor whiteColor];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(50);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = rgba(246, 246, 246, 1);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(statusView.mas_bottom);
        make.height.mas_equalTo(5);
    }];
    
    [statusView addSubview:self.bluView];
    [self.bluView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(statusView.mas_centerY);
        make.trailing.mas_equalTo(statusView.mas_trailing).inset(15);
    }];
    self.bluView.type = BluetoothConnectStatusIng;
    self.bluView.userInteractionEnabled = NO;
    
    self.topView = [[ZCPowerPlatformTypeView alloc] init];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(statusView.mas_bottom).offset(5);
        make.height.mas_equalTo(430);
    }];
    
    UIView *line2View = [[UIView alloc] init];
    [self.contentView addSubview:line2View];
    line2View.backgroundColor = rgba(246, 246, 246, 1);
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(5);
    }];
    
    [self drawGridLine];
    
    UILabel *unitL = [self.view createSimpleLabelWithTitle:[NSString stringWithFormat:@"%@:cm", NSLocalizedString(@"单位", nil)] font:10 bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:unitL];
    [unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(5);
        make.top.mas_equalTo(line2View.mas_bottom).offset(5);
    }];
    
    self.chartView = [[ECGView alloc] initWithFrame:CGRectMake(41, CGRectGetMaxY(self.topView.frame)+kChartTopMargin, SCREEN_W-41, 200)];
    self.chartView.dataType = 0;
    [self.contentView addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(41);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(kChartTopMargin);
        make.height.mas_equalTo(200);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(20);
    }];
    
    self.chartRightView = [[ECGView alloc] initWithFrame:CGRectMake(41, CGRectGetMaxY(self.topView.frame)+kChartTopMargin, SCREEN_W-41, 200)];
    [self.contentView addSubview:self.chartRightView];
    self.chartRightView.dataType = 1;
    [self.chartRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(41);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(kChartTopMargin);
        make.height.mas_equalTo(200);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(20);
    }];
    self.chartRightView.drawerColor = rgba(248, 107, 34, 1);

    self.defaultBLEServer = [ZCPowerServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.defaultBLEServer startScan];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeChangeOperate:) name:kUpdataCurrentModeValueKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kcalChangeOperate:) name:kUpdataKcalValueKey object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullChangeOperate:) name:kUpdataCurrentPullValueKey object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerChangeOperate:) name:kUpdataPowerValueKey object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localChangeOperate:) name:kUpdataLocalValueKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceParamsBack:) name:kGetDeviceBaseInfoKey object:nil];
    kweakself(self);
    [RACObserve(kPowerServerStore, unitStr) subscribeNext:^(id  _Nullable x) {
        NSInteger num = [weakself.topView.targetSetBtn.titleLabel.text integerValue];
        if(weakself.mode < 3) {
            NSString *unit = weakself.topView.unitL.text;
            if([x isEqualToString:@"02"]) {
                if([unit isEqualToString:@"kg"]) {
                    NSInteger tem = num*kUnitToKG;
                    [weakself.topView.targetSetBtn setTitle:[NSString stringWithFormat:@"%ld", tem] forState:UIControlStateNormal];
                }
            } else {
                if([unit isEqualToString:@"lb"]) {
                    NSInteger tem = num/kUnitToKG;
                    [weakself.topView.targetSetBtn setTitle:[NSString stringWithFormat:@"%ld", tem] forState:UIControlStateNormal];
                }
            }
            if([weakself.defaultBLEServer.unitStr isEqualToString:@"02"]) {
                weakself.topView.unitL.text = @"lb";
            } else {
                weakself.topView.unitL.text = @"kg";
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself changeNormalDataUnit];
        });
    }];           
        
}

- (void)deviceParamsBack:(NSNotification *)noti {
    NSString *version = noti.object;
    kPowerServerStore.unitStr = [version substringWithRange:NSMakeRange(6, 2)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeNormalDataUnit];
    });
}

/// 位置
/// - Parameter noti: <#noti description#>
- (void)localChangeOperate:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    [self.chartView drawCurve:dic[@"left"]];
    [self.chartRightView drawCurve:dic[@"right"]];
}

/// 爆发力
- (void)powerChangeOperate:(NSNotification *)noti {
    NSString *content = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([kPowerServerStore.unitStr isEqualToString:@"02"]) {
            self.topView.eruptL.text = [NSString stringWithFormat:@"%.2f", [content doubleValue]*kUnitToKG];
        } else {
            self.topView.eruptL.text = content;
        }
        [self changeNormalDataUnit];
    });
}

/// 获取拉力
/// - Parameter noti: <#noti description#>
- (void)pullChangeOperate:(NSNotification *)noti {
    NSString *content = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([kPowerServerStore.unitStr isEqualToString:@"02"]) {
            self.topView.totalL.text = [NSString stringWithFormat:@"%.2f", [content doubleValue]*kUnitToKG];
        } else {
            self.topView.totalL.text = content;
        }
        [self changeNormalDataUnit];
    });
}

- (void)changeNormalDataUnit {
    if([kPowerServerStore.unitStr isEqualToString:@"02"]) {
        self.topView.totalTL.text = NSLocalizedString(@"实际拉力(lb)", nil);
        self.topView.eruptTL.text = NSLocalizedString(@"爆发力(lb)", nil);
    } else {
        self.topView.totalTL.text = NSLocalizedString(@"实际拉力(kg)", nil);
        self.topView.eruptTL.text = NSLocalizedString(@"爆发力(kg)", nil);
    }
}

#pragma mark - 卡路里
- (void)kcalChangeOperate:(NSNotification *)noti {
    NSString *content = noti.object;
    float kcal = [ZCBluthDataTool convertHexStrTopFloat:content];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.consumeL.text = [NSString stringWithFormat:@"%.2f", kcal];
    });
    
}
#pragma mark - 当前设定值
- (void)modeChangeOperate:(NSNotification *)noti {
    NSString *data = noti.object;
    NSString *high = [data substringWithRange:NSMakeRange(2, 2)];
    NSString *low = [data substringWithRange:NSMakeRange(0, 2)];
    
    NSString *hex = [NSString stringWithFormat:@"%@%@", high, low];
    long content = [ZCBluthDataTool convertHexToDecimal:hex];

    if(self.mode < 3) {
        if([kPowerServerStore.unitStr isEqualToString:@"02"]) {
            NSInteger num = (NSInteger)(content * kUnitToKG);
            [self.topView.targetSetBtn setTitle:[NSString stringWithFormat:@"%ld", num] forState:UIControlStateNormal];
        } else {
            [self.topView.targetSetBtn setTitle:[NSString stringWithFormat:@"%ld", content] forState:UIControlStateNormal];
        }
    } else {
        [self.topView.targetSetBtn setTitle:[NSString stringWithFormat:@"%ld", content] forState:UIControlStateNormal];
    }
}

/// 网格线
- (void)drawGridLine {
    
    UIView *leftView = [[UIView alloc] init];
    [self.contentView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX).offset(-80);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
    }];
    
    UIView *rightView = [[UIView alloc] init];
    [self.contentView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX).offset(80);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
    }];
    
    [self createTartetView:leftView title:NSLocalizedString(@"左侧位置", nil) color:rgba(138, 205, 215, 1)];
    
    [self createTartetView:rightView title:NSLocalizedString(@"右侧位置", nil) color:rgba(248, 107, 34, 1)];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(40);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(kChartTopMargin);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(1);
    }];
    lineView.hidden = YES;
    
    UIView *horView = [[UIView alloc] init];
    [self.contentView addSubview:horView];
    horView.backgroundColor = [ZCConfigColor bgColor];
    [horView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(40);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREEN_W);
    }];
    
    [self createOtherHorView:horView];
}

- (void)createTartetView:(UIView *)itemView title:(NSString *)title color:(UIColor *)color {
    UIView *lineView = [[UIView alloc] init];
    [itemView addSubview:lineView];
    lineView.backgroundColor = color;
    UILabel *titleL = [self.view createSimpleLabelWithTitle:title font:12 bold:NO color:[ZCConfigColor subTxtColor]];
    [itemView addSubview:titleL];
    if([title containsString:@"左"]) {
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemView.mas_centerY);
            make.trailing.mas_equalTo(itemView.mas_trailing);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemView.mas_centerY);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.trailing.mas_equalTo(titleL.mas_leading).inset(10);
        }];
    } else {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemView.mas_centerY);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.leading.mas_equalTo(itemView.mas_leading);
        }];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemView.mas_centerY);
            make.leading.mas_equalTo(lineView.mas_trailing).offset(10);
        }];
    }
}

- (void)createOtherHorView:(UIView *)horView {
    for (int i = 0; i < 4; i ++) {
        UIView *item = [[UIView alloc] init];
        [self.contentView addSubview:item];
        item.backgroundColor = [ZCConfigColor bgColor];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(41);
            make.top.mas_equalTo(horView.mas_top).offset(-i*50);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(SCREEN_W);
        }];
        UILabel *numL = [self.contentView createSimpleLabelWithTitle:[NSString stringWithFormat:@"%d", 50*i] font:9 bold:NO color:[ZCConfigColor subTxtColor]];
        [self.contentView addSubview:numL];
        numL.textAlignment = NSTextAlignmentCenter;
        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading);
            make.trailing.mas_equalTo(item.mas_leading);
            make.centerY.mas_equalTo(item.mas_centerY);
        }];
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(nonnull void (^)(id _Nonnull))block {
    NSData *data;
    if(self.defaultBLEServer.connectFlag) {
        if([eventName isEqualToString:@"start"]) {
            if(self.mode == -1) {
                [self.view makeToast:NSLocalizedString(@"请先选择运动模式", nil) duration:1.5 position:CSToastPositionCenter];
                return;
            }
            data = [ZCBluthDataTool sendStartStationOperate];
            
            [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            block(@"");
            if(_timer == nil) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(mouseAutoOperate) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            }
            if(self.signTimerFlag == 1) {
                [self continueTimer];
            }
            self.signTimerFlag = 2;
            
        } else if ([eventName isEqualToString:@"stop"]) {
            data = [ZCBluthDataTool sendStopStationOperate];
            self.signTimerFlag = 1;
            [self pauseTimer];
            [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            block(@"");
            
        } else if ([eventName isEqualToString:@"back"]) {
            if(self.signTimerFlag == 2) {
                [self.view makeToast:NSLocalizedString(@"请先暂停运动", nil) duration:2.0 position:CSToastPositionCenter];
                return;
            }
            data = [ZCBluthDataTool sendBackRopeStationOperate];
            [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            block(@"");
        } else if ([eventName isEqualToString:@"mode"]) {
            if(self.signTimerFlag == 2) {
                [self.view makeToast:NSLocalizedString(@"请先暂停运动", nil) duration:2.0 position:CSToastPositionCenter];
                return;
            }
            NSData *data;
            self.mode = [userInfo[@"index"] integerValue];
            switch ([userInfo[@"index"] integerValue]) {
                case 0://常规模式
                    data = [ZCBluthDataTool sendSportModeStationOperate:@"01"];
                    break;
                case 1://向心模式
                    data = [ZCBluthDataTool sendSportModeStationOperate:@"03"];
                    break;
                case 2://离心模式
                    data = [ZCBluthDataTool sendSportModeStationOperate:@"02"];
                    break;
                case 3://等速模式
                    data = [ZCBluthDataTool sendSportModeStationOperate:@"04"];
                    break;
                case 4://弹力绳模式
                    data = [ZCBluthDataTool sendSportModeStationOperate:@"05"];
                    break;
                case 5://划船模式
                    data = [ZCBluthDataTool sendSportModeStationOperate:@"06"];
                    break;
                    
                default:
                    break;
            }
            [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            
            [self getCurrentForceOrder];
            
            self.topView.unitL.text = [ZCBluthDataTool convertUnitTitleWithMode:self.mode];
            
            block(@"");
        } else if ([eventName isEqualToString:@"set"]) {
            if(self.signTimerFlag == 2) {
                [self.view makeToast:NSLocalizedString(@"请先暂停运动", nil) duration:2.0 position:CSToastPositionCenter];
                return;
            }
            ZCPowerStationSetView *setView = [[ZCPowerStationSetView alloc] init];
            [self.view addSubview:setView];
            setView.titleL.text = NSLocalizedString(@"设置", nil);
            setView.configureArr = [ZCBluthDataTool convertDataWithMode:self.mode];
            [setView showAlertView];
            setView.defValue = self.topView.targetSetBtn.titleLabel.text;
            kweakself(self);
            setView.sureRepeatOperate = ^(NSString * _Nonnull content) {
                NSLog(@"%@", content);
                [weakself.topView.targetSetBtn setTitle:content forState:UIControlStateNormal];
                [weakself setCurrentModeValue:content];
            };
        }
    } else {
        [self.view makeToast:NSLocalizedString(@"请先连接设备", nil) duration:1.5 position:CSToastPositionCenter];
    }
}
#pragma mark - 定时查询
- (void)mouseAutoOperate {
    [self getDeviceForceDataOrder];
}

/// 设置当前运动值
/// - Parameter content: <#content description#>
- (void)setCurrentModeValue:(NSString *)content {
    if([self.defaultBLEServer.unitStr isEqualToString:@"02"]) {
        if (self.mode < 3) {
            NSInteger temCount = [content integerValue];
            temCount = temCount/kUnitToKG;
            content = [NSString stringWithFormat:@"%ld", temCount];
        }
    }
    content = [ZCBluthDataTool ToHex:[content integerValue]];
    NSMutableString *temStr = [NSMutableString string];
    if(content.length == 4) {
    } else if (content.length == 3) {
        content = [NSString stringWithFormat:@"0%@", content];
    } else if (content.length == 2) {
        content = [NSString stringWithFormat:@"00%@", content];
    } else {
        content = [NSString stringWithFormat:@"000%@", content];
    }
    [temStr appendString:[content substringWithRange:NSMakeRange(2, 2)]];
    [temStr appendString:[content substringWithRange:NSMakeRange(0, 2)]];
    NSInteger mode;
    if(self.mode == 0 || self.mode == 1) {
        mode = 20;
    } else {
        mode = self.mode + 20 - 1;
    }
    NSData *data = [ZCBluthDataTool setDeviceSportMode:[NSString stringWithFormat:@"%ld", mode] value:temStr];
    [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark - 设置常规模式
- (void)getNormalModeForceOrder {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendSportModeStationOperate:@"01"] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    });
}

//获取设备数据返回
- (void)getDeviceForceDataOrder {
//    //爆发力
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendGetPowerForceOrder] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
//    });
//    //卡路里
//    [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendGetConsumeKcalOrder] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];

    //实际位置
    [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool getDeviceSportLocalData] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendGetDevicePullForceOrder] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    });
}

//获取当前设置值
- (void)getCurrentForceOrder {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendGetCurrentModeSetValueOrder] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    });
        
}

- (void)didDisconnect {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bluView.type = BluetoothConnectStatusClosed;
    });
}

- (void)didStopScan {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bluView.type = BluetoothConnectStatusClosed;
    });
}

- (void)didConnect:(PeriperalInfo *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bluView.type = BluetoothConnectStatusOk;
        [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendGetTokenContent] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool getDeviceVersionInfo] forCharacteristic:[ZCPowerServer defaultBLEServer].selectFileCharacteristic type:CBCharacteristicWriteWithResponse];
        });
    });
}

- (void)didFoundPeripheral {
    NSLog(@"发现外设");
}

- (void)configureOperate {
    if(self.defaultBLEServer.connectFlag) {
        [HCRouter router:@"PowerPlatformSet" params:@{} viewController:self animated:YES];
    } else {
        [self.view makeToast:NSLocalizedString(@"请先连接设备", nil) duration:1.5 position:CSToastPositionCenter];
    }
}

- (void)configureNavi {
    
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"力量台", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    UIButton *setBtn = [[UIButton alloc] init];
    [self.naviView addSubview:setBtn];
    [setBtn addTarget:self action:@selector(configureOperate) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setImage:kIMAGE(@"power_station_set") forState:UIControlStateNormal];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.trailing.mas_equalTo(self.naviView.mas_trailing).inset(5);
        make.bottom.mas_equalTo(self.naviView.mas_bottom).inset(8);
    }];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [[ZCPowerServer defaultBLEServer] stopScan];
    [[ZCPowerServer defaultBLEServer] disConnect];
    
}

#pragma -- mark 暂停
//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma -- mark 继续
-(void)continueTimer {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (CFFBluetoothStatusView *)bluView {
    if (!_bluView) {
        _bluView = [[CFFBluetoothStatusView alloc] init];
        _bluView.deviceType = SmartDeviceTypeRuler;
    }
    return _bluView;
}

@end
