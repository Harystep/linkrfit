//
//  ZCPowerPlatformSetController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerPlatformSetController.h"
#import "ZCMoreSetSimpleCell.h"
#import "ZCUpdateVersionView.h"
#import "ZCPowerStationAlertView.h"
#import "ZCPowerStationSetLanguageView.h"
#import "ZCPowerStationSetUnitView.h"
#import "ZCPowerStationVoiceView.h"
#import "ZCPowerStationAboutView.h"
#import "ZCPowerServer.h"

@interface ZCPowerPlatformSetController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *subpackage;//包内容
@property (nonatomic, assign) NSInteger index;//分包索引
@property (nonatomic, assign) NSInteger totalIndex;//分包数
@property (nonatomic, assign) NSInteger remainLength;//剩余长度
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, assign) Byte *bytes;
@property (nonatomic,strong) ZCPowerStationAlertView *updateView;
@property (nonatomic,copy) NSString *currentDeviceVersion;//当前设备版本号
@property (nonatomic,strong) NSDictionary *f0Version;
@property (nonatomic,copy) NSDictionary *f1Version;
@property (nonatomic,copy) NSString *fileCrc;

@end

@implementation ZCPowerPlatformSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    [self configureNavi];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(10);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(60))];
    self.tableView.tableFooterView = footerView;
    footerView.backgroundColor = rgba(246, 246, 246, 1);
    footerView.hidden = YES;
    [self setupFooterSubViews:footerView];
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBackSucNotice:) name:kUpdateFileBackNoticeKey object:nil];
    
    [self queryHardwareInfo];
    
    if([ZCPowerServer defaultBLEServer].selectFileCharacteristic != nil) {
        [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool getDeviceVersionInfo] forCharacteristic:[ZCPowerServer defaultBLEServer].selectFileCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceParamsBack:) name:kGetDeviceBaseInfoKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpdateBack:) name:kStartFileBackNoticeKey object:nil];
        
}

- (void)deviceParamsBack:(NSNotification *)noti {
    NSString *version = noti.object;
    self.currentDeviceVersion = [version substringWithRange:NSMakeRange(0, 2)];
}

- (void)queryHardwareInfo {    
    [ZCTrainManage queryHardwareVersionInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"hardwareInfo%@", responseObj);
        NSDictionary *fileDic = responseObj[@"data"];
        self.f0Version = fileDic[@"f01"];
        self.f1Version = fileDic[@"f02"];
    }];
}

- (void)updataBackSucNotice:(NSNotification *)noti {
    NSString *content = noti.object;
    self.index = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([content isEqualToString:@"00"]) {
            [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool setStartUpdateWithType:@"01" fileName:[ZCBluthDataTool convertStringToHexStr:self.filename]] forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        } else {
            self.updateView.failFlag = YES;
        }
    });
}

- (void)startUpdateBack:(NSNotification *)noti {
    NSString *content = noti.object;
    self.index = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([content isEqualToString:@"00"] || [content isEqualToString:@"0"]) {
            self.updateView.successFlag = YES;
        } else {
            self.updateView.failFlag = YES;
        }
    });
}

- (void)configureAlertView:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [ZCDataTool loginOut];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
    [alert addAction:conform];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma -- mark 设置底部视图
- (void)setupFooterSubViews:(UIView *)footerView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [ZCConfigColor whiteColor];
    [footerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(footerView);
        make.bottom.mas_equalTo(footerView);
        make.top.mas_equalTo(footerView.mas_top).offset(AUTO_MARGIN(10));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutOperate)];
    [view addGestureRecognizer:tap];
    
    UILabel *titleL = [footerView createSimpleLabelWithTitle:NSLocalizedString(@"关于本机", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.leading.mas_equalTo(view).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [view addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(view.mas_trailing).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
}

- (void)updataBackNotice {
    self.index ++;
    [self sendSubpackageWithindex:self.index];
}

- (void)downloadFileOperate:(NSDictionary *)fileDic {
//    NSString *fileUrl = @"https://zc-tk.oss-cn-beijing.aliyuncs.com/bootloader.bin";
    NSString *fileUrl = checkSafeContent(fileDic[@"url"]);
    NSURL *url = [NSURL URLWithString:fileUrl];
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
            NSLog(@"%tu", data.length);
            Byte *bytes = (Byte *)[data bytes];
            NSMutableString *str = [NSMutableString stringWithCapacity:data.length];
            for (int i = 0; i < data.length; i ++) {
                [str appendFormat:@"%02x", bytes[i]];
            }
            self.subpackage = str;
            self.remainLength = data.length % 128;
            self.totalIndex = ceil(data.length/128.0);
            NSLog(@"%tu-%tu", self.remainLength, self.totalIndex);
            self.bytes = bytes;
            self.filename = checkSafeContent(fileDic[@"name"]);
            if(data.length > kMaxLenght) {                
                NSInteger remainLength = data.length % (kMaxLenght);
                NSInteger totalFileIndex = ceil(data.length/kMaxLenght);
                unsigned int rc = [ZCBluthDataTool getMaxFileCRC16WithContent:str index:0 maxIndex:totalFileIndex remainLen:remainLength crc:0xFFFF];
                self.fileCrc = [ZCBluthDataTool ToHex:rc];
            } else {
                unsigned int rc = [ZCBluthDataTool GetSmallCRC16:bytes len:data.length first:0xFFFF];
                self.fileCrc = [ZCBluthDataTool ToHex:rc];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendSubpackageWithindex:0];
            });
        }
    }];
    // 创建的task都是挂起状态，需要resume才能执行
    [task resume];
}

- (void)sendSubpackageWithindex:(NSInteger)index {
    NSString *package;
    if(self.index < self.totalIndex) {
        NSInteger length = 256;
        if(self.index == self.totalIndex-1) {
            length = self.remainLength*2;
        }
        package = [self.subpackage substringWithRange:NSMakeRange(256*index, length)];
        NSString *filename = [ZCBluthDataTool convertStringToHexStr:self.filename];
        if([ZCPowerServer defaultBLEServer].selectPeripheral != nil) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [ZCBluthDataTool sendFilePackage:self.subpackage fileCrc:self.fileCrc content:package filename:filename total:self.totalIndex currentIndex:self.index bytes:self.bytes];
                [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectFileCharacteristic type:CBCharacteristicWriteWithResponse];
            });
            NSLog(@">>>%tu", self.index);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updataBackNotice];
            });
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCMoreSetSimpleCell *cell = [ZCMoreSetSimpleCell moreSetSimpleCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([ZCPowerServer defaultBLEServer].connectFlag) {
        switch (indexPath.row) {
            case 0:
                [self updateOperate];
                break;
                
            case 1:
                [self voiceOperate];
                break;
                
            case 2:
                [self languageOperate];
                break;
                
            case 3:
                [self unitOperate];
                break;
                
            default:
                break;
        }
    } else {
        [self.view makeToast:NSLocalizedString(@"断开连接", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)updateOperate {
    NSString *version = checkSafeContent(self.f0Version[@"version"]);
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger f0Version = [version integerValue];
    if(f0Version > [self.currentDeviceVersion integerValue]) {
        NSArray *files = self.f0Version[@"files"];
        NSDictionary *fileDic = files[0];
        ZCPowerStationAlertView *alertView = [[ZCPowerStationAlertView alloc] init];
        self.updateView = alertView;
        [alertView showAlertView];
        alertView.nowVersion = self.currentDeviceVersion;
        alertView.lastVersion = checkSafeContent(self.f0Version[@"version"]);
        kweakself(self);
        alertView.updateBlock = ^{
            [weakself downloadFileOperate:fileDic];
        };
    } else {
        [self.view makeToast:NSLocalizedString(@"当前已是最新版本", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)unitOperate {
    ZCPowerStationSetUnitView *alertView = [[ZCPowerStationSetUnitView alloc] init];
    [alertView showAlertView];
    kweakself(self);
    alertView.setDeviceUnitBlock = ^(NSString * _Nonnull type) {
        NSData *data;
        if([type integerValue] == 1) {    //lb
            data = [ZCBluthDataTool sendSetDeviceUnitOrder:@"02"];
            kPowerServerStore.unitStr = @"02";
        } else {//kg
            data = [ZCBluthDataTool sendSetDeviceUnitOrder:@"01"];
            kPowerServerStore.unitStr = @"01";
        }
//        NSLog(@"%@", data);
        [weakself setDeviceData:data];
    };
}

- (void)languageOperate {
    ZCPowerStationSetLanguageView *alertView = [[ZCPowerStationSetLanguageView alloc] init];
    [alertView showAlertView];
    kweakself(self);
    alertView.setDeviceLanguageBlock = ^(NSString * _Nonnull type) {
        NSData *data;
        if([type integerValue] == 1) {
            data = [ZCBluthDataTool sendSetDeviceLanguageOrder:@"02"];
        } else if ([type integerValue] == 2) {
            data = [ZCBluthDataTool sendSetDeviceLanguageOrder:@"03"];
        } else {
            data = [ZCBluthDataTool sendSetDeviceLanguageOrder:@"01"];
        }
        [weakself setDeviceData:data];
//        NSLog(@"%@", data);
    };
}

- (void)aboutOperate {
    ZCPowerStationAboutView *alertView = [[ZCPowerStationAboutView alloc] init];
    [alertView showAlertView];
}

- (void)voiceOperate {
    ZCPowerStationVoiceView *alertView = [[ZCPowerStationVoiceView alloc] init];
    [alertView showAlertView];
    kweakself(self);
    alertView.setDeviceVoiceBlock = ^(NSString * _Nonnull type) {
        NSData *data = [ZCBluthDataTool sendSetDeviceVoiceOrder:type];
//        NSLog(@"%@", data);
        [weakself setDeviceData:data];
    };
}

- (void)setDeviceData:(NSData *)data {
    if([ZCPowerServer defaultBLEServer].connectFlag) {
        [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    } else {
        [self.view makeToast:NSLocalizedString(@"断开连接", nil) duration:2.0 position:CSToastPositionCenter];
    }
        
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = rgba(246, 246, 246, 1);
        [_tableView registerClass:[ZCMoreSetSimpleCell class] forCellReuseIdentifier:@"ZCMoreSetSimpleCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {                
        _dataArr = [NSMutableArray arrayWithArray:@[
            @{@"title":NSLocalizedString(@"固件升级", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"设置音量", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"设置语言", nil), @"content":@""},
            @{@"title":NSLocalizedString(@"设置单位", nil), @"content":@""},
        ]];
    }
    return _dataArr;
}

- (void)configureNavi {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"设置", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
}

@end
