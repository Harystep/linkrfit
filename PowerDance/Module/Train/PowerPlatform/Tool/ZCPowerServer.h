//
//  ZCPowerServer.h
//  PowerDance
//
//  Created by oneStep on 2023/4/25.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeriperalInfo.h"

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

@interface ZCPowerServer : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

+(ZCPowerServer *)defaultBLEServer;

@property(weak, nonatomic) id<BLEPowerServerDelegate> delegate;

@property (strong,nonatomic)NSMutableArray *discoveredPeripherals; //发现的外设数组
@property (strong,nonatomic)CBPeripheral* selectPeripheral; //选中的外设
@property (strong,nonatomic)CBService* discoveredSevice; //发现的服务
@property (strong,nonatomic)CBCharacteristic *selectCharacteristic; //选中的特征
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
