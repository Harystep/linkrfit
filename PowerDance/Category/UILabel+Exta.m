//
//  UILabel+Exta.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "UILabel+Exta.h"

@implementation UILabel (Exta)

- (void)setContentLineFeedStyle {
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setAttributeStringContent:(NSString *)text space:(CGFloat)space font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //关键代码
    paragraphStyle.alignment = alignment;
    [paragraphStyle setLineSpacing:space];//设置距离
    [attriString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];
    self.attributedText = attriString;
}

- (void)setFontBold:(CGFloat)font {
    self.font = FONT_BOLD(font);
}

@end
