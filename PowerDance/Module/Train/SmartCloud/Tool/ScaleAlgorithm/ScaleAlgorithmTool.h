//
//  ScaleAlgorithmTool.h
//  ForceFree
//
//  Created by PC-N121 on 2021/9/26.
//

#import <Foundation/Foundation.h>
#import "SicBiaAlgInterface.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScaleAlgorithmTool : NSObject

+ (SicBiaAlgOutInfStr)scaleAlgorithToolWithNum:(NSInteger)weight;
+ (SicBiaAlgOutInfStr)scaleAlgorithToolWithNum:(double)weight Impedance:(NSInteger)Impedance upload:(BOOL)flag;
+ (SicBiaAlgOutInfStr)scaleAlgorithToolWithNum:(double)weight Impedance:(NSInteger)Impedance;
+ (NSInteger)algorithToolNumWithPreNum:(NSString *)num endNum:(NSString *)endNum;

+ (NSInteger)BMIStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UILabel *)lb;
+ (NSInteger)BFRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UILabel *)lb;
+ (NSInteger)SLMStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UILabel *)lb;
/*
 unsigned short BWR;       // 水分率 %（保留两位小数，即输出为实际数值的10000倍）（0-10000）
 unsigned short BMC;       // 骨含量（骨盐含量）KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
 unsigned short SLM;       // 肌肉含量 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
 unsigned short SMC;       // 骨骼肌含量 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
 unsigned short BPR;       // 蛋白质率 %（保留两位小数，即输出为实际数值的10000倍）（0-10000）
 unsigned short VFR;       // 内脏脂肪等级（保留两位小数，即输出为实际数值的100倍）
 unsigned short SBW;       // 标准体重 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
 //unsigned short IBW;       // 理想体重 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
 unsigned short BMR;       // 基础代谢率 Kcal/m*m（不放大）
 unsigned short BPM;       // 心率（保留两位小数，即输出为实际数值的100倍）
 //相关重量控制参数
 short          BOD;       // 肥胖度 %（保留两位小数，即输出为实际数值的10000倍）（-10000-32000）
 short          WTC;       // 体重控制 KG（保留两位小数，即输出为实际数值的100倍）（-16000~16000）
 short          FTC;       // 脂肪控制 KG（保留两位小数，即输出为实际数值的100倍）（-16000~16000）
 short          MTC;       // 肌肉控制 KG（保留两位小数，即输出为实际数值的100倍）（-16000~16000）
 //最后两个参数
 unsigned char PhyAge;     // 生理年龄
 unsigned char SCORE;      // 身体评分
 */
+ (void)BMRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)SCOREStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)AgeStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)SBWStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)VFRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)BPRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)BMCStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)BWRStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;
+ (void)typeStatusWithBody:(SicBiaAlgOutInfStr)outInfo view:(UIImageView *)icon;

+ (NSString *)bodyTypeWithBackType:(NSInteger)type;
+ (NSString *)fatSystemTypeWithBackType:(NSInteger)type;
+ (NSString *)checkErrorTypeWithBackType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
