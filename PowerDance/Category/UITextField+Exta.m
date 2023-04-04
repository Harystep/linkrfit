//
//  UITextField+Exta.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "UITextField+Exta.h"

@implementation UITextField (Exta)

- (NSMutableAttributedString *)attributedText:(NSString *)content color:(UIColor *)color font:(CGFloat)font {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:FONT_SYSTEM(font),
                                            NSForegroundColorAttributeName:color
    }];
    return attr;
}

@end
