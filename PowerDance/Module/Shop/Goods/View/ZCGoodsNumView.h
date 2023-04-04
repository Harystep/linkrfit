//
//  ZCGoodsNumView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCGoodsNumView : UIView

@property (nonatomic, copy) void(^selectGoodsNumBlock)(NSString *value);

@property (nonatomic,strong) UITextField *numF;

@end

NS_ASSUME_NONNULL_END
