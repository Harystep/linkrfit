//
//  ZCBluthDataTool.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/7.
//

#import "ZCBluthDataTool.h"

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

@end
