//
//  ZCPowerSingleTypeController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/28.
//

#import "ZCPowerSingleTypeController.h"
#import "ZCPowerPlatformTypeView.h"
#import "LNLineChartView.h"
#import "ZCPowerSingleServer.h"
#import "ZCPowerStationSetView.h"

@interface ZCPowerSingleTypeController ()<LNLineChartViewDelegate, ZCPowerSingleServerDelegate>

@property (nonatomic,strong) ZCPowerPlatformTypeView *topView;

@property (nonatomic,strong) LNLineChartView *chartView;

@property (nonatomic, assign) int count;

@property (nonatomic,strong) ZCPowerSingleServer *defaultBLEServer;

@property (nonatomic,strong) UILabel *statusL;

@property (nonatomic, assign) NSInteger index;//分包索引
@property (nonatomic, assign) NSInteger totalIndex;//分包数
@property (nonatomic, assign) NSInteger remainLength;//剩余长度

@property (nonatomic,assign) NSInteger mode;

@end

@implementation ZCPowerSingleTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    
    [self configureNavi];
    
    UIView *statusView = [[UIView alloc] init];
    [self.view addSubview:statusView];
    statusView.backgroundColor = [ZCConfigColor whiteColor];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    self.statusL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"连接中···", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [statusView addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(statusView.mas_centerY);
        make.trailing.mas_equalTo(statusView.mas_trailing).inset(15);
    }];
    
    self.topView = [[ZCPowerPlatformTypeView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(statusView.mas_bottom).offset(5);
        make.height.mas_equalTo(375);
    }];
    
    self.chartView = [[LNLineChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+5, SCREEN_W, 200)];
    self.chartView.delegate = self;
    self.chartView.backgroundColor = [ZCConfigColor whiteColor];
    [self.view addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(5);
        make.height.mas_equalTo(200);
    }];
    
    _count = 7;
    NSMutableArray *chartDataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<_count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (i<1) {
            dict[@"star"] = [NSNumber numberWithInt:i%4];
            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
        }else{
            dict[@"star"] = [NSNumber numberWithInt:i%4];
            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
        }
        [chartDataArr addObject:dict];
    }
    self.chartView.starInfoArr = chartDataArr;

    self.defaultBLEServer = [ZCPowerSingleServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.defaultBLEServer startScan];
    });
    
    [self downloadFileOperate];
}

- (void)didConnect:(PeriperalInfo *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusL.text = NSLocalizedString(@"连接成功", nil);
        [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendGetTokenContent] forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    });
   
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(nonnull void (^)(id _Nonnull))block {
    NSData *data;
    if([eventName isEqualToString:@"start"]) {
        data = [ZCBluthDataTool sendStartStationOperate];
        if(self.defaultBLEServer.selectPeripheral) {
            [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    } else if ([eventName isEqualToString:@"stop"]) {
        data = [ZCBluthDataTool sendStopStationOperate];
        if(self.defaultBLEServer.selectPeripheral) {
            [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    } else if ([eventName isEqualToString:@"mode"]) {
        if(self.defaultBLEServer.selectPeripheral) {
            NSData *data;
            switch ([userInfo[@"index"] integerValue]) {
                case 0://常规模式
                    data = [ZCBluthDataTool sendSportMode1StationOperate];
                    break;
                case 1://离心模式
                    data = [ZCBluthDataTool sendSportMode3StationOperate];
                    break;
                case 2://向心模式
                    data = [ZCBluthDataTool sendSportMode2StationOperate];
                    break;
                case 3://等速模式
                    data = [ZCBluthDataTool sendSportMode4StationOperate];
                    break;
                case 4://弹力绳模式
                    data = [ZCBluthDataTool sendSportMode5StationOperate];
                    break;
                case 5://划船模式
                    data = [ZCBluthDataTool sendSportMode6StationOperate];
                    break;
                                        
                default:
                    break;
            }
            data = [ZCBluthDataTool setPullPowerData];
            [[ZCPowerSingleServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerSingleServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
            self.topView.unitL.text = [ZCBluthDataTool convertUnitTitleWithMode:self.mode];
            
            block(@"");
        }
    } else if ([eventName isEqualToString:@"set"]) {
        ZCPowerStationSetView *setView = [[ZCPowerStationSetView alloc] init];
        [self.view addSubview:setView];
        setView.titleL.text = NSLocalizedString(@"设置", nil);
        setView.configureArr = [ZCBluthDataTool convertDataWithMode:self.mode];
        [setView showAlertView];
        setView.sureRepeatOperate = ^(NSString * _Nonnull content) {
            
        };
    }
}

- (void)downloadFileOperate {
    NSURL *url = [NSURL URLWithString:@"https://zc-tk.oss-cn-beijing.aliyuncs.com/bootloader.bin"];
    // 创建request对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 使用URLSession来进行网络请求
    // 创建会话配置对象
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 创建会话对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    // 创建会话任务对象
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            // 将下载的数据传出去，进行UI更新
            NSLog(@"%@", data);
            Byte *bytes = (Byte *)[data bytes];
//            NSMutableString *str = [NSMutableString stringWithCapacity:data.length];
//            for (int i = 0; i < data.length; i ++) {
//                [str appendFormat:@"%02x", bytes[i]];
//            }
//            NSLog(@"str:%@", str);
//            self.remainLength = data.length % 128;
//            self.totalIndex = ceil(data.length/128.0);
//            NSLog(@"%tu-%tu", self.remainLength, self.totalIndex);
            NSMutableString *str = [NSMutableString string];
            for (int i = 0; i < 20; i ++) {
                [str appendFormat:@"%02x", bytes[i]];
            }
            NSLog(@"str:%@", str);
            NSData *temData = [ZCBluthDataTool convertHexStrToData:str];
            NSLog(@"temData:%@", temData);
            Byte *temBytes = (Byte *)[temData bytes];
            NSMutableString *temStr = [NSMutableString string];
            for (int i = 0; i < 20; i ++) {
                [temStr appendFormat:@"%02x", temBytes[i]];
            }
            NSLog(@"temStr:%@", temStr);
        }
    }];
    // 创建的task都是挂起状态，需要resume才能执行
    [task resume];
}

- (void)sendSubpackage:(Byte *)bytes index:(NSInteger)index length:(NSInteger)length {
    
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
}

- (void)dealloc {
    [[ZCPowerSingleServer defaultBLEServer] stopScan];
    [[ZCPowerSingleServer defaultBLEServer] disConnect];
//    [BLESuitServer defaultBLEServer].selectPeripheral = nil;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    NSMutableArray *chartDataArr = [[NSMutableArray alloc] init];
//    _count ++;
//    for (int i = 0; i<_count; i++) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        if (i<2) {
//            dict[@"star"] = [NSNumber numberWithInt:i%4];
//            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
//        }else{
//            dict[@"star"] = [NSNumber numberWithInt:i%4];
//            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
//        }
//        [chartDataArr addObject:dict];
//    }
//    self.chartView.starInfoArr = chartDataArr;
//}

#pragma mark - <LNLineChartViewDelegate>
- (void)refreshLatestObjectWithDateStr:(NSString *)dateStr star:(NSInteger)star
{
    
}

- (void)chartViewDotsTouchWithIndex:(NSInteger)index model:(LNLineChartModel *)model
{
    [self refreshLatestObjectWithDateStr:model.playDate star:model.star];
}

@end
