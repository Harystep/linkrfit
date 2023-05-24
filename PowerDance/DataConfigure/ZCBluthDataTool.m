//
//  ZCBluthDataTool.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/7.
//

#import "ZCBluthDataTool.h"
#import "ZCPowerServer.h"

@interface ZCBluthDataTool ()

@end

@implementation ZCBluthDataTool

+ (NSData *)getMIITMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
//        return [self timerDelayClose];//关闭10s
        return [self hours12Change];
    } else {
        return [self convertStringTOASCIIData:@"Mode:0"];
    }
}
+ (NSData *)getHIITMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
//        return [self timerDelayOpen];//开启10s
        return [self hours24Change];
    } else {
        return [self convertStringTOASCIIData:@"Mode:1"];
    }
}
+ (NSData *)getTABATAMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:4"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:2"];
    }
    
}
+ (NSData *)getMMA1Mode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self hours24Change];//24H
    } else {
        return [self convertStringTOASCIIData:@"Mode:3"];
    }
}
+ (NSData *)getMMA2Mode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self hours12Change];//12H
    } else {
        return [self convertStringTOASCIIData:@"Mode:4"];
    }
}
+ (NSData *)getFGB1Mode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:6"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:5"];
    }
}
+ (NSData *)getFGB2Mode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:7"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:6"];
    }
}
+ (NSData *)getWRCMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:5"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:7"];
    }
}
+ (NSData *)getSTOPWATCHMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:3"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:8"];
    }
}
+ (NSData *)getClockMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:0"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:9"];
    }
}
+ (NSData *)getUPMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:1"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:10"];
    }
}
+ (NSData *)getDOWNMode {
    if ([ZCDataTool getTimerTypeStatus] == 1) {
        return [self convertStringTOASCIIData:@"Mode:2"];
    } else {
        return [self convertStringTOASCIIData:@"Mode:11"];
    }
}
+ (NSData *)getFSMode {
    return [self convertStringTOASCIIData:@"Mode:12"];
}
+ (NSData *)getBEEPMode {
    return [self convertStringTOASCIIData:@"Mode:13"];
}

+ (NSData *)operateScreenLight {
    return [self convertStringTOASCIIData:@"Led:1"];
}
+ (NSData *)operateScreenDark {
    return [self convertStringTOASCIIData:@"Led:0"];
}
+ (NSData *)brightMax {
    return [self convertStringTOASCIIData:@"Bright:1"];
}
+ (NSData *)brightMiddle {
    return [self convertStringTOASCIIData:@"Bright:2"];
}
+ (NSData *)brightMin {
    return [self convertStringTOASCIIData:@"Bright:3"];
}

+ (NSData *)sendWRCData:(NSString *)content {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"WRC:%@", content]];
}

+ (NSData *)sendFSData:(NSString *)content {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"FS:%@", content]];
}

+ (NSData *)timerSet {
    return [self convertStringTOASCIIData:@"Set"];
}
+ (NSData *)timerStart {
    return [self convertStringTOASCIIData:@"Start"];
}
+ (NSData *)timerStop {
    return [self convertStringTOASCIIData:@"Stop"];
}
+ (NSData *)timerReset {
    return [self convertStringTOASCIIData:@"Reset"];
}

+ (NSData *)timerDelayOpen:(NSInteger)mouse {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"Delay:%tu", mouse]];
}
+ (NSData *)timerDelayClose {
    return [self convertStringTOASCIIData:@"Delay:0"];
}
+ (NSData *)timerDelayOpen {
    return [self convertStringTOASCIIData:@"Delay:1"];
}

+ (NSData *)volumeMax {
    return [self convertStringTOASCIIData:@"Mute:1"];
}
+ (NSData *)volumeMin {
    return [self convertStringTOASCIIData:@"Mute:3"];
}
+ (NSData *)volumeMiddle {
    return [self convertStringTOASCIIData:@"Mute:2"];
}
+ (NSData *)volumeClose {
    return [self convertStringTOASCIIData:@"Mute:0"];
}

+ (NSData *)brightData:(NSInteger)tag {
    NSData *data;
    switch (tag) {
        case 0:
            data = [self volumeClose];
            break;
        case 1:
            data = [self brightMax];
            break;
        case 2:
            data = [self brightMiddle];
            break;
        case 3:
            data = [self brightMin];
            break;
            
        default:
            break;
    }
    return data;
}

+ (NSData *)volumeData:(NSInteger)tag {
    NSData *data;
    switch (tag) {
        case 0:
            data = [self volumeClose];
            break;
        case 1:
            data = [self volumeMax];
            break;
        case 2:
            data = [self volumeMiddle];
            break;
        case 3:
            data = [self volumeMin];
            break;
            
        default:
            break;
    }
    return data;
}
//无效
+ (NSData *)hours24Change {
    return [self convertStringTOASCIIData:@"H24:0"];
}
//无效
+ (NSData *)hours12Change {
    return [self convertStringTOASCIIData:@"H24:1"];
}

+ (NSData *)hoursSmall24Change {
    return [self convertStringTOASCIIData:@"H24:1"];
}
+ (NSData *)hoursSmall12Change {
    return [self convertStringTOASCIIData:@"H24:0"];
}

+ (NSData *)setTimerCurrentTime:(NSString *)time {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"Time:%@", time]];
}

+ (NSData *)timeTypeChange:(NSInteger)type {
    if(type) {
        return [self hours12Change];
    } else {
        return [self hours24Change];
    }
}

+ (NSData *)convertStringTOASCIIData:(NSString *)content {
    NSData *data = [content dataUsingEncoding:NSASCIIStringEncoding];    
    return data;
}

+ (NSData *)sendAutoDataWithMode:(NSString *)content {
    NSData *data = [self getMIITMode];
    if ([content isEqualToString:@"MIIT"]) {
        data = [self getMIITMode];
    } else if ([content isEqualToString:@"HIIT"]) {
        data = [self getHIITMode];
    } else if ([content isEqualToString:@"TABATA"]) {
        data = [self getTABATAMode];
    } else if ([content isEqualToString:@"MMA1"]) {
        data = [self getMMA1Mode];
    } else if ([content isEqualToString:@"MMA2"]) {
        data = [self getMMA2Mode];
    } else if ([content isEqualToString:@"FGB1"]) {
        data = [self getFGB1Mode];
    } else if ([content isEqualToString:@"FGB2"]) {
        data = [self getFGB2Mode];
    }
    return data;
}

+ (NSInteger)convertAutoModeToIndex:(NSString *)content {
    NSInteger index = 0;
    if ([content isEqualToString:@"MIIT"]) {
        index = 0;
    } else if ([content isEqualToString:@"HIIT"]) {
        index = 1;
    } else if ([content isEqualToString:@"TABATA"]) {
        index = 2;
    } else if ([content isEqualToString:@"MMA1"]) {
        index = 3;
    } else if ([content isEqualToString:@"MMA2"]) {
        index = 4;
    } else if ([content isEqualToString:@"FGB1"]) {
        index = 5;
    } else if ([content isEqualToString:@"FGB2"]) {
        index = 6;
    }
    return index;
}

+ (NSArray *)timerAutoModeData:(TrainMode)mode {
    NSArray *itemArr;
    switch (mode) {
        case TrainModeMIIT:
            itemArr = @[@"01:00", @"01:00", @"99"];
            break;
        case TrainModeHIIT:
            itemArr = @[@"00:30", @"00:30", @"99"];
            break;
        case TrainModeTABATA:
            itemArr = @[@"00:20", @"00:10", @"8"];
            break;
        case TrainModeMMA1:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                itemArr = @[@"01:00", @"00", @"17"];
            } else {
                itemArr = @[@"05:00", @"01:00", @"5"];
            }
            break;
        case TrainModeMMA2:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                itemArr = @[@"01:30", @"01:00", @"17"];
            } else {
                itemArr = @[@"05:00", @"01:00", @"3"];
            }
            break;
        case TrainModeFGB1:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                itemArr = @[@"05:00", @"01:00", @"5"];
            } else {
                itemArr = @[@"01:00", @"00", @"17"];
            }
            break;
        case TrainModeFGB2:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                itemArr = @[@"05:00", @"01:00", @"3"];
            } else {
                itemArr = @[@"01:30", @"01:00", @"17"];
            }
            break;
            
        default:
            break;
    }
    return itemArr;
}

+ (CGFloat)convertTimerModeTime:(TrainMode)mode {
    CGFloat mouse;
    switch (mode) {
        case TrainModeMIIT:
            mouse = 99*120.0;
            break;
        case TrainModeHIIT:
            mouse = 99*60.0;
            break;
        case TrainModeTABATA:
            mouse = 8*30.0;
            break;
        case TrainModeMMA1:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                mouse = 17*60.0;
            } else {
                mouse = 5*360.0;
            }
            break;
        case TrainModeMMA2:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                mouse = 17*150.0;
            } else {
                mouse = 3*360.0;
            }
            break;
        case TrainModeFGB1:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                mouse = 5*360.0;
            } else {
                mouse = 17*60.0;
            }
            break;
        case TrainModeFGB2:
            if ([ZCDataTool getTimerTypeStatus] == 1) {
                mouse = 3*360.0;
            } else {
                mouse = 17*150.0;
            }
            break;
            
        default:
            break;
    }
    return mouse;
}

+ (NSData *)downModeSetMouse:(NSInteger)mouse {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"Down:%tu", mouse]];
}

+ (NSString *)convertModeContentWithType:(NSString *)type {
    NSString *content;
    if ([type isEqualToString:@"HIIT"]) {
        content = NSLocalizedString(@"HIIT-Profile", nil);
    } else if ([type isEqualToString:@"MIIT"]) {
        content = NSLocalizedString(@"MIIT-Profile", nil);
    } else if ([type isEqualToString:@"TABATA"]) {
        content = NSLocalizedString(@"TABATA-Profile", nil);
    } else if ([type isEqualToString:@"MMA1"]) {
        content = NSLocalizedString(@"MMA1-Profile", nil);
    } else if ([type isEqualToString:@"MMA2"]) {
        content = NSLocalizedString(@"MMA2-Profile", nil);
    } else if ([type isEqualToString:@"FGB1"]) {
        content = NSLocalizedString(@"FGB1-Profile", nil);
    } else if ([type isEqualToString:@"FGB2"]) {        
        content = NSLocalizedString(@"FGB2-Profile", nil);
    } else {
        content = NSLocalizedString(@"WRC-Profile", nil);
    }
    return content;
}

+ (void)saveTimerBluthNameContent:(NSArray *)array {
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:@"kSaveTimerBluthNameContentKey"];
}
+ (BOOL)judgeTimerBluthNameWithContent:(NSString *)content {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSaveTimerBluthNameContentKey"];
    BOOL flag = NO;
    if ([content containsString:@"Timer0"]) {
        flag = YES;
    } else {
        if (array.count > 0) {
            for (int i = 0; i < array.count; i ++) {
                if ([content containsString:array[i]]) {
                    flag = YES;
                    break;
                }
            }
        } else {
            //Timer0    JSQ.
            if ([content containsString:@"Timer0"]) {
                flag = YES;
            }
        }
    }
    return flag;
}

+ (void)saveTrainDownStatus:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"kSaveTrainDownStatusKey"];
}
+ (BOOL)getTrainDownStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveTrainDownStatusKey"];
}


+ (void)saveTrainHour12Status:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"kSaveTrainHour12StatusKey"];
}
+ (BOOL)getTrainHour12Status {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kSaveTrainHour12StatusKey"];
}

+ (unsigned long long)convertHexToDecimal:(NSString *)hexStr {
    unsigned long long decimal = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexLongLong:&decimal];
    return decimal;
}
//设置运动模式
+ (NSData *)setSuitSportMode:(NSString *)mode {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"sport mode:%@", mode]];
}
//跳绳
+ (NSData *)getSuitRopeMode {
    return [self convertStringTOASCIIData:@"sport mode:2"];
}
//健腹轮
+ (NSData *)getSuitJFLMode {
    return [self convertStringTOASCIIData:@"sport mode:1"];
}
//拉力器
+ (NSData *)getSuitPowerMode {
    return [self convertStringTOASCIIData:@"sport mode:3"];
}

+ (NSData *)setSuitTimeMode:(NSString *)time {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"sport time:%@", time]];
}

+ (NSData *)setSuitNumMode:(NSString *)num {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"sport num:%@", num]];
}

+ (NSData *)setSuitSportState:(NSString *)state {
    return [self convertStringTOASCIIData:[NSString stringWithFormat:@"sport state:%@", state]];
}

+ (NSString *)convertSuitNameWithMode:(NSString *)mode {
    NSString *content;
    if ([mode integerValue] == 1) {
        content = NSLocalizedString(@"健腹轮", nil);
    } else if ([mode integerValue] == 2) {
        content = NSLocalizedString(@"跳绳", nil);
    } else {
        content = NSLocalizedString(@"拉力器", nil);
    }
    return content;
}

+ (NSData *)sendGetTokenContent {
    
    Byte bytes[] = {01, 01, 01, 00};
    return [self convertDataWithBytes:bytes];
}

+ (NSData *)convertDataWithBytes:(Byte *)bytes {
    return [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
}

+ (NSData *)sendStartStationOperate {
    Byte bytes[] = {0x02, 0x01, 0x02, 0x01, 0x01};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 5; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

+ (NSData *)sendStopStationOperate {
    Byte bytes[] = {0x02, 0x01, 0x02, 0x01, 0x02};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 5; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

+ (NSData *)sendBackRopeStationOperate {
    Byte bytes[] = {0x02, 0x01, 0x02, 0x01, 0x03};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 5; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}
//01 02 03 04 05 06
+ (NSData *)sendSportModeStationOperate:(NSString *)mode {
    NSMutableString *temStr = [NSMutableString stringWithString:@"03010211"];
    [temStr appendString:mode];
    return [self convertHexToByteData:temStr];
}

+ (NSData *)setDeviceSportMode:(NSString *)mode value:(NSString *)value {
    NSMutableString *temStr = [NSMutableString stringWithString:@"030103"];
    [temStr appendString:mode];
    [temStr appendString:value];
    return [self convertHexToByteData:temStr];
}
/// 向心模式
+ (NSData *)sendSportMode2StationOperate {
    //03 01 03 20 拉力设置
    Byte bytes[] = {0x03, 0x01, 0x03, 0x20};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}
/// 离心模式
+ (NSData *)sendSportMode3StationOperate {
    //03 01 03 21 收力设置
    Byte bytes[] = {0x03, 0x01, 0x03, 0x21};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}
/// 等速模式
+ (NSData *)sendSportMode4StationOperate {
    Byte bytes[] = {0x03, 0x01, 0x03, 0x22};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}
/// 弹力绳模式
+ (NSData *)sendSportMode5StationOperate {
    Byte bytes[] = {0x03, 0x01, 0x03, 0x23};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}
/// 划船模式
+ (NSData *)sendSportMode6StationOperate {
    ///03 01 03 24
    Byte bytes[] = {0x03, 0x01, 0x03, 0x24};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

+ (NSData *)convertHexToByteData:(NSMutableString *)str {
    NSString *token = checkSafeContent(kUserStore.tokenBytes);
    [str appendFormat:@"%@", token];
    return [self convertHexStrToData:str];
}

//將16進制的字符串轉換成NSData(bytes)
+ (NSMutableData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

/// 获取设备基本信息
+ (NSData *)sendGetDeviceInfoOrder {
    Byte bytes[] = {0x04, 0x01, 0x01, 0x01};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

/// 获取当前设备运动模式
+ (NSData *)sendGetSportCurrentModeInfo {
    Byte bytes[] = {0x04, 0x01, 0x01, 0x11};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

/// 获取当前运动速度
+ (NSData *)sendGetSportSpeedOrder {
    Byte bytes[] = {0x04, 0x01, 0x01, 0x15};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

/// 获取当前拉力
+ (NSData *)sendGetDevicePullForceOrder {
    Byte bytes[] = {0x04, 0x01, 0x01, 0x16};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}
//爆发力
+ (NSData *)sendGetPowerForceOrder {
    //04 01 01 1B
    Byte bytes[] = {0x04, 0x01, 0x01, 0x1B};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

/// 获取当前模式设定值
+ (NSData *)sendGetCurrentModeSetValueOrder {
    //04 01 01 12
    Byte bytes[] = {0x04, 0x01, 0x01, 0x12};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

//获取消耗卡路里
+ (NSData *)sendGetConsumeKcalOrder {
    Byte bytes[] = {0x04, 0x01, 0x01, 0x17};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}
//实际位置
+ (NSData *)getDeviceSportLocalData {
    Byte bytes[] = {0x04, 0x01, 0x01, 0x1A};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

//获取训练次数
+ (NSData *)sendGetTrainTimesOrder {
    Byte bytes[] = {0x04, 0x01, 0x01, 0x18};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

//语言设置
+ (NSData *)sendSetDeviceLanguageOrder:(NSString *)byte {
    Byte bytes[] = {0x03, 0x01, 0x02, 0x01};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    [temStr appendFormat:@"%@", byte];
    return [self convertHexToByteData:temStr];
}

+ (NSData *)getDeviceVersionInfo {
    NSMutableString *temStr = [NSMutableString stringWithString:@"04010110"];
    return [self convertHexToByteData:temStr];
}

//音量设置
+ (NSData *)sendSetDeviceVoiceOrder:(NSString *)byte {
    Byte bytes[] = {0x03, 0x01, 0x02, 0x02};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 4; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    [temStr appendFormat:@"%@", byte];
    return [self convertHexToByteData:temStr];
}

//重量单位设置
+ (NSData *)sendSetDeviceUnitOrder:(NSString *)byte {
    NSMutableString *temStr = [NSMutableString stringWithString:@"03010203"];
    [temStr appendFormat:@"%@", byte];
    return [self convertHexToByteData:temStr];
}

+ (NSData *)setPullPowerData {
    //C8 82  20KG
    //32 ec  5KG
    Byte bytes[] = {0x01, 0x52, 0x70, 0xF7, 0x00, 0x00, 0x00, 0x00, 0xC8, 0x82};
    NSMutableString *temStr = [NSMutableString string];
    for (int i = 0; i < 10; i ++) {
        [temStr appendFormat:@"%02x", bytes[i]];
    }
    return [self convertHexToByteData:temStr];
}

+ (NSData *)sendFilePackage:(NSString *)package content:(NSString *)content filename:(NSString *)filename total:(NSInteger)totalIndex currentIndex:(NSInteger)currentIndex bytes:(Byte *)bytes {
    NSInteger size = package.length / 2048;
    NSInteger length = content.length / 2;
    length = length + 26;
    NSMutableString *str = [NSMutableString stringWithString:@"0501"];
    [str appendString:[self ToHex:length]];
    [str appendString:@"01"];
    [str appendString:@"01"];
    [str appendString:filename];
    NSInteger remainIndex = (24 - filename.length)/2;
    for (int i = 0; i < remainIndex; i ++) {
        [str appendString:@"00"];
    }
    [self appendWitContent:[self ToHex:size] contain:str];
    //总包crc16
    unsigned short rc = 0;
    rc = GetCRC16(bytes, package.length/2, 0xFFFF);
    NSString *crcStr = [self ToHex:rc];
    [self appendWitContent:crcStr contain:str];
//    if(crcStr.length == 4) {
//        [str appendString:[crcStr substringWithRange:NSMakeRange(2, 2)]];
//        [str appendString:[crcStr substringWithRange:NSMakeRange(0, 2)]];
//    }
    
    [self appendWitContent:[self ToHex:totalIndex] contain:str];
    [self appendWitContent:[self ToHex:currentIndex] contain:str];
    
    //当前包crc16
    NSData *temData = [ZCBluthDataTool convertHexStrToData:content];
    Byte *temBytes = (Byte *)[temData bytes];
    unsigned short rc1 = 0;
    rc1 = GetCRC16(temBytes, temData.length, 0xFFFF);
    NSString *crcCcurrentStr = [self ToHex:rc1];
    [self appendWitContent:crcCcurrentStr contain:str];
//    if(crcCcurrentStr.length == 4) {
//        [str appendString:[crcCcurrentStr substringWithRange:NSMakeRange(2, 2)]];
//        [str appendString:[crcCcurrentStr substringWithRange:NSMakeRange(0, 2)]];
//    }
    [self appendWitContent:[self ToHex:content.length / 2] contain:str];
    [str appendString:content];
    NSLog(@"content:%@", str);
    return [self convertHexToByteData:str];
}

+ (void)appendWitContent:(NSString *)content contain:(NSMutableString *)str {
    NSMutableString *sizeTem = [NSMutableString string];
    for (int i = 0; i < 4-content.length; i ++) {
        [sizeTem appendString:@"0"];
    }
    [sizeTem appendString:content];
    [str appendString:[sizeTem substringWithRange:NSMakeRange(2, 2)]];
    [str appendString:[sizeTem substringWithRange:NSMakeRange(0, 2)]];
}

+ (NSData *)setStartUpdateWithType:(NSString *)type fileName:(NSString *)name {
    NSData *data;
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@%@", @"05010E02", type, name];    
    return [self convertHexToByteData:str];
}

/* CRC 高位字节值表 */
unsigned char auchCRCHi[256] = {
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40
    };
      
unsigned char auchCRCLo[256] = {
    0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06,
    0x07, 0xC7, 0x05, 0xC5, 0xC4, 0x04, 0xCC, 0x0C, 0x0D, 0xCD,
    0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09,
    0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A,
    0x1E, 0xDE, 0xDF, 0x1F, 0xDD, 0x1D, 0x1C, 0xDC, 0x14, 0xD4,
    0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3,
    0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3,
    0xF2, 0x32, 0x36, 0xF6, 0xF7, 0x37, 0xF5, 0x35, 0x34, 0xF4,
    0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A,
    0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 0x28, 0xE8, 0xE9, 0x29,
    0xEB, 0x2B, 0x2A, 0xEA, 0xEE, 0x2E, 0x2F, 0xEF, 0x2D, 0xED,
    0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26,
    0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60,
    0x61, 0xA1, 0x63, 0xA3, 0xA2, 0x62, 0x66, 0xA6, 0xA7, 0x67,
    0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F,
    0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68,
    0x78, 0xB8, 0xB9, 0x79, 0xBB, 0x7B, 0x7A, 0xBA, 0xBE, 0x7E,
    0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5,
    0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71,
    0x70, 0xB0, 0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92,
    0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C,
    0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B,
    0x99, 0x59, 0x58, 0x98, 0x88, 0x48, 0x49, 0x89, 0x4B, 0x8B,
    0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
    0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42,
    0x43, 0x83, 0x41, 0x81, 0x80, 0x40
    };
        
/*********************************************************************************/
/*函数名称: GetCRC16()
*输入参数：  共  个参数；
*输出参数：  共  个参数；
*返回值：
*需储存的参数： 共  个参数；
*功能介绍：
        (1)CRC16校验； 返回校验码；
*修改日志：
*[2005-11-28 16:40]    Ver. 1.00
        开始编写；
        完成；
*/
/*********************************************************************************/
  
unsigned short GetCRC16(unsigned char *puchMsg, unsigned short usDataLen, unsigned short first)
{
  unsigned char uchCRCHi = first ; /* 高CRC字节初始化 */
  unsigned char uchCRCLo = first >> 8 ; /* 低CRC 字节初始化 */
  unsigned uIndex = 0; /* CRC循环中的索引 */
      
  while (usDataLen--) /* 传输消息缓冲区 */
  {
    uIndex = uchCRCHi ^ *puchMsg++ ; /* 计算CRC */
    uchCRCHi = uchCRCLo ^ auchCRCHi[uIndex] ;
    uchCRCLo = auchCRCLo[uIndex] ;
  }
//    return (unsigned short)((unsigned short)uchCRCHi << 8 | uchCRCLo) ;
  return (unsigned short)((unsigned short)uchCRCLo << 8 | uchCRCHi) ;
}

/**
 十进制转十六进制

 @param tmpid 数据
 @return 结果
 */
+ (NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

/// 设置常规模式 离心力 向心力
/// @param content 设置数据
+ (NSData *)sendSportModePowerData:(NSString *)content {
    int powerNum = [content intValue] * 10;
    NSString *powerHex = [self ToHex:powerNum];
    powerHex = [self convertSetData:powerHex];
    NSString *hexStr = [NSString stringWithFormat:@"%@%@", @"015270F7000000", powerHex];
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    NSLog(@"setDataStr:%@", dataStr);
    return [self convertHexStrToData:dataStr];
}

/// 设置等速模式 0x7107  cm/s
/// @param content <#content description#>
+ (NSData *)sendSportModeSpeedData:(NSString *)content {
    
    int powerNum = [content intValue];
    NSString *powerHex = [self ToHex:powerNum];
    powerHex = [self convertSetData:powerHex];
    NSString *hexStr = [NSString stringWithFormat:@"%@%@", @"01527107000000", powerHex];
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    NSLog(@"setDataStr:%@", dataStr);
    return [self convertHexStrToData:dataStr];
}
//设置划船
+ (NSData *)sendSportGearModeData:(NSString *)content {
    int powerNum = [content intValue]*200;
    NSString *powerHex = [self ToHex:powerNum];
    powerHex = [self convertSetData:powerHex];
    NSString *hexStr = [NSString stringWithFormat:@"%@%@", @"01527106000000", powerHex];
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    NSLog(@"setDataStr:%@", dataStr);
    return [self convertHexStrToData:dataStr];
}

/// 设置弹力绳 0x7109  g/cm
/// @param content <#content description#>
+ (NSData *)sendSportModeRopeData:(NSString *)content {
    
    int powerNum = [content intValue];
    NSString *powerHex = [self ToHex:powerNum];
    powerHex = [self convertSetData:powerHex];
    NSString *hexStr = [NSString stringWithFormat:@"%@%@", @"01527109000000", powerHex];
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    NSLog(@"setDataStr:%@", dataStr);
    return [self convertHexStrToData:dataStr];
}

+ (NSString *)convertSetData:(NSString *)content {
    if(content.length == 4) {
    } else if (content.length == 3) {
        content = [NSString stringWithFormat:@"0%@", content];
    } else if (content.length == 2) {
        content = [NSString stringWithFormat:@"00%@", content];
    } else {
        content = [NSString stringWithFormat:@"000%@", content];
    }
    return content;
}

+ (NSData *)setCurrentSportMode:(NSString *)data {
    
    NSString *hexStr = [NSString stringWithFormat:@"%@%@", @"0151710800000000", data];
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    NSLog(@"dataStr:%@", dataStr);
    return [self convertHexStrToData:dataStr];
}

+ (NSData *)readSportPullModeData {
    NSString *hexStr = @"01A0710D0000000000";
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    return [self convertHexStrToData:dataStr];
}
+ (NSData *)readSportKcalModeData {
    NSString *hexStr = @"01A0710F0000000000";
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    return [self convertHexStrToData:dataStr];
}
+ (NSData *)readSportPowerModeData {
    NSString *hexStr = @"01A071010000000000";
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    return [self convertHexStrToData:dataStr];
}
+ (NSData *)readSportLocalModeData {
    NSString *hexStr = @"01A071110000000000";
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    return [self convertHexStrToData:dataStr];
}

+ (NSData *)startSportSingleMode {
    NSString *hexStr = @"015171160000000000";
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    return [self convertHexStrToData:dataStr];
}
+ (NSData *)stopSportSingleMode {
    NSString *hexStr = @"015171160000000004";
    int num = 0;
    for (int i = 0; i < hexStr.length / 2; i ++) {
        NSString *hex = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
//        NSLog(@"%@", hex);
        num += (int)strtoul([hex UTF8String], 0, 16);
    }
    NSString *transHex = [self ToHex:num];
    NSString *lowHex = [transHex substringFromIndex:transHex.length-2];
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", hexStr, lowHex];
    return [self convertHexStrToData:dataStr];
}

/// 获取当前速度
+ (NSData *)getCurrentModeSport {
    NSString *dataStr = @"01A0710C00000000001E";
    return [self convertHexStrToData:dataStr];
}

/// 获取当前拉力
+ (NSData *)getCurrentModePullSport {
    NSString *dataStr = @"01A0710D00000000001F";
    return [self convertHexStrToData:dataStr];
}

/// 拉力设置 kg
+ (NSArray *)getPowerPullConfigureData {
    NSMutableArray *temArr = [NSMutableArray array];
    if([[ZCPowerServer defaultBLEServer].unitStr isEqualToString:@"02"]) {
        for (int i = 12; i < 112; i ++) {
            [temArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else {
        for (int i = 5; i < 51; i ++) {
            [temArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return temArr;
}

/// 收力设置 kg
+ (NSArray *)getPowerPutConfigureData {
    NSMutableArray *temArr = [NSMutableArray array];
    if([[ZCPowerServer defaultBLEServer].unitStr isEqualToString:@"02"]) {
        for (int i = 12; i < 112; i ++) {
            [temArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else {
        for (int i = 5; i < 51; i ++) {
            [temArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return temArr;
}

/// 速度设置 cm/s
+ (NSArray *)getPowerSpeedConfigureData {
    NSMutableArray *temArr = [NSMutableArray array];
    for (int i = 10; i < 401; i ++) {
        [temArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return temArr;
}

/// 拉力系数设置 g/cm
+ (NSArray *)getPowerPullCoefficientConfigureData {
    NSMutableArray *temArr = [NSMutableArray array];
    for (int i = 50; i < 1001; i ++) {
        [temArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return temArr;
}

/// 划船阻力设置 g/cm
+ (NSArray *)getPowerBoatResistanceConfigureData {
    NSMutableArray *temArr = [NSMutableArray array];
    for (int i = 1; i < 11; i ++) {
        [temArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return temArr;
}

+ (NSArray *)convertDataWithMode:(NSInteger)mode {
    NSArray *dataArr;
    switch (mode) {
        case 0:
            dataArr = [self getPowerPullConfigureData];
            break;
        case 1://离心
            dataArr = [self getPowerPullConfigureData];
            break;
        case 2://向心
            dataArr = [self getPowerPutConfigureData];
            break;
        case 3://等速
            dataArr = [self getPowerSpeedConfigureData];
            break;
        case 4://弹力绳
            dataArr = [self getPowerPullCoefficientConfigureData];
            break;
        case 5://划船
            dataArr = [self getPowerBoatResistanceConfigureData];
            break;
            
        default:
            break;
    }
    return dataArr;
}

+ (NSString *)convertUnitTitleWithMode:(NSInteger)mode {
    NSString *title;
    switch (mode) {
        case 0:
            title = @"kg";
            break;
        case 1://离心
            title = @"kg";
            break;
        case 2://向心
            title = @"kg";
            break;
        case 3://等速
            title = @"cm/s";
            break;
        case 4://弹力绳
            title = @"g/cm";
            break;
        case 5://划船
            title = NSLocalizedString(@"档", nil);
            break;
            
        default:
            break;
    }
    return title;
}

+ (float)convertHexStrTopFloat:(NSString *)hexStr {
        
    NSData *dddtt = [self convertHexStrToData:hexStr];
    Byte*bytes = (Byte*)[dddtt bytes];
    float *p = (float *)bytes;
    printf("c->%g", *p);
    return *p;
}

@end
