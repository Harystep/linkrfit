//
//  CFFHUD.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/22.
//

#import <UIKit/UIKit.h>

#import "CFFPopupView.h"


NS_ASSUME_NONNULL_BEGIN

@interface CFFHud : CFFPopupView

+ (void)showSuccessWithTitle:(NSString *)title;

+ (void)showErrorWithTitle:(NSString *)title;

+ (void)showLoadingWithTitle:(NSString *)title;

+ (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
