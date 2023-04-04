//
//  CFFAlertView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFAlertView : UIView

+ (instancetype)sharedInstance;

- (void)showTextMsg:(NSString *)content;

- (void)showTextMsg:(NSString *)content dispaly:(NSInteger)secord;

@end

NS_ASSUME_NONNULL_END
