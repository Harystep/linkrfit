//
//  NSString+ZCHelper.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/23.
//

#import "NSString+ZCHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ZCHelper)

- (BOOL)isAvailable {
    return self && ![self isEqualToString:@""];
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

- (CGSize)sizeForFont:(UIFont *)font {
    // 根据字体得到NSString的尺寸
    CGSize size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    return size;;
}

- (NSString *)noExtraSpace {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)safeStringWithConetent:(NSString *)content {
    NSString *safe = @"";
    if ([content isKindOfClass:[NSNull class]]) {
        safe = @"";
    } else if (content == nil) {
        safe = @"";
    } else {
        safe = [NSString stringWithFormat:@"%@", content];
    }
    return safe;
}

+ (NSString *)safeFloatNumWithContent:(NSString *)content {
    NSString *safe = [NSString stringWithFormat:@"%@", content];
    if ([content isKindOfClass:[NSNull class]]) {
        safe = @"";
    } else if (content == nil) {
        safe = @"0";
    }
    return safe;
}

+ (NSString *)getCurrentDate {
    NSDate *datenow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

+ (NSString *)getCurrentDateWithFarmot:(NSString *)farmot {
    NSDate *datenow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:farmot];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

// 单个范围内设置字体大小
- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font andRange:(NSRange)range {
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    
    if ([self checkRange:range] == RangeCorrect) {
        
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        } else {
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}

- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font color:(UIColor *)color andRange:(NSRange)range {
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    
    if ([self checkRange:range] == RangeCorrect) {
        if (font) {
            [attributedStr addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color} range:range];
        } else {
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}


// 单个范围内设置字体大小
- (NSMutableAttributedString *)dn_changeColor:(UIColor *)color andRange:(NSRange)range {
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    
    if ([self checkRange:range] == RangeCorrect) {
        
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        } else {
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}

- (RangeFormatType)checkRange:(NSRange)range {
    NSInteger loc = range.location;
    NSInteger len = range.length;
    
    if (loc >= 0 && len > 0) {
        
        if (loc + len <= self.length) {
            
            return RangeCorrect;
        }else{
            NSLog(@"The range out-of-bounds!");
            return RangeOut;
        }
    }else{
        NSLog(@"The range format is wrong: NSMakeRange(a,b) (a>=0,b>0). ");
        return RangeError;
    }
}

+ (NSString *)getTimeWithData:(NSDate *)date farmot:(NSString *)farmot {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:farmot];
    NSString *currentTimeString = [formatter stringFromDate:date];
    return currentTimeString;
}

+ (NSString *)convertYMDHMStringWithContent:(NSString *)content {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:content];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
}

+ (NSString *)convertYMDStringWithContent:(NSString *)content {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:content];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
}

+ (NSInteger)acquireWeekDayFromDate:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitWeekday;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:date];
    return [comps weekday];
}
 
+ (NSString *)acquireWeekDayFromString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:str];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitWeekday;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:date];
    //从周日开始,周日为1,周一为2,以此类推
    //    NSLog(@"%ld", [comps weekday]);
    return [self convertWeekDay:[comps weekday]];
}

+ (NSString *)convertWeekDay:(NSInteger)weekday {
    
    NSString *content;
    switch (weekday) {
        case 1:
            content = @"日";
            break;
            
        case 2:
            content = @"一";
            break;
            
        case 3:
            content = @"二";
            break;
            
        case 4:
            content = @"三";
            break;
            
        case 5:
            content = @"四";
            break;
            
        case 6:
            content = @"五";
            break;
            
        case 7:
            content = @"六";
            break;
            
        default:
            break;
    }
    return content;
}

/** 隐藏证件号指定位数字（如：360723********6341） */
- (nullable NSString *)dn_hideCharacters:(NSUInteger)location length:(NSUInteger)length {
    if (self.length > length && length > 0) {
        if (self.length >= location+length) {
            NSMutableString *str = [[NSMutableString alloc] init];
            for (NSInteger i = 0; i < length; i++) {
                [str appendString:@"*"];
            }
            return [self stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:[str copy]];
        } else {
            return self;
        }
    }
    return self;
}

@end
