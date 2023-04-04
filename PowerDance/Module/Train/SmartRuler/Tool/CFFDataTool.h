//
//  CFFDataTool.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFDataTool : NSObject

+ (NSArray *)convertWeightData;
+ (NSArray *)convertHeightData;
+ (NSArray *)convertAgeData;
+ (NSString *)convertKgToLb:(double)value;
+ (NSString *)reviseString:(NSString *)string;
+ (double)convertMaxNumWithArray:(NSArray *)dataArr key:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
