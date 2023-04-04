//
//  ZCShopOrderExenView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OrderTypeWaiting = 0,
    OrderTypeComplete,
} OrderType;

@interface ZCShopOrderExenView : UIView

@property (nonatomic,assign) OrderType type;

@end

NS_ASSUME_NONNULL_END
