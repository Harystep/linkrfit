//
//  UILabel+Exta.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Exta)

- (void)setContentLineFeedStyle;

- (void)setFontBold:(CGFloat)font;

- (void)setAttributeStringContent:(NSString *)text space:(CGFloat)space font:(UIFont *)font alignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
