//
//  ZCPowerSingleServer.m
//  PowerDance
//
//  Created by oneStep on 2023/4/28.
//

#import "ZCPowerSingleServer.h"
#import <UIKit/UIKit.h>
#import "CFFUpdateVersionView.h"

#define kName @"ai-Thinker"

@interface ZCPowerSingleServer ()

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

@implementation ZCPowerSingleServer

static ZCPowerSingleServer *_defaultBTServer = nil;

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
+(ZCPowerSingleServer *)defaultBLEServer
{
    if (nil == _defaultBTServer) {
        _defaultBTServer = [[ZCPowerSingleServer alloc] init];
        
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
            if ([[ch.UUID UUIDString] containsString:@"ECBE34729BB3"]) {
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
            } else if ([[ch.UUID UUIDString] containsString:@"9616"]) {//写入数据
                NSLog(@"读写设备");
                [peripheral setNotifyValue:YES forCharacteristic:ch];
                [peripheral readValueForCharacteristic:ch];
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
    NSData *data = characteristic.value;
    NSLog(@"data:%@", data);
    if ([[characteristic.UUID UUIDString] containsString:@"ECBE34729BB3"]) {//
        Byte *bytes = (Byte *)[data bytes];
        NSString *content = [self transformCharateristicValueFromData:characteristic.value];
        NSLog(@"content:%@", content);
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

@end
