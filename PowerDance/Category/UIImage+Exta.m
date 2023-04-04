//
//  UIImage+Exte.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "UIImage+Exta.h"

@implementation UIImage (Exta)

/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat )alpha image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
     
}

+ (UIImage *)cff_imageWithColor:(UIColor *)color size:(CGSize)size {
    color = color ?: [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)cff_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    return [self cff_generateCornerRadiusImage:[self cff_imageWithColor:color size:size] cornerRadius:cornerRadius];
}

+ (UIImage *)cff_generateCornerRadiusImage:(UIImage *)original cornerRadius:(CGFloat)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, original.size.width, original.size.height);
    CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius].CGPath);
    CGContextClip(ctx);
    [original drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
