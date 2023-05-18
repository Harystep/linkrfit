//
//  ZCPowerServer.m
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import "ZCPowerServer.h"
#import <UIKit/UIKit.h>
#import "CFFUpdateVersionView.h"

#define kName @"powerStation"

@interface ZCPowerServer ()

{
    BOOL inited;
    NSInteger scanState;
    NSInteger connectState;
    NSInteger serviceState;
    NSInteger characteristicState;
    NSInteger readState;
    NSInteger notifyState;
    eventBlock connectBlock;
}

@property (nonatomic,assign) BOOL backStatus;

@property (nonatomic, copy) NSString *backData;
@property (nonatomic, copy) NSString *saveData;

@end

@implementation ZCPowerServer

static ZCPowerServer *_defaultBTServer = nil;

-(NSInteger)getScanState
{
    return scanState;
}
-(NSInteger)getConnectState
{
    return connectState;
}
-(NSInteger)getServiceState
{
    return serviceState;
}
-(NSInteger)getCharacteristicState
{
    return characteristicState;
}
-(NSInteger)getReadState
{
    return readState;
}
-(NSInteger)getNotifyState
{
    return notifyState;
}


#pragma mark 初始化
+(ZCPowerServer *)defaultBLEServer
{
    if (nil == _defaultBTServer) {
        _defaultBTServer = [[ZCPowerServer alloc] init];
        
        [_defaultBTServer initBLE];
    }
    
    return _defaultBTServer;
}

-(void)initBLE
{
    if (inited) {
        return;
    }
    inited = YES;
    self.delegate = nil;
    self.discoveredPeripherals = [NSMutableArray array];
    self.selectPeripheral = nil;
    connectState = KNOT;
    connectBlock = nil;
    
//    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:CBCentralManagerOptionRestoreIdentifierKey,CBCentralManagerOptionShowPowerAlertKey, nil];
    
//    self.myCenter = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_queue_create("rejoin.BLEQueue",NULL ) options:dict];
    
    self.myCenter = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    NSLog(@"myCenter初始化 ........");
    
}

#pragma mark 初始化central之后，执行的方法

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"Bluetooth处于打开状态");
    }
    else if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"Bluetooth处于关闭状态");
        [self showBluetoothStatus:NSLocalizedString(@"蓝牙处于关闭状态", nil)];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"Bluetooth的状态是未经授权的");
//        [self showBluetoothStatus:NSLocalizedString(@"蓝牙状态未经授权", nil)];
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth处于状态未知");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        
        NSLog(@"CoreBluetooth硬件不支持这个平台");
    }
    
}

- (void)showBluetoothStatus:(NSString *)content {
    dispatch_async(dispatch_get_main_queue(), ^{
        CFFUpdateVersionView *alert = [[CFFUpdateVersionView alloc] init];
        alert.title = NSLocalizedString(@"蓝牙连接状态", nil);
        alert.message = content;
        alert.confirmTitle = NSLocalizedString(@"设置", nil);
        alert.cancleTitle = NSLocalizedString(@"取消", nil);
        alert.confirmBackgroundColor = [ZCConfigColor txtColor];
        alert.confirmTitleColor = [ZCConfigColor whiteColor];
        alert.confirmBlock = ^{
            NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        };
        [alert showAlertView];
    });
    
}

#pragma mark 扫描15秒
-(void)startScan
{
    self.backStatus = YES;
    [self startScan:15];
}

-(void)startScan:(NSInteger)forLastTime
{
    [self.discoveredPeripherals removeAllObjects];
    scanState = KING;
//
    NSArray * array=[NSArray array];
    NSArray *retrivedArray = [self.myCenter retrieveConnectedPeripheralsWithServices:array];

    for (CBPeripheral* peripheral in retrivedArray) {
        [self addPeripheral:peripheral advertisementData:nil  RSSI:nil];

    }
    [self.myCenter scanForPeripheralsWithServices:nil options:nil];
    if (forLastTime > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScan) object:nil];
        [self performSelector:@selector(stopScan) withObject:nil afterDelay:forLastTime];
    }
}

-(void)stopScan:(BOOL)withOutEvent
{
    if (scanState != KING) {
        return;
    }
    NSLog(@"stop scan ...");
    
    scanState = KSUCCESS;
    [self.myCenter stopScan];
    
    if(withOutEvent)
        return;
    
    if (self.delegate) {
        if([(id)self.delegate respondsToSelector:@selector(didStopScan)]){
            [self.delegate didStopScan];
        }
    }
}
-(void)stopScan
{
    [self stopScan:YES];
}

#pragma mark 取消连接
-(void)cancelConnect
{
    if (self.myCenter && self.selectPeripheral) {
        if(self.selectPeripheral.state == CBPeripheralStateConnecting){
            NSLog(@"%@连接超时",self.selectPeripheral.name);
            
            [self.myCenter cancelPeripheralConnection:self.selectPeripheral];
            connectState = KNOT;
        }
    }
}

#pragma mark 连接外设
-(void)connect:(PeriperalInfo *)peripheralInfo
{
    if ([peripheralInfo.peripheral.name containsString:kName]) {
        NSLog(@"要连接的外设:%@",peripheralInfo.peripheral.name);
        //连接外设
//        NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
//                                  CBConnectPeripheralOptionNotifyOnNotificationKey:@YES,
//                                CBConnectPeripheralOptionNotifyOnConnectionKey:@YES};
        [self.myCenter connectPeripheral:peripheralInfo.peripheral options:nil];
        
        self.selectPeripheral = peripheralInfo.peripheral;
        connectState = KING;
        double delayInSeconds = 120.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //延迟操作@selector的方法
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelConnect) object:nil];
        });
    }
}

#pragma mark block回调
-(void)connect:(PeriperalInfo *)peripheralInfo withFinishCB:(eventBlock)callback
{
    [self connect:peripheralInfo];
    connectBlock = callback;
}
-(void)disConnect
{
    if(self.myCenter && self.selectPeripheral){
        //断开方法
        [self.myCenter cancelPeripheralConnection:self.selectPeripheral];
    }
}

#pragma mark 读取特征的值
-(void)readValue:(CBCharacteristic*)characteristic
{
    if (characteristic != nil) {
        self.selectCharacteristic = characteristic;
    }
    readState = KING;
    //读取特征的值
    [self.selectPeripheral readValueForCharacteristic:self.selectCharacteristic];
    readState=KSUCCESS;
}

#pragma mark 订阅特征
-(void)notifyValue:(CBCharacteristic *)characteristic
{
    if (characteristic!=nil) {
        self.selectCharacteristic = characteristic;
    }
    notifyState=KING;
    //订阅
    [self.selectPeripheral setNotifyValue:YES forCharacteristic:self.selectCharacteristic];
    notifyState = KSUCCESS;
}

#pragma mark CBCentralManagerDelegate
-(void)addPeripheralInfo:(PeriperalInfo *)peripheralInfo
{
    for(int i=0;i<self.discoveredPeripherals.count;i++){
        PeriperalInfo * pi = self.discoveredPeripherals[i];
        
        if([peripheralInfo.uuid isEqualToString:pi.uuid]){
            [self.discoveredPeripherals replaceObjectAtIndex:i withObject:peripheralInfo];
            return;
        }
    }
    [self.discoveredPeripherals addObject:peripheralInfo];
    if (self.delegate) {
        if([(id)self.delegate respondsToSelector:@selector(didFoundPeripheral)]){
            [self.delegate didFoundPeripheral];
            [self connect:peripheralInfo withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
                NSLog(@"连接成功");
            }];
        }
    }
}

-(void)addPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{
    PeriperalInfo *pi = [[PeriperalInfo alloc]init];
    
    pi.peripheral = peripheral;
    pi.uuid = [peripheral.identifier UUIDString];
    
    if (peripheral.name) {
        pi.name=peripheral.name;
    }
    else
    {
        pi.name=@"Undisclosed Name";
    }
    
    switch (peripheral.state) {
        case CBPeripheralStateDisconnected:
            pi.state = @"disConnected";
            break;
        case CBPeripheralStateConnecting:
            pi.state = @"connecting";
            break;
        case CBPeripheralStateConnected:
            pi.state = @"connected";
            break;
        default:
            break;
    }
    if (advertisementData) {
        
        if ([advertisementData objectForKey:CBAdvertisementDataLocalNameKey]) {
            pi.localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
        }
        else
        {
            pi.localName=@"Undisclosed localName";
        }
        
        if ([advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey]) {
            NSArray *array = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
            pi.serviceUUIDS = [array componentsJoinedByString:@"; "];
        }
        else
        {
            pi.serviceUUIDS=@"Undisclosed serviceUUIDS";
        }
    }
    
    if (RSSI) {
        pi.RSSI = RSSI;
        NSLog(@"rssi:%@",pi.RSSI);
    }
    [self addPeripheralInfo:pi];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSString *name = checkSafeContent(advertisementData[@"kCBAdvDataLocalName"]);
    if ([peripheral.name containsString:kName] || [name containsString:kName]) {
        NSLog(@"发现外设:%@;RSSI:%@", peripheral.name, RSSI);
        if (peripheral.name.length > 0) {
            [self addPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    }
    
}

#pragma mark 调用完centralManager:didDiscoverPeripheral:advertisementData:RSSI:方法连接外设
#pragma mark 如果连接成功会调用如下方法：
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    connectState = KSUCCESS;
    if (connectBlock) {
        connectBlock(peripheral,true,nil);
        connectBlock = nil;
    }
    peripheral.delegate = self;
    self.selectPeripheral = peripheral;
    serviceState = KING;
    [self.selectPeripheral discoverServices:nil];
    NSLog(@"selectPeripheral---->%@", self.selectPeripheral);
}

#pragma mark 外设断开回调这个方法:
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"断开外设:%@",peripheral.name);
    connectState = KFAILED;
    if (connectBlock) {
        connectBlock(peripheral,false,nil);
        connectBlock = nil;
    }
    
    if (self.delegate) {
        if([(id)self.delegate respondsToSelector:@selector(didDisconnect)]){
            [self.delegate didDisconnect];
        }
    }
}


#pragma mark 如果连接失败会调用如下方法：
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接失败的原因:%@",error.localizedDescription);
}

#pragma mark CBPeripheralDelegate
#pragma mark 外设连接之后，找到该设备上的指定服务 调用CBPeripheralDelegate方法

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (nil == error) {
        serviceState = KSUCCESS;
//        NSLog(@"发现的服务:%@",peripheral.services);
        NSArray *services = peripheral.services;
        for (CBService *service in services) {
            NSLog(@"UUIDString-->%@", [service.UUID UUIDString]);
            [peripheral discoverCharacteristics:NULL forService:service];
//            if ([[service.UUID UUIDString] containsString:@"5CB7"]) {
//                break;
//            }
        }
    }
    else{
        serviceState = KFAILED;
        NSLog(@"寻找服务失败:%@",error.localizedDescription);
    }
}

#pragma mark 找到特征之后调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (nil == error) {
        for (CBCharacteristic *ch in service.characteristics) {
            NSLog(@"UUID--->%@", [ch.UUID UUIDString]);
            
            if ([[ch.UUID UUIDString] containsString:@"FED1"]) {
                [peripheral setNotifyValue:YES forCharacteristic:ch];
                [peripheral readValueForCharacteristic:ch];
                self.selectCharacteristic = ch;
                characteristicState = KSUCCESS;
                self.discoveredSevice = service;
                if([(id)self.delegate respondsToSelector:@selector(didConnect:)]){
                    [self.delegate didConnect:nil];
                }
            } else if ([[ch.UUID UUIDString] containsString:@"2902"]) {//写入数据
                NSLog(@"读写设备");
                [peripheral setNotifyValue:YES forCharacteristic:ch];
                [peripheral readValueForCharacteristic:ch];
                
            } else if ([[ch.UUID UUIDString] containsString:@"FED2"]) {//订阅写入文件服务
                NSLog(@"读写设备");
                [peripheral setNotifyValue:YES forCharacteristic:ch];
                [peripheral readValueForCharacteristic:ch];
                self.selectFileCharacteristic = ch;
            }
        }
        
    } else {
        
    }
}
#pragma mark 订阅之后调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    [peripheral readValueForCharacteristic:characteristic];//接受通知后读取
    [peripheral discoverDescriptorsForCharacteristic:characteristic];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    else
    {
        return;
    }
}

#pragma mark 当设备有数据返回时会调用如下方法：
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([[characteristic.UUID UUIDString] containsString:@"FED1"]) {//
        NSData *data = characteristic.value;
        NSString *content = [self transformCharateristicValueFromData:data];
//        NSLog(@"%@", content);
        if ([content hasPrefix:@"010204"]) {//保存token
            NSString *token = [content substringFromIndex:6];
            NSLog(@"token:%@", token);
            kUserStore.tokenBytes = token;
        } else if ([content hasPrefix:@"03020320"]) {//常规模式
            NSLog(@"常规模式:%@", content);
        } else if ([content hasPrefix:@"03020321"]) {//离心模式
            NSLog(@"离心模式:%@", content);
        } else if ([content hasPrefix:@"03020321"]) {//向心模式
            NSLog(@"向心模式:%@", content);
        } else if ([content hasPrefix:@"03020322"]) {//等速模式
            NSLog(@"等速模式:%@", content);
        } else if ([content hasPrefix:@"03020323"]) {//拉力绳模式
            NSLog(@"拉力绳模式:%@", content);
        } else if ([content hasPrefix:@"03020324"]) {//划船机模式
            NSLog(@"划船机模式:%@", content);
        } else if ([content hasPrefix:@"04020211"]) {//获取当前运动模式
            NSLog(@"当前运动模式:%@", content);
        } else if ([content hasPrefix:@"04020515"]) {//获取实际速度
            NSLog(@"实际速度:%@", content);
        } else if ([content hasPrefix:@"04020516"]) {//获取实际拉力或收力
            NSString *value = [content substringWithRange:NSMakeRange(8, 8)];
            NSLog(@"获取实际拉力或收力:%@", value);
            NSString *lowEnd = [value substringWithRange:NSMakeRange(0, 2)];
            NSString *highEnd = [value substringWithRange:NSMakeRange(2, 2)];
            NSString *lowPre = [value substringWithRange:NSMakeRange(4, 2)];
            NSString *highPre = [value substringWithRange:NSMakeRange(6, 2)];
            value = [NSString stringWithFormat:@"%@%@%@%@", highPre, lowPre, highEnd, lowEnd];
            long power = [ZCBluthDataTool convertHexToDecimal:value];
            NSLog(@"获取实际拉力或收力 value:%@g", value);
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataCurrentPullValueKey object:[NSString stringWithFormat:@"%.2f", power/10.0]];
        } else if ([content hasPrefix:@"04020517"]) {//获取消耗卡路里
            NSLog(@"消耗卡路里:%@", content);
            NSString *value = [content substringWithRange:NSMakeRange(8, 8)];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataKcalValueKey object:value];
        } else if ([content hasPrefix:@"04020518"]) {//获取训练次数
            NSLog(@"训练次数:%@", content);
        } else if ([content hasPrefix:@"04020501"]) {//获取设备参数
            NSLog(@"设备参数:%@", content);
        } else if ([content hasPrefix:@"03020303"]) {//重量单位设置
            NSLog(@"单位设置:%@", content);
        } else if ([content hasPrefix:@"03020302"]) {//音量设置
            NSLog(@"音量设置:%@", content);
        } else if ([content hasPrefix:@"03020301"]) {//语言设置
            NSLog(@"语言设置:%@", content);
        } else if ([content hasPrefix:@"05021301"]) {//上传文件返回结果
            NSString *type = [content substringWithRange:NSMakeRange(8, 2)];
            NSLog(@"file:%@", content);
            if([type isEqualToString:@"00"] || [type isEqualToString:@"0"]) {//成功
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateFileBackNoticeKey object:nil];
            } else {//失败
                
            }
        } else if ([content hasPrefix:@"0402071b"]) {
            //            NSLog(@"爆发力:%@", content);
            NSString *value = [content substringWithRange:NSMakeRange(8, 12)];
            NSLog(@"爆发力：%@", value);
            NSString *left = [value substringWithRange:NSMakeRange(0, 6)];
            NSString *right = [value substringWithRange:NSMakeRange(6, 6)];
            NSString *leftStatus = [left substringWithRange:NSMakeRange(0, 2)];
            NSString *rightStatus = [right substringWithRange:NSMakeRange(0, 2)];
            NSString *contentLeft = [left substringWithRange:NSMakeRange(2, 4)];
            NSString *contentRight = [left substringWithRange:NSMakeRange(2, 4)];
            contentLeft = [self convert4HexTransData:contentLeft];
            contentRight = [self convert4HexTransData:contentRight];
            if([leftStatus isEqualToString:@"01"] && [rightStatus isEqualToString:@"01"]) {
                long pullLeft = [ZCBluthDataTool convertHexToDecimal:contentLeft];
                long pullRight = [ZCBluthDataTool convertHexToDecimal:contentRight];
                double agv = (pullLeft + pullRight) / 2.0;
                value = [NSString stringWithFormat:@"%.2f", agv/100.0];
            } else if([leftStatus isEqualToString:@"01"] && [rightStatus isEqualToString:@"00"]) {
                long pullLeft = [ZCBluthDataTool convertHexToDecimal:contentLeft];
                value = [NSString stringWithFormat:@"%.2f", pullLeft/100.0];
            } else if([leftStatus isEqualToString:@"00"] && [rightStatus isEqualToString:@"01"]) {
                long pullRight = [ZCBluthDataTool convertHexToDecimal:contentRight];
                value = [NSString stringWithFormat:@"%.2f", pullRight/100.0];
            } else {
                value = @"0.0";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataPowerValueKey object:value];
            NSLog(@"爆发力 value：%@", value);
        } else if ([content hasPrefix:@"04020612"]){//当前模式设置值
            NSString *value = [content substringWithRange:NSMakeRange(10, 4)];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataCurrentModeValueKey object:value];
        } else if ([content hasPrefix:@"04020b1a"]) {
            NSLog(@"位置：%@", content);
            NSString *value = [content substringWithRange:NSMakeRange(8, 20)];
            NSString *left = [value substringWithRange:NSMakeRange(0, 10)];
            NSString *right = [value substringWithRange:NSMakeRange(10, 10)];
            NSString *leftStatus = [left substringWithRange:NSMakeRange(0, 2)];
            NSString *rightStatus = [right substringWithRange:NSMakeRange(0, 2)];
            NSString *contentLeft = [left substringWithRange:NSMakeRange(2, 8)];
            NSString *contentRight = [left substringWithRange:NSMakeRange(2, 8)];
            NSString *leftValue = @"0";
            NSString *rightValue =  @"0";
            if ([leftStatus isEqualToString:@"01"] && [rightStatus isEqualToString:@"01"]) {
                leftValue = [NSString stringWithFormat:@"%.1f", [ZCBluthDataTool convertHexToDecimal:[self convert8HexTransData:contentLeft]]/1000.0];
                rightValue = [NSString stringWithFormat:@"%.1f", [ZCBluthDataTool convertHexToDecimal:[self convert8HexTransData:contentRight]]/1000.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataLocalValueKey object:@{@"left":leftValue, @"right":rightValue}];
            } else if([leftStatus isEqualToString:@"01"] && [rightStatus isEqualToString:@"00"]) {
                leftValue = [NSString stringWithFormat:@"%.1f", [ZCBluthDataTool convertHexToDecimal:[self convert8HexTransData:contentLeft]]/1000.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataLocalValueKey object:@{@"left":leftValue, @"right":rightValue}];
            } else if([leftStatus isEqualToString:@"00"] && [rightStatus isEqualToString:@"01"]) {
                rightValue = [NSString stringWithFormat:@"%.1f", [ZCBluthDataTool convertHexToDecimal:[self convert8HexTransData:contentRight]]/1000.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataLocalValueKey object:@{@"left":leftValue, @"right":rightValue}];
            }
            NSLog(@"left:%@ right:%@", leftValue, rightValue);
        }
    }
    //00002
    if (error){
        if (readState==KFAILED) {
            NSLog(@"特征:%@ 的值错误error: %@", characteristic.UUID, [error localizedDescription]);
        }
        if (notifyState==KFAILED) {
            NSLog(@"特征:%@ 的值错误error: %@", characteristic.UUID, [error localizedDescription]);
        }
        
        return;
    } else {
        
    }
}

// 更新特征的描述的值的时候会调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    // 这里当描述的值更新的时候,直接调用此方法即可
    [peripheral readValueForDescriptor:descriptor];
}

#pragma mark 数据写入成功回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"写入成功");
}

- (NSString *)transformCharateristicValueFromData:(NSData *)dataValue{
    if (!dataValue || [dataValue length] == 0) {
        return @"";
    }
    NSMutableString *destStr = [[NSMutableString alloc]initWithCapacity:[dataValue length]];
    [dataValue enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        unsigned char *dataBytes = (unsigned char *)bytes;
        for (int i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x",(dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [destStr appendString:hexStr];
            }else{
                [destStr appendFormat:@"0%@",hexStr];
            }
        }
    }];
    return destStr;
}

- (NSString *)convert4HexTransData:(NSString *)content {
    return [NSString stringWithFormat:@"%@%@", [content substringWithRange:NSMakeRange(2, 2)], [content substringWithRange:NSMakeRange(0, 2)]];
}

- (NSString *)convert8HexTransData:(NSString *)value {
    NSString *lowEnd = [value substringWithRange:NSMakeRange(0, 2)];
    NSString *highEnd = [value substringWithRange:NSMakeRange(2, 2)];
    NSString *lowPre = [value substringWithRange:NSMakeRange(4, 2)];
    NSString *highPre = [value substringWithRange:NSMakeRange(6, 2)];
    value = [NSString stringWithFormat:@"%@%@%@%@", highPre, lowPre, highEnd, lowEnd];
    return value;
}

@end
