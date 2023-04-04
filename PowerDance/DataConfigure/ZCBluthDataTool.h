//
//  ZCBluthDataTool.h
//  PowerDance
//
//  Created by PC-N121 on 2021/12/7.
//

#import <Foundation/Foundation.h>

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

@end

NS_ASSUME_NONNULL_END
