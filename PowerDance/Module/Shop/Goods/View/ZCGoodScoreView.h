//
//  ZCGoodScoreView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/19.
//

#import <UIKit/UIKit.h>
#import "ZCStarRateView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCGoodScoreView : UIView

@property (nonatomic, copy) void(^saveScoreOperate)(CGFloat value);

@property (nonatomic,strong) ZCStarRateView *rateView;

@end

NS_ASSUME_NONNULL_END
