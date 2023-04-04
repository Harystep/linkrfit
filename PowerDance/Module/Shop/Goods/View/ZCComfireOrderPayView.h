//
//  ZCComfireOrderPayView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PayTypeAlipay  = 0 ,
    PayTypeWeChat,
        
} PayType;

@interface ZCComfireOrderPayView : UIView

@property (nonatomic,assign) PayType type;

@end

NS_ASSUME_NONNULL_END
