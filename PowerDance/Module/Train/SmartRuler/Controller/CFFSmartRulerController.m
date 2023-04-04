//
//  CFFSmartRulerController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/13.
//

#import "CFFSmartRulerController.h"
#import <ICDeviceManager/ICDeviceManager.h>
#import "CFFSmartPersonView.h"
#import "CFFSmartManager.h"
#import "CFFSmartRulerDataView.h"
#import "CFFSmartDeviceInfoModel.h"
#import "CFFBluetoothStatusView.h"
#import "CFFPreferenceTool.h"

@interface CFFSmartRulerController ()<ICDeviceManagerDelegate, ICScanDeviceDelegate>

@property (nonatomic,strong) CFFSmartPersonView *personView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic, copy) NSString *userDevId;

@property (nonatomic, assign) NSInteger ruleUnit;

@property (nonatomic,assign) BOOL modelStatus;

@property (nonatomic,assign) CGFloat modelData;

@property (nonatomic,strong) CFFSmartDeviceInfoModel *model;

@property (nonatomic,strong) CFFBluetoothStatusView *bluView;

@property (nonatomic,strong) UIButton *saveBtn;

@property (nonatomic,assign) BOOL leaveFlag;

@end

@implementation CFFSmartRulerController
{
    ICScanDeviceInfo *_deviceInfo;
    NSDictionary<NSNumber *, NSArray<NSString *> *> *_units;
    ICDevice *device;
}
- (void)viewDidDisappear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ICDeviceManager shared] scanDevice:self];
    if (self.bluView.type == 1) {
        [self.bluView loopBasecAnimation];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.backButtonStyle = CFFBackButtonStyleBlack;
    self.title = NSLocalizedString(@"智能腰围尺", nil);
    
    self.scView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scView];
    self.scView.showsVerticalScrollIndicator = NO;
    self.scView.backgroundColor = RGBA_COLOR(248, 248, 248, 1);
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.customNavBar.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(70));
    }];
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(self.scView);
//        make.bottom.mas_equalTo(self.scView.mas_bottom).inset(AUTO_MARGIN(40));
        make.width.mas_equalTo(self.scView);
    }];
    [self.contentView addSubview:self.personView];
        
    [self.personView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];

    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:kIMAGE(@"icon_ruler_record") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightOperate) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.customNavBar.mas_centerY);
        make.trailing.mas_equalTo(self.customNavBar.mas_trailing).inset(AUTO_MARGIN(10));
    }];
    
    self.model = self.params[@"data"];
    self.userDevId = self.model.deviceId;
    
    [self.contentView addSubview:self.bluView];
    [self.bluView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
    }];
    kweakself(self);
    self.bluView.BluetoothConnectOperate = ^{
        [[ICDeviceManager shared] scanDevice:weakself];
    };
    
    [ICDeviceManager shared].delegate = self;
    [[ICDeviceManager shared] initMgr];
    device = [[ICDevice alloc] init];
             
    [self setupBottomView];
    
    if (![CFFPreferenceTool getUserRulerGuideStatus]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.leaveFlag) {                
                if (self.bluView.type != 2) {
                    [CFFPreferenceTool saveUserRulerGuideStatus:YES];
                    [self.bluView showStatusView];
                }
            }
        });
    }
    
}

- (void)setupBottomView {
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = RGBA_COLOR(248, 248, 248, 1);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(70));
    }];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    [saveBtn setTitle:NSLocalizedString(@"保存数据", nil) forState:UIControlStateNormal];
    [saveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    saveBtn.titleLabel.font = FONT_SYSTEM(15);
    [saveBtn addTarget:self action:@selector(saveDataOperate) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.backgroundColor = [ZCConfigColor txtColor];
    saveBtn.enabled = NO;
    [bottomView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.leading.mas_equalTo(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(42));
        make.bottom.mas_equalTo(bottomView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    self.saveBtn = saveBtn;
    [saveBtn setViewCornerRadius:AUTO_MARGIN(21)];
}


- (void)saveDataOperate {
    [self uploadSmartRulerData:self.personView.parms];
}

- (void)onScanResult:(ICScanDeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    if (deviceInfo.type == ICDeviceTypeRuler) {
        [self bindRulerOperate:deviceInfo];
        self.bluView.type = BluetoothConnectStatusOk;
    }
}

- (void)onDeviceConnectionChanged:(ICDevice *)device state:(ICDeviceConnectState)state {
    if (state == ICDeviceConnectStateConnected) {
        self.bluView.type = BluetoothConnectStatusOk;
        [self.bluView hideStatusView];
    } else if (state == ICDeviceConnectStateDisconnected) {
        self.bluView.type = BluetoothConnectStatusClosed;
    }
}

- (void)bindRulerOperate:(ICScanDeviceInfo *)deviceInfo {
    device.macAddr = deviceInfo.macAddr;
    [[ICDeviceManager shared] addDevice:device callback:^(ICDevice *device, ICAddDeviceCallBackCode code) {
        if (code == ICAddDeviceCallBackCodeSuccess) {
            NSLog(@"Add Success");
//            [self bindDevice:deviceInfo];
            [[ICDeviceManager shared] stopScan];
        }
        else {
            NSLog(@"Add Failed");
        }
    }];
}

- (void)bindDevice:(ICScanDeviceInfo *)deviceInfo {
    
    NSDictionary *dic;
    if (self.model) {
        dic = @{@"deviceId":checkSafeContent(deviceInfo.macAddr),
                @"deviceName":checkSafeContent(deviceInfo.name),
                @"devId":checkSafeContent(self.model.deviceId)
              };
    } else {
        dic = @{@"deviceId":checkSafeContent(deviceInfo.macAddr),
                @"deviceName":checkSafeContent(deviceInfo.name),
                @"devId":@"0"
          };
    }
    [CFFSmartManager bindDeviceOpereate:dic completeHandler:^(id  _Nonnull responseObj) {
        self.userDevId = checkSafeContent(responseObj[@"data"]);
    }];
}

- (void)rightOperate {
    [HCRouter router:@"SmartRulerRecord" viewController:self animated:YES];
}

- (void)onInitFinish:(BOOL)bSuccess {
    if (bSuccess) {
        NSLog(@"success");
    } else {
        NSLog(@"Fail");
    }
}

- (void)onReceiveRulerData:(ICDevice *)device data:(ICRulerData *)data {
    NSLog(@"unit:%zd", data.unit);
    CGFloat ruleData = [[self convertDataWithUnit:data.unit data:data] doubleValue];
    if (ruleData == 0.0) return;
    NSString *content = [self convertDataWithUnit:data.unit data:data];
    NSString *unit = @"cm";
    if (data.unit == ICRulerUnitCM) {
        unit = @"cm";
    } else if (data.unit == ICRulerUnitInch) {
        unit = @"in";
    }
    self.ruleUnit = data.unit;
    content = [content stringByAppendingString:unit];
    if (data.isStabilized) {
        self.modelData = ruleData;
        self.modelStatus = YES;
        self.personView.dataView.rulerData = content;
        self.personView.saveRulerDataBlock(content);
    } else {
        if (self.modelStatus) {
            if (self.modelData > (ruleData + 0.1) || self.modelData < (ruleData - 0.1)) {
                self.personView.dataView.rulerData = content;
            }
        } else {
            self.modelStatus = NO;
            self.personView.dataView.rulerData = content;
        }
    }
    NSLog(@"%@", content);
}
  

- (void)onReceiveRulerHistoryData:(ICDevice *)device data:(ICRulerData *)data {
    NSLog(@"History-- >%f", data.distance_cm);
}

- (NSString *)convertDataWithUnit:(ICRulerUnit)unit data:(ICRulerData *)data {
    NSString *content;
    if (unit == ICRulerUnitCM) {
        content = [NSString stringWithFormat:@"%.1f", data.distance_cm];
    } else if (unit == ICRulerUnitInch) {
        content = [NSString stringWithFormat:@"%.2f", data.distance_in];
    } else {
        content = [NSString stringWithFormat:@"%.1f", data.distance_ft_in];
    }    
    return content;
}

- (void)uploadSmartRulerData:(NSDictionary *)dic {
    NSLog(@"%@", dic);
    NSString *createTime = [NSString getCurrentDate];
    NSString *userId = [NSString stringWithFormat:@"%@", @""];
    NSLog(@"%@ -- %@", createTime, userId);
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:dic];
    [parms setValue:checkSafeContent(userId) forKey:@"userId"];
    [parms setValue:checkSafeContent(createTime) forKey:@"createTime"];
    [parms setValue:[NSString stringWithFormat:@"%zd", self.ruleUnit] forKey:@"unit"];
    if (self.userDevId != nil) {
        [parms setValue:checkSafeContent(self.userDevId) forKey:@"userDevId"];
    }
    [CFFSmartManager saveRulerRecordInfo:parms completeHandler:^(id  _Nonnull responseObj) {
        [CFFHud showSuccessWithTitle:NSLocalizedString(checkSafeContent(responseObj[@"data"]), nil)];
        
        self.personView.status = YES;
        [HCRouter router:@"SmartRulerRecord" viewController:self animated:YES];
    }];
}

- (CFFSmartPersonView *)personView {
    if (!_personView) {
        _personView = [[CFFSmartPersonView alloc] init];
        kweakself(self);
        _personView.saveRulerDataBlock = ^(NSString * _Nonnull value) {
            weakself.personView.rulerData = value;
        };
        _personView.uploadRulerDataStatusBlock = ^(NSDictionary * _Nonnull parms) {
            if (parms.allKeys.count > 0) {
                if (!weakself.saveBtn.enabled) {
                    weakself.saveBtn.enabled = YES;
                    weakself.saveBtn.backgroundColor = kCFF_BG_COLOR_GREEN_COMMON;
                }
            }
        };
    }
    return _personView;
}

- (CFFBluetoothStatusView *)bluView {
    if (!_bluView) {
        _bluView = [[CFFBluetoothStatusView alloc] init];        
        _bluView.deviceType = SmartDeviceTypeRuler;
    }
    return _bluView;
}

- (void)backOperate {
    self.leaveFlag = YES;
    [[ICDeviceManager shared] deInit];
    [[ICDeviceManager shared] stopScan];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
