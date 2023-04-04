//
//  NSString+ZCHelper.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief range的校验结果
 */
typedef enum
{
    RangeCorrect = 0,
    RangeError = 1,
    RangeOut = 2,
    
}RangeFormatType;

@interface NSString (ZCHelper)

- (BOOL)isAvailable;

- (NSString *)md5;

- (CGSize)sizeForFont:(UIFont *)font;
//去除首尾空格
- (NSString *)noExtraSpace;

+ (NSString *)safeStringWithConetent:(NSString *)content;

+ (NSString *)safeFloatNumWithContent:(NSString *)content;

+ (NSString *)getCurrentDate;

+ (NSString *)getCurrentDateWithFarmot:(NSString *)farmot;

+ (NSString *)getTimeWithData:(NSDate *)date farmot:(NSString *)farmot;

- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font andRange:(NSRange)range;

- (NSMutableAttributedString *)dn_changeColor:(UIColor *)color andRange:(NSRange)range;

- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font color:(UIColor *)color andRange:(NSRange)range;

+ (NSString *)convertYMDHMStringWithContent:(NSString *)content;

+ (NSString *)convertYMDStringWithContent:(NSString *)content;

/// 根据NSDate 判断是周几
/// @param date <#date description#>
+ (NSInteger)acquireWeekDayFromDate:(NSDate*)date;

/// 根据NSString 判断是周几
/// @param str <#str description#>
+ (NSString *)acquireWeekDayFromString:(NSString*)str;

- (nullable NSString *)dn_hideCharacters:(NSUInteger)location length:(NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
