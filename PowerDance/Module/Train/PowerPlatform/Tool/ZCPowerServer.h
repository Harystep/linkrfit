//
//  ZCPowerServer.h
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeriperalInfo.h"

#define kUpdateFileBackNoticeKey @"kUpdateFileBackNoticeKey"//文件上传
#define kStartFileBackNoticeKey @"kStartFileBackNoticeKey"//文件更新
#define kUpdataCurrentModeValueKey @"kUpdataCurrentModeValueKey"//当前模式设置值
#define kUpdataPowerValueKey @"kUpdataPowerValueKey"//爆发力
#define kUpdataKcalValueKey @"kUpdataKcalValueKey"//卡路里
#define kUpdataLocalValueKey @"kUpdataLocalValueKey"//位置
#define kUpdataCurrentPullValueKey @"kUpdataCurrentPullValueKey"//实际拉力
#define kGetDeviceBaseInfoKey @"kGetDeviceBaseInfoKey"//获取设备参数信息

NS_ASSUME_NONNULL_BEGIN

typedef void (^eventBlock)(CBPeripheral *peripheral, BOOL status, NSError *error);
typedef enum{
    KNOT = 0,
    KING = 1,
    KSUCCESS = 2,
    KFAILED = 3,
}myStatus;



@protocol BLEPowerServerDelegate

@optional
-(void)didStopScan;
-(void)didFoundPeripheral;
-(void)didReadvalue;
-(void)didNotifyData;
-(void)didConnect:(PeriperalInfo *)info;

-(void)saveDataResult:(NSString *)data unit:(NSString *)unit;

-(void)backData:(NSString *)data unit:(NSString *)unit;

@required
-(void)didDisconnect;

@end

#define kPowerServerStore  [ZCPowerServer defaultBLEServer]

@interface ZCPowerServer : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

+(ZCPowerServer *)defaultBLEServer;

@property(weak, nonatomic) id<BLEPowerServerDelegate> delegate;
@property (nonatomic,assign) BOOL connectFlag;//标记是否连接
@property (nonatomic,copy) NSString *unitStr;//单位
@property (strong,nonatomic)NSMutableArray *discoveredPeripherals; //发现的外设数组
@property (strong,nonatomic)CBPeripheral* selectPeripheral; //选中的外设
@property (strong,nonatomic)CBService* discoveredSevice; //发现的服务
@property (strong,nonatomic)CBCharacteristic *selectCharacteristic; //选中的特征
@property (strong,nonatomic)CBCharacteristic *selectFileCharacteristic; //选中文件的特征
@property (strong,nonatomic)CBCentralManager *myCenter;

//
-(void)startScan;
-(void)startScan:(NSInteger)forLastTime;

-(void)stopScan;
-(void)stopScan:(BOOL)withOutEvent;

-(void)connect:(PeriperalInfo *)peripheralInfo withFinishCB:(eventBlock)callback;
-(void)disConnect;
-(void)discoverService:(CBService*)service;

-(void)readValue:(CBCharacteristic*)characteristic;
-(void)notifyValue:(CBCharacteristic *)characteristic;


//state
-(NSInteger)getConnectState;
-(NSInteger)getServiceState;
-(NSInteger)getCharacteristicState;


@end

NS_ASSUME_NONNULL_END
