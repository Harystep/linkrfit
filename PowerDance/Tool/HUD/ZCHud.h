//
//  CFFAlertView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZCHudPositionTypeTop = 0,
    ZCHudPositionTypeCenter,
    ZCHudPositionTypeBottom,
} ZCHudPositionType;

@interface ZCHud : UIView

+ (instancetype)sharedInstance;

- (void)showTextMsg:(NSString *)content;

- (void)showTextMsg:(NSString *)content dispaly:(NSInteger)secord;

- (void)showTextMsg:(NSString *)content dispaly:(NSInteger)secord position:(ZCHudPositionType)type;

@end

NS_ASSUME_NONNULL_END
