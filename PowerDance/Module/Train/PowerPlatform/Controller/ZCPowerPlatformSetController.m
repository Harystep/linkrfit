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
@property (nonatomic,assign) int disconnectFlag;//断开连接
@property (nonatomic,strong) ZCPowerStationAlertView *updateView;

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
    [self setupFooterSubViews:footerView];
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBackSucNotice:) name:@"kUpdataBackNoticeKey" object:nil];
    [self downloadFileOperate];
}

- (void)updataBackSucNotice:(NSNotification *)noti {
    self.updateView.successFlag = YES;
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
            NSMutableString *str = [NSMutableString stringWithCapacity:data.length];
            for (int i = 0; i < data.length; i ++) {
                [str appendFormat:@"%02x", bytes[i]];
            }
            NSLog(@"str:%@", str);
            self.subpackage = str;
            self.remainLength = data.length % 128;
            self.totalIndex = ceil(data.length/128.0);
            NSLog(@"%tu-%tu", self.remainLength, self.totalIndex);
            self.bytes = bytes;
            self.filename = @"test.bin";
//            [ZCBluthDataTool sendFilePackage:self.subpackage content:[self.subpackage substringWithRange:NSMakeRange(0, 256)] filename:[ZCBluthDataTool convertStringToHexStr:@"test.bin"] total:self.totalIndex currentIndex:0 bytes:self.bytes];
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
            length = self.remainLength;
        }
        package = [self.subpackage substringWithRange:NSMakeRange(256*index, length)];
        NSString *filename = [ZCBluthDataTool convertStringToHexStr:self.filename];
        NSData *data = [ZCBluthDataTool sendFilePackage:self.subpackage content:package filename:filename total:self.totalIndex currentIndex:self.index bytes:self.bytes];
        if([ZCPowerServer defaultBLEServer].selectPeripheral != nil) {
            [[ZCPowerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[ZCPowerServer defaultBLEServer].selectFileCharacteristic type:CBCharacteristicWriteWithResponse];
            NSLog(@">>>%tu", self.index);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(self.disconnectFlag) {
                } else {
                    [self updataBackNotice];
                }
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
}

- (void)updateOperate {
    ZCPowerStationAlertView *alertView = [[ZCPowerStationAlertView alloc] init];
    self.updateView = alertView;
    [alertView showAlertView];
    kweakself(self);
    alertView.updateBlock = ^{
//        [weakself sendSubpackageWithindex:0];
    };
}

- (void)unitOperate {
    ZCPowerStationSetUnitView *alertView = [[ZCPowerStationSetUnitView alloc] init];
    [alertView showAlertView];
}

- (void)languageOperate {
    ZCPowerStationSetLanguageView *alertView = [[ZCPowerStationSetLanguageView alloc] init];
    [alertView showAlertView];
}

- (void)aboutOperate {
    ZCPowerStationAboutView *alertView = [[ZCPowerStationAboutView alloc] init];
    [alertView showAlertView];
}

- (void)voiceOperate {
    ZCPowerStationVoiceView *alertView = [[ZCPowerStationVoiceView alloc] init];
    [alertView showAlertView];
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
