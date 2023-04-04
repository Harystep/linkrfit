//
//  CFFDataTool.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/4.
//

#import "CFFDataTool.h"

@implementation CFFDataTool

+ (NSArray *)convertWeightData {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 40; i < 200; i ++) {
        [dataArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return dataArr;
}
+ (NSArray *)convertHeightData {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 130; i < 240; i ++) {
        [dataArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return dataArr;
}

+ (NSArray *)convertAgeData {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 12; i < 150; i ++) {
        [dataArr addObject:[NSString stringWithFormat:@"%d%@", i, NSLocalizedString(@"岁", nil)]];
    }
    return dataArr;
}

+ (NSString *)convertKgToLb:(double)value {
    double lb = value / 0.453;
    return [NSString stringWithFormat:@"%.1f", lb];
}

+ (NSString *)reviseString:(NSString *)string {
    /* 直接传入精度丢失有问题的Double类型*/
    double conversionValue = (double)[string doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (double)convertMaxNumWithArray:(NSArray *)dataArr key:(NSString *)key {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        [array addObject:[CFFDataTool reviseString:dic[key]]];
    }
    CGFloat maxValue = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
    return maxValue;
}

@end
