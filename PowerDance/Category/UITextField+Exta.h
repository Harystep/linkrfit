//
//  UITextField+Exta.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Exta)

- (NSMutableAttributedString *)attributedText:(NSString *)content color:(UIColor *)color font:(CGFloat)font;

@end

NS_ASSUME_NONNULL_END
