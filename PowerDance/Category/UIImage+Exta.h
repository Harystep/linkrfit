//
//  UIImage+Exte.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Exta)

+ (UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image;

+ (UIImage *)cff_imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)cff_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
