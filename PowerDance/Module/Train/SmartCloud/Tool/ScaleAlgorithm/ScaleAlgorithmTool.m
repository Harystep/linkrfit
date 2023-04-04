

#import "ScaleAlgorithmTool.h"
#import "CFFDataTool.h"

@implementation ScaleAlgorithmTool

+ (SicBiaAlgOutInfStr)scaleAlgorithToolWithNum:(double)weight Impedance:(NSInteger)Impedance upload:(BOOL)flag {
    SicBiaAlgOutInfStr body;
    SicBiaAlgInInfStr person;
    NSString *birtday = checkSafeContent(kUserStore.userData[@"age"]);
    NSInteger day = [birtday integerValue];
    if ([kUserStore.userData[@"sex"] integerValue] == 0) {
        person.Sex = SIC_MALE;
    } else {
        person.Sex = SIC_FEMALE;
    }
    NSString *weightData = [NSString stringWithFormat:@"%.0f", weight*100];
    person.Age = day * 10;
    person.Height = [checkSafeContent(kUserStore.userData[@"height"]) integerValue] * 10;
    person.Impedance = Impedance;
    person.Weight = [weightData doubleValue];
    person.Location = 0;
    person.HeartRate = 0;
    SicBiaErrType type = SIC_BIA_NONE;
    type = SicBiaAlg(&person, &body);
    NSLog(@"type--%d", type);
    NSLog(@"Height:%hu-Age:%hu-Impedance:%hu-Sex:%u-Weight:%hu", person.Height, person.Age, person.Impedance, person.Sex, person.Weight);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSmartCloudErrorKey" object:@(type)];    
    return body;
}

+ (SicBiaAlgOutInfStr)scaleAlgorithToolWithNum:(double)weight Impedance:(NSInteger)Impedance {
    SicBiaAlgOutInfStr body;
    SicBiaAlgInInfStr person;
    NSString *birtday = checkSafeContent(kUserStore.userData[@"age"]);
    NSInteger day = [birtday integerValue];
    if ([kUserStore.userData[@"sex"] integerValue] == 0) {
        person.Sex = SIC_MALE;
    } else {
        person.Sex = SIC_FEMALE;
    }
    NSString *weightData = [NSString stringWithFormat:@"%.0f", weight*100];
    person.Age = day * 10;
    person.Height = [checkSafeContent(kUserStore.userData[@"height"]) integerValue] * 10;
    person.Impedance = Impedance;
    person.Weight = [weightData doubleValue];
    person.Location = 0;
    person.HeartRate = 0;
    SicBiaErrType type = SIC_BIA_NONE;
    type = SicBiaAlg(&person, &body);
    NSLog(@"type--%d", type);
    NSLog(@"Height:%hu-Age:%hu-Impedance:%hu-Sex:%u-Weight:%hu", person.Height, person.Age, person.Impedance, person.Sex, person.Weight);    
    return body;
}

+ (SicBiaAlgOutInfStr)scaleAlgorithToolWithNum:(NSInteger)weight {
    SicBiaAlgOutInfStr body;
    SicBiaAlgInInfStr person;
    NSString *birtday = checkSafeContent(kUserStore.userData[@"age"]);
//    NSString *now = [NSDate br_getDateString:[NSDate date] format:@"yyyy-MM-dd"];
    NSInteger day = [birtday integerValue];
//    [[now substringWithRange:NSMakeRange(0, 4)] integerValue] - [[birtday substringWithRange:NSMakeRange(0, 4)] integerValue];
    if ([kUserStore.userData[@"sex"] integerValue] == 0) {
        person.Sex = SIC_MALE;
    } else {
        person.Sex = SIC_FEMALE;
    }
    person.Age = day * 10;
    person.Height = [checkSafeContent(kUserStore.userData[@"height"]) integerValue] * 10;
    person.Impedance = 500;
    person.Weight = weight * 100;    
    person.Location = 0;
    person.HeartRate = 0;
    SicBiaErrType type = SIC_BIA_NONE;
    type = SicBiaAlg(&person, &body);
    NSLog(@"type--%d", type);
    if (type != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSmartCloudErrorKey" object:nil];
    }
    return body;
}

+ (NSInteger)algorithToolNumWithPreNum:(NSString *)num endNum:(NSString *)endNum {
    NSInteger count;
    num = [NSString stringWithFormat:@"%@00", [self ToHex:[num integerValue]]];
    count = strtoul(num.UTF8String, 0, 16) + [endNum integerValue];
    return count;
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


+ (NSInteger)BMIStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UILabel *)lb {
    NSInteger status; //偏低 标准 偏高 超高
    if (outInfo.BMI > outInfo.bmi_l_dp[0] && outInfo.BMI <= outInfo.bmi_l_dp[1]) {
        status = 1;
        lb.text = [NSString stringWithFormat:@"%.1f", (outInfo.bmi_l_dp[1] - outInfo.BMI)/100.0];
    } else if (outInfo.BMI > outInfo.bmi_l_dp[1] && outInfo.BMI <= outInfo.bmi_l_dp[2]) {
        status = 2;
        lb.text = @"--";
    } else if (outInfo.BMI > outInfo.bmi_l_dp[2] && outInfo.BMI <= outInfo.bmi_l_dp[3]) {
        status = 3;
        lb.text = [NSString stringWithFormat:@"%.1f", (outInfo.BMI - outInfo.bmi_l_dp[2])/100.0];
    } else if (outInfo.BMI > outInfo.bmi_l_dp[3] && outInfo.BMI <= outInfo.bmi_l_dp[4]) {
        status = 4;
        lb.text = [NSString stringWithFormat:@"%.1f", (outInfo.BMI - outInfo.bmi_l_dp[2])/100.0];
    } else {
        status = 5;
        lb.text = @"--";
    }
    return status;
}
+ (NSInteger)BFRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UILabel *)lb {
    NSInteger status;//标准 警戒 偏高 危险
    if (outInfo.BFR > outInfo.bfr_l_dp[0] && outInfo.BFR <= outInfo.bfr_l_dp[1]) {
        status = 1;
        lb.text = @"--";
    } else if (outInfo.BFR > outInfo.bfr_l_dp[1] && outInfo.BFR <= outInfo.bfr_l_dp[2]) {
        status = 2;
        lb.text = @"--";
//        [NSString stringWithFormat:@"%.2f", (outInfo.BFR - outInfo.bfr_l_dp[1])/10000.0];
    } else if (outInfo.BFR > outInfo.bfr_l_dp[2] && outInfo.BFR <= outInfo.bfr_l_dp[3]) {
        status = 3;
        lb.text = [NSString stringWithFormat:@"%.2f", (outInfo.BFR - outInfo.bfr_l_dp[2])/10000.0];
    } else if (outInfo.BFR > outInfo.bfr_l_dp[3] && outInfo.BFR <= outInfo.bfr_l_dp[4]) {
        status = 4;
        lb.text = [NSString stringWithFormat:@"%.2f", (outInfo.BFR - outInfo.bfr_l_dp[2])/10000.0];
    } else {
        status = 5;
    }
    return status;
}
+ (NSInteger)SLMStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UILabel *)lb {
    NSInteger status;//偏低 标准 优
    if (outInfo.SLM > outInfo.slm_l_dp[0] && outInfo.SLM <= outInfo.slm_l_dp[1]) {
        status = 1;
        lb.text = [NSString stringWithFormat:@"%.1f", (outInfo.slm_l_dp[1] - outInfo.BMI)/100.0];
    } else if (outInfo.SLM > outInfo.slm_l_dp[1] && outInfo.SLM <= outInfo.slm_l_dp[2]) {
        status = 2;
        lb.text = @"--";
    } else if (outInfo.SLM > outInfo.slm_l_dp[2] && outInfo.SLM <= outInfo.slm_l_dp[3]) {
        status = 3;
        lb.text = @"--";
    } else {
        status = 1;
    }
    return status;
}

+ (void)BMRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    if (outInfo.BMR >= outInfo.bmr_l_dp[0]&&outInfo.BMR < outInfo.bmr_l_dp[1]) {
        icon.image = kIMAGE(@"home_standard_down");
    } else if (outInfo.BMR >= outInfo.bmr_l_dp[1]&&outInfo.BMR < outInfo.bmr_l_dp[2]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else {
        icon.image = kIMAGE(@"home_standard_up");
    }
}
+ (void)SCOREStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    
}
+ (void)AgeStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    
}
+ (void)typeStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    if (outInfo.BOD < outInfo.bod_l_dp[2]) {
        icon.image = kIMAGE(@"home_standard_down");
    } else if (outInfo.BOD >= outInfo.bod_l_dp[2]&&outInfo.BOD < outInfo.bod_l_dp[3]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else {
        icon.image = kIMAGE(@"home_standard_up");
    }
}

+ (void)SBWStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    if (outInfo.SBW >= outInfo.bfw_l_dp[0] && outInfo.SBW < outInfo.bfw_l_dp[2]) {
        icon.image = kIMAGE(@"home_standard_down");
    } else if (outInfo.SBW >= outInfo.bfw_l_dp[2] && outInfo.SBW < outInfo.bfw_l_dp[3]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else {
        icon.image = kIMAGE(@"home_standard_up");
    }
}
+ (void)VFRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    //标准 警戒 偏高 危险
    if (outInfo.VFR >= outInfo.vfr_l_dp[0]&&outInfo.VFR < outInfo.vfr_l_dp[1]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else if (outInfo.VFR >= outInfo.vfr_l_dp[1]&&outInfo.VFR < outInfo.vfr_l_dp[2]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else if (outInfo.VFR >= outInfo.vfr_l_dp[2]&&outInfo.VFR < outInfo.vfr_l_dp[3]) {
        icon.image = kIMAGE(@"home_standard_up");
    } else {
        icon.image = kIMAGE(@"home_standard_up");
    }
}
+ (void)BPRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
   
    if (outInfo.BPR >= outInfo.bpr_l_dp[0] && outInfo.BPR < outInfo.bpr_l_dp[1]) {
        icon.image = kIMAGE(@"home_standard_down");
    } else if (outInfo.BPR >= outInfo.bpr_l_dp[1] && outInfo.BPR < outInfo.bpr_l_dp[2]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else {
        icon.image = kIMAGE(@"home_standard_up");
    }
   
}
+ (void)BMCStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    //偏低 标准 优
    if (outInfo.BMC >= outInfo.bmc_l_dp[0] && outInfo.BMC < outInfo.bmc_l_dp[1]) {
        icon.image = kIMAGE(@"home_standard_down");
    } else if (outInfo.BMC >= outInfo.bmc_l_dp[1] && outInfo.BMC < outInfo.bmc_l_dp[2]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else {
        icon.image = kIMAGE(@"home_data_standard");
    }
}
+ (void)BWRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon {
    //偏低 标准 良好
    if (outInfo.BWR >= outInfo.bwr_l_dp[0] && outInfo.BWR < outInfo.bwr_l_dp[1]) {
        icon.image = kIMAGE(@"home_standard_down");
    } else if (outInfo.BWR >= outInfo.bwr_l_dp[1] && outInfo.BWR < outInfo.bwr_l_dp[2]) {
        icon.image = kIMAGE(@"home_data_standard");
    } else {
        icon.image = kIMAGE(@"home_data_standard");
    }
}

+ (NSString *)bodyTypeWithBackType:(NSInteger)type {
    NSString *content;
    switch (type) {
        case 0:
            content = @"--";
            break;
        case 1:
            content = @"偏瘦型";
            break;
        case 2:
            content = @"偏瘦肌肉型";
            break;
        case 3:
            content = @"肌肉发达型";
            break;
        case 4:
            content = @"缺乏锻炼型";
            break;
        case 5:
            content = @"标准型";
            break;
        case 6:
            content = @"标准肌肉型";
            break;
        case 7:
            content = @"隐形胖";
            break;
        case 8:
            content = @"肥胖型";
            break;
        case 9:
            content = @"肥胖肌肉型";
            break;
            
        default:
            break;
    }
    return content;
}

+ (NSString *)fatSystemTypeWithBackType:(NSInteger)type {
    NSString *content;
    switch (type) {
        case 0:
            content = @"--";
            break;
        case 5:
            content = NSLocalizedString(@"fat-标准", nil);
            break;
        case 6:
            content = NSLocalizedString(@"警戒", nil);
            break;
        case 7:
            content = NSLocalizedString(@"fat-偏高", nil);
            break;
        case 8:
            content = NSLocalizedString(@"危险", nil);
            break;
            
        default:
            break;
    }
    return content;
}
/*
 SIC_BIA_NONE         = 0,  // 无报错
 SIC_BIA_POINTER_NULL = 1,  // 输入结构体指针为空
 SIC_BIA_AGE_L        = 2,  // 年龄过小
 SIC_BIA_AGE_H        = 3,  // 年龄过大
 SIC_BIA_HEIGHT_L     = 4,  // 身高过低
 SIC_BIA_HEIGHT_H     = 5,  // 身高过高
 SIC_BIA_WEIGHT_L     = 6,  // 体重过轻
 SIC_BIA_WEIGHT_H     = 7,  // 体重过重
 SIC_BIA_IMPEDANCE_L  = 8,  // 阻抗过小
 SIC_BIA_IMPEDANCE_H  = 9,  // 阻抗过大
 SIC_BIA_BMI_L        = 10, // BMI过低
 SIC_BIA_INPUTERR     = 11, // 输入错误*/
+ (NSString *)checkErrorTypeWithBackType:(NSInteger)type {
    NSString *content = NSLocalizedString(@"请检查您设置的个人信息", nil);
    NSLog(@"type=====>%tu", type);
    switch (type) {
        case 1:
            
            break;
        case 2:
            content = NSLocalizedString(@"年龄过小", nil);
            break;
        case 3:
            content = NSLocalizedString(@"年龄过大", nil);
            break;
        case 4:
            content = NSLocalizedString(@"身高过低", nil);
            break;
        case 5:
            content = NSLocalizedString(@"身高过高", nil);
            break;
        case 6:
            content = NSLocalizedString(@"体重过轻", nil);
            break;
        case 7:
            content = NSLocalizedString(@"体重过重", nil);
            break;
        case 8:
            content = NSLocalizedString(@"为了数据准确性，请光脚上秤", nil);
            break;
        case 9:
            content = NSLocalizedString(@"为了数据准确性，请光脚上秤", nil);
            break;
        case 10:
            content = NSLocalizedString(@"BMI过低", nil);
            break;
        case 11:
            content = NSLocalizedString(@"体重过轻", nil);
            break;
            
        default:
            break;
    }
    return content;
}

@end
