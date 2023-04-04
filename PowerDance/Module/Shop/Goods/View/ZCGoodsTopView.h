//
//  ZCGoodsTopView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "ZCGoodsCenterView.h"
@class ZCShopGoodsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCGoodsTopView : UIView

@property (nonatomic,strong) ZCShopGoodsModel *model;

@property (nonatomic,strong) ZCGoodsCenterView *centerView;

@end

NS_ASSUME_NONNULL_END
