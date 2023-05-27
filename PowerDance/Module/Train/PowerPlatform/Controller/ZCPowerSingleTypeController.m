//
//  ZCPowerSingleTypeController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/28.
//

#import "ZCPowerSingleTypeController.h"
#import "ZCPowerPlatformTypeView.h"
#import "ZCPowerSingleServer.h"
#import "ZCPowerStationSetView.h"
#import "ECGView.h"

#define kChartTopMargin 30

@interface ZCPowerSingleTypeController ()<ZCPowerSingleServerDelegate>

@property (nonatomic,strong) ZCPowerPlatformTypeView *topView;

@property (nonatomic,strong) ECGView *chartView;

@property (nonatomic, assign) int count;

@property (nonatomic,strong) ZCPowerSingleServer *defaultBLEServer;

@property (nonatomic, assign) NSInteger index;//分包索引
@property (nonatomic, assign) NSInteger totalIndex;//分包数
@property (nonatomic, assign) NSInteger remainLength;//剩余长度

@property (nonatomic,assign) NSInteger mode;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger signTimerFlag;//暂停 1 yunxing 2

@property (nonatomic,strong) UILabel *statusL;

@end

@implementation ZCPowerSingleTypeController

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
    
    self.statusL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"连接中", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [statusView addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(statusView.mas_centerY);
        make.trailing.mas_equalTo(statusView.mas_trailing).inset(15);
    }];
    
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

    self.defaultBLEServer = [ZCPowerSingleServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.defaultBLEServer startScan];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullChangeOperate:) name:@"kSportPullDataKey" object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localChangeOperate:) name:@"kSportLocalDataKey" object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerChangeOperate:) name:@"kSportPowerDataKey" object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kcalChangeOperate:) name:@"kSportKcalDataKey" object:nil];
    
}

/// 位置
/// - Parameter noti: <#noti description#>
- (void)localChangeOperate:(NSNotification *)noti {
    NSString *content = noti.object;
    [self.chartView drawCurve:content];
}

/// 爆发力
- (void)powerChangeOperate:(NSNotification *)noti {
    NSString *content = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.eruptL.text = content;
    });
}

/// 获取拉力
/// - Parameter noti: <#noti description#>
- (void)pullChangeOperate:(NSNotification *)noti {
    NSString *content = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.totalL.text = content;
    });
}

#pragma mark - 卡路里
- (void)kcalChangeOperate:(NSNotification *)noti {
    NSString *content = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.consumeL.text = [NSString stringWithFormat:@"%@", content];
    });
    
}

/// 网格线
- (void)drawGridLine {
    
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
    if(self.defaultBLEServer.selectCharacteristic) {
        if([eventName isEqualToString:@"start"]) {
            if(self.mode == -1) {
                [self.view makeToast:NSLocalizedString(@"请先选择运动模式", nil) duration:1.5 position:CSToastPositionCenter];
                return;
            }
            data = [ZCBluthDataTool startSportSingleMode];
            [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
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
            data = [ZCBluthDataTool stopSportSingleMode];
            self.signTimerFlag = 1;
            [self pauseTimer];
            [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            block(@"");
        } else if ([eventName isEqualToString:@"back"]) {
            if(self.signTimerFlag == 2) {
                [self.view makeToast:NSLocalizedString(@"请先暂停运动", nil) duration:2.0 position:CSToastPositionCenter];
                return;
            }
            data = [ZCBluthDataTool startSportBackRopeSingleMode];
            [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            block(@"");
        } else if ([eventName isEqualToString:@"mode"]) {
            if(self.signTimerFlag == 2) {
                [self.view makeToast:NSLocalizedString(@"请先暂停运动", nil) duration:2.0 position:CSToastPositionCenter];
                return;
            }
            NSData *data;
            NSData *currentData;
            self.mode = [userInfo[@"index"] integerValue];
            switch ([userInfo[@"index"] integerValue]) {
                case 0://常规模式//5
                    data = [ZCBluthDataTool setCurrentSportMode:@"01"];
                    currentData = [ZCBluthDataTool sendSportModePowerData:@"5"];
                    [self.topView.targetSetBtn setTitle:@"5" forState:UIControlStateNormal];
                    break;
                case 1://离心模式 //5
                    data = [ZCBluthDataTool setCurrentSportMode:@"02"];
                    currentData = [ZCBluthDataTool sendSportModePowerData:@"5"];
                    [self.topView.targetSetBtn setTitle:@"5" forState:UIControlStateNormal];
                    break;
                case 2://向心模式 //5
                    data = [ZCBluthDataTool setCurrentSportMode:@"03"];
                    currentData = [ZCBluthDataTool sendSportModePowerData:@"5"];
                    [self.topView.targetSetBtn setTitle:@"5" forState:UIControlStateNormal];
                    break;
                case 3://等速模式  //80
                    data = [ZCBluthDataTool setCurrentSportMode:@"04"];
                    currentData = [ZCBluthDataTool sendSportModeSpeedData:@"80"];
                    [self.topView.targetSetBtn setTitle:@"80" forState:UIControlStateNormal];
                    break;
                case 4://弹力绳模式  //30
                    data = [ZCBluthDataTool setCurrentSportMode:@"05"];
                    currentData = [ZCBluthDataTool sendSportModeRopeData:@"30"];
                    [self.topView.targetSetBtn setTitle:@"30" forState:UIControlStateNormal];
                    break;
                case 5://划船模式  //1 *200
                    data = [ZCBluthDataTool setCurrentSportMode:@"06"];
                    currentData = [ZCBluthDataTool sendSportGearModeData:@"1"];
                    [self.topView.targetSetBtn setTitle:@"1" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            NSLog(@"data:%@", data);
            NSLog(@"setdata:%@", currentData);
            [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            self.topView.unitL.text = [ZCBluthDataTool convertUnitTitleWithMode:self.mode];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:currentData forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            });
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
        [self.view makeToast:NSLocalizedString(@"请先连接设备", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)mouseAutoOperate {
    //爆发力
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool readSportPowerModeData] forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    });
    //卡路里
    [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool readSportKcalModeData] forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    
   // 实际位置
    [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool readSportLocalModeData] forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    
    // 实际
     [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool readSportPullModeData] forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)setCurrentModeValue:(NSString *)content {    
    NSData *currentData;
    if (self.mode < 3) {
        currentData = [ZCBluthDataTool sendSportModePowerData:content];
    } else if (self.mode == 3) {
        currentData = [ZCBluthDataTool sendSportModeSpeedData:content];
    } else if (self.mode == 4) {
        currentData = [ZCBluthDataTool sendSportModeRopeData:content];
    } else {
        currentData = [ZCBluthDataTool sendSportGearModeData:content];
    }
    [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:currentData forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)didDisconnect {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusL.text = NSLocalizedString(@"断开连接", nil);
    });
}

- (void)didStopScan {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusL.text = NSLocalizedString(@"断开连接", nil);
    });
}

- (void)didConnect:(PeriperalInfo *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusL.text = NSLocalizedString(@"已连接", nil);
    });
}

- (void)didFoundPeripheral {
    NSLog(@"发现外设");
}

- (void)configureOperate {
    [HCRouter router:@"PowerPlatformSet" params:@{} viewController:self animated:YES];
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
    setBtn.hidden = YES;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [[ZCPowerSingleServer defaultBLEServer] stopScan];
    [[ZCPowerSingleServer defaultBLEServer] disConnect];
//    [BLESuitServer defaultBLEServer].selectPeripheral = nil;
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

@end
