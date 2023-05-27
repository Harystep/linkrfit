//
//  ZCBluthDataTool.h
//  PowerDance
//
//  Created by PC-N121 on 2021/12/7.
//

#import <Foundation/Foundation.h>

#define kMaxLenght (1024*20)

typedef enum : NSUInteger {
    TrainModeMIIT = 0,
    TrainModeHIIT,
    TrainModeTABATA,
    TrainModeMMA1,
    TrainModeMMA2,
    TrainModeFGB1,
    TrainModeFGB2,
} TrainMode;

NS_ASSUME_NONNULL_BEGIN


@interface ZCBluthDataTool : NSObject

@property (nonatomic, assign) Byte *bytes;

+ (NSData *)getClockMode;
+ (NSData *)getMIITMode;
+ (NSData *)getHIITMode;
+ (NSData *)getTABATAMode;
+ (NSData *)getMMA1Mode;
+ (NSData *)getMMA2Mode;
+ (NSData *)getFGB1Mode;
+ (NSData *)getFGB2Mode;
+ (NSData *)getWRCMode;
+ (NSData *)getUPMode;
+ (NSData *)getDOWNMode;
+ (NSData *)getSTOPWATCHMode;
+ (NSData *)timerDelayOpen;

+ (NSData *)operateScreenLight;
+ (NSData *)operateScreenDark;

+ (NSData *)timerSet;
+ (NSData *)timerStart;
+ (NSData *)timerStop;
+ (NSData *)timerReset;
+ (NSData *)getFSMode;

+ (NSData *)timerOpen;
+ (NSData *)timerClose;

+ (NSData *)volumeMax;
+ (NSData *)volumeMin;
+ (NSData *)volumeMiddle;
+ (NSData *)volumeClose;

+ (NSData *)brightMax;
+ (NSData *)brightMiddle;
+ (NSData *)brightMin;

+ (NSData *)hours24Change;
+ (NSData *)hours12Change;

+ (NSData *)timerDelayOpen:(NSInteger)mouse;
+ (NSData *)timerDelayClose;

+ (NSInteger)convertAutoModeToIndex:(NSString *)content;

+ (NSArray *)timerAutoModeData:(TrainMode)mode;

+ (CGFloat)convertTimerModeTime:(TrainMode)mode;

+ (NSData *)sendAutoDataWithMode:(NSString *)content;

+ (NSData *)brightData:(NSInteger)tag;

+ (NSData *)volumeData:(NSInteger)tag;

+ (NSData *)timeTypeChange:(NSInteger)type;

+ (NSData *)downModeSetMouse:(NSInteger)mouse;

+ (NSString *)convertModeContentWithType:(NSString *)type;

+ (NSData *)sendWRCData:(NSString *)content;

+ (NSData *)sendFSData:(NSString *)content;

+ (NSData *)setTimerCurrentTime:(NSString *)time;

+ (NSData *)hoursSmall24Change;
+ (NSData *)hoursSmall12Change;

+ (void)saveTimerBluthNameContent:(NSArray *)array;

+ (BOOL)judgeTimerBluthNameWithContent:(NSString *)content;

+ (void)saveTrainDownStatus:(BOOL)flag;
+ (BOOL)getTrainDownStatus;

+ (void)saveTrainHour12Status:(BOOL)flag;
+ (BOOL)getTrainHour12Status;

/// 十六进制转化
/// @param hexStr <#hexStr description#>
+ (unsigned long long)convertHexToDecimal:(NSString *)hexStr;

+ (NSString *)ToHex:(long long int)tmpid;

//跳绳
+ (NSData *)getSuitRopeMode ;
//健腹轮
+ (NSData *)getSuitJFLMode ;
//拉力器
+ (NSData *)getSuitPowerMode ;

+ (NSData *)setSuitTimeMode:(NSString *)time ;

+ (NSData *)setSuitNumMode:(NSString *)num ;

+ (NSData *)setSuitSportState:(NSString *)state;

/// 设置运动模式
/// @param mode <#mode description#>
+ (NSData *)setSuitSportMode:(NSString *)mode;

+ (NSString *)convertSuitNameWithMode:(NSString *)mode;

+ (NSData *)sendGetTokenContent;

/// 开始
+ (NSData *)sendStartStationOperate;
/// 暂停
+ (NSData *)sendStopStationOperate;
/// 收绳
+ (NSData *)sendBackRopeStationOperate;
//设置运动模式
+ (NSData *)sendSportModeStationOperate:(NSString *)mode;

/// 设置运动模式值
+ (NSData *)setDeviceSportMode:(NSString *)mode value:(NSString *)value;
/// 获取设备基本信息
+ (NSData *)sendGetDeviceInfoOrder;

/// 获取当前设备运动模式
+ (NSData *)sendGetSportCurrentModeInfo;

/// 获取当前运动速度
+ (NSData *)sendGetSportSpeedOrder;

/// 获取当前拉力
+ (NSData *)sendGetDevicePullForceOrder;
/// 获取当前模式设定值
+ (NSData *)sendGetCurrentModeSetValueOrder;

/// 获取当前爆发力
+ (NSData *)sendGetPowerForceOrder;

//获取消耗卡路里
+ (NSData *)sendGetConsumeKcalOrder;

//获取训练次数
+ (NSData *)sendGetTrainTimesOrder;

//语言设置
+ (NSData *)sendSetDeviceLanguageOrder:(NSString *)byte;

//音量设置
+ (NSData *)sendSetDeviceVoiceOrder:(NSString *)byte;

//重量单位设置
+ (NSData *)sendSetDeviceUnitOrder:(NSString *)byte;

//將16進制的字符串轉換成NSData
+ (NSMutableData *)convertHexStrToData:(NSString *)str;

/// 将字符串转为十六进制字符串
/// - Parameter str: <#str description#>
+ (NSString *)convertStringToHexStr:(NSString *)str;

+ (NSData *)setPullPowerData;

/// 发送文件
/// - Parameters:
///   - package: <#package description#>
///   - content: <#content description#>
///   - filename: <#filename description#>
+ (NSData *)sendFilePackage:(NSString *)package fileCrc:(NSString *)fileCrc content:(NSString *)content filename:(NSString *)filename total:(NSInteger)totalIndex currentIndex:(NSInteger)currentIndex bytes:(Byte *)bytes ;

/// 开始更新
/// - Parameters:
///   - type: <#type description#>
///   - name: <#name description#>
+ (NSData *)setStartUpdateWithType:(NSString *)type fileName:(NSString *)name;

/// 获取设备参数
+ (NSData *)getDeviceVersionInfo;

/// 拉力设置 kg
+ (NSArray *)getPowerPullConfigureData;

/// 收力设置 kg
+ (NSArray *)getPowerPutConfigureData;

/// 速度设置 cm/s
+ (NSArray *)getPowerSpeedConfigureData;

/// 拉力系数设置 g/cm
+ (NSArray *)getPowerPullCoefficientConfigureData;

/// 划船阻力设置 g/cm
+ (NSArray *)getPowerBoatResistanceConfigureData;

/// 模式数据设置
/// - Parameter mode: <#mode description#>
+ (NSArray *)convertDataWithMode:(NSInteger)mode;

/// 模式单位转换
/// - Parameter mode: <#mode description#>
+ (NSString *)convertUnitTitleWithMode:(NSInteger)mode;

/// 实际位置
+ (NSData *)getDeviceSportLocalData;

/// 十六进制转浮点float
/// - Parameter hexStr: <#hexStr description#>
+ (float)convertHexStrTopFloat:(NSString *)hexStr;

/*-------------------------- 单电机 --------------------------*/
/// 设置常规模式 离心力 向心力
/// @param content 设置数据
+ (NSData *)sendSportModePowerData:(NSString *)content;

/// 设置等速模式 0x7107  cm/s
/// @param content <#content description#>
+ (NSData *)sendSportModeSpeedData:(NSString *)content;

/// 设置弹力绳 0x7109  g/cm
/// @param content <#content description#>
+ (NSData *)sendSportModeRopeData:(NSString *)content;

/// 获取当前速度
+ (NSData *)getCurrentModeSport;

/// 获取当前拉力
+ (NSData *)getCurrentModePullSport;

/// 收绳
+ (NSData *)startSportBackRopeSingleMode;

/// 设置运动模式
/// - Parameter data: <#data description#>
+ (NSData *)setCurrentSportMode:(NSString *)data;

/// 设置档位
/// - Parameter content: <#content description#>
+ (NSData *)sendSportGearModeData:(NSString *)content;

+ (NSData *)readSportPullModeData;
+ (NSData *)readSportKcalModeData;
+ (NSData *)readSportPowerModeData;
+ (NSData *)readSportLocalModeData;

+ (NSData *)startSportSingleMode;
+ (NSData *)stopSportSingleMode;

+(unsigned int)getMaxFileCRC16WithContent:(NSString *)dataStr index:(NSInteger)index maxIndex:(NSInteger)maxIndex remainLen:(NSInteger)remainLen  crc:(unsigned int)crc;

+ (unsigned int)GetSmallCRC16:(unsigned char *)puchMsg len:(unsigned int)usDataLen first:(unsigned int)first;

@end

NS_ASSUME_NONNULL_END
